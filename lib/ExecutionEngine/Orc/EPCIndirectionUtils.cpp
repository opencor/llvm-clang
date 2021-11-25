//===------- EPCIndirectionUtils.cpp -- EPC based indirection APIs --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/ExecutionEngine/Orc/EPCIndirectionUtils.h"

#include "llvm/ExecutionEngine/Orc/ExecutorProcessControl.h"
#include "llvm/Support/MathExtras.h"

#include <future>

using namespace llvm;
using namespace llvm::orc;

namespace llvm {
namespace orc {

class EPCIndirectionUtilsAccess {
public:
  using IndirectStubInfo = EPCIndirectionUtils::IndirectStubInfo;
  using IndirectStubInfoVector = EPCIndirectionUtils::IndirectStubInfoVector;

  static Expected<IndirectStubInfoVector>
  getIndirectStubs(EPCIndirectionUtils &EPCIU, unsigned NumStubs) {
    return EPCIU.getIndirectStubs(NumStubs);
  };
};

} // end namespace orc
} // end namespace llvm

namespace {

class EPCTrampolinePool : public TrampolinePool {
public:
  EPCTrampolinePool(EPCIndirectionUtils &EPCIU);
  Error deallocatePool();

protected:
  Error grow() override;

  using Allocation = jitlink::JITLinkMemoryManager::Allocation;

  EPCIndirectionUtils &EPCIU;
  unsigned TrampolineSize = 0;
  unsigned TrampolinesPerPage = 0;
  std::vector<std::unique_ptr<Allocation>> TrampolineBlocks;
};

class EPCIndirectStubsManager : public IndirectStubsManager,
                                private EPCIndirectionUtilsAccess {
public:
  EPCIndirectStubsManager(EPCIndirectionUtils &EPCIU) : EPCIU(EPCIU) {}

  Error deallocateStubs();

  Error createStub(StringRef StubName, JITTargetAddress StubAddr,
                   JITSymbolFlags StubFlags) override;

  Error createStubs(const StubInitsMap &StubInits) override;

  JITEvaluatedSymbol findStub(StringRef Name, bool ExportedStubsOnly) override;

  JITEvaluatedSymbol findPointer(StringRef Name) override;

  Error updatePointer(StringRef Name, JITTargetAddress NewAddr) override;

private:
  using StubInfo = std::pair<IndirectStubInfo, JITSymbolFlags>;

  std::mutex ISMMutex;
  EPCIndirectionUtils &EPCIU;
  StringMap<StubInfo> StubInfos;
};

EPCTrampolinePool::EPCTrampolinePool(EPCIndirectionUtils &EPCIU)
    : EPCIU(EPCIU) {
  auto &EPC = EPCIU.getExecutorProcessControl();
  auto &ABI = EPCIU.getABISupport();

  TrampolineSize = ABI.getTrampolineSize();
  TrampolinesPerPage =
      (EPC.getPageSize() - ABI.getPointerSize()) / TrampolineSize;
}

Error EPCTrampolinePool::deallocatePool() {
  Error Err = Error::success();
  for (auto &Alloc : TrampolineBlocks)
    Err = joinErrors(std::move(Err), Alloc->deallocate());
  return Err;
}

Error EPCTrampolinePool::grow() {
  assert(AvailableTrampolines.empty() &&
         "Grow called with trampolines still available");

  auto ResolverAddress = EPCIU.getResolverBlockAddress();
  assert(ResolverAddress && "Resolver address can not be null");

  auto &EPC = EPCIU.getExecutorProcessControl();
  constexpr auto TrampolinePagePermissions =
      static_cast<sys::Memory::ProtectionFlags>(sys::Memory::MF_READ |
                                                sys::Memory::MF_EXEC);
  auto PageSize = EPC.getPageSize();
  jitlink::JITLinkMemoryManager::SegmentsRequestMap Request;
  Request[TrampolinePagePermissions] = {PageSize, static_cast<size_t>(PageSize),
                                        0};
  auto Alloc = EPC.getMemMgr().allocate(nullptr, Request);

  if (!Alloc)
    return Alloc.takeError();

  unsigned NumTrampolines = TrampolinesPerPage;

  auto WorkingMemory = (*Alloc)->getWorkingMemory(TrampolinePagePermissions);
  auto TargetAddress = (*Alloc)->getTargetMemory(TrampolinePagePermissions);

  EPCIU.getABISupport().writeTrampolines(WorkingMemory.data(), TargetAddress,
                                         ResolverAddress, NumTrampolines);

  auto TargetAddr = (*Alloc)->getTargetMemory(TrampolinePagePermissions);
  for (unsigned I = 0; I < NumTrampolines; ++I)
    AvailableTrampolines.push_back(TargetAddr + (I * TrampolineSize));

  if (auto Err = (*Alloc)->finalize())
    return Err;

  TrampolineBlocks.push_back(std::move(*Alloc));

  return Error::success();
}

Error EPCIndirectStubsManager::createStub(StringRef StubName,
                                          JITTargetAddress StubAddr,
                                          JITSymbolFlags StubFlags) {
  StubInitsMap SIM;
  SIM[StubName] = std::make_pair(StubAddr, StubFlags);
  return createStubs(SIM);
}

Error EPCIndirectStubsManager::createStubs(const StubInitsMap &StubInits) {
  auto AvailableStubInfos = getIndirectStubs(EPCIU, StubInits.size());
  if (!AvailableStubInfos)
    return AvailableStubInfos.takeError();

  {
    std::lock_guard<std::mutex> Lock(ISMMutex);
    unsigned ASIdx = 0;
    for (auto &SI : StubInits) {
      auto &A = (*AvailableStubInfos)[ASIdx++];
      StubInfos[SI.first()] = std::make_pair(A, SI.second.second);
    }
  }

  auto &MemAccess = EPCIU.getExecutorProcessControl().getMemoryAccess();
  switch (EPCIU.getABISupport().getPointerSize()) {
  case 4: {
    unsigned ASIdx = 0;
    std::vector<tpctypes::UInt32Write> PtrUpdates;
    for (auto &SI : StubInits)
      PtrUpdates.push_back({(*AvailableStubInfos)[ASIdx++].PointerAddress,
                            static_cast<uint32_t>(SI.second.first)});
    return MemAccess.writeUInt32s(PtrUpdates);
  }
  case 8: {
    unsigned ASIdx = 0;
    std::vector<tpctypes::UInt64Write> PtrUpdates;
    for (auto &SI : StubInits)
      PtrUpdates.push_back({(*AvailableStubInfos)[ASIdx++].PointerAddress,
                            static_cast<uint64_t>(SI.second.first)});
    return MemAccess.writeUInt64s(PtrUpdates);
  }
  default:
    return make_error<StringError>("Unsupported pointer size",
                                   inconvertibleErrorCode());
  }
}

JITEvaluatedSymbol EPCIndirectStubsManager::findStub(StringRef Name,
                                                     bool ExportedStubsOnly) {
  std::lock_guard<std::mutex> Lock(ISMMutex);
  auto I = StubInfos.find(Name);
  if (I == StubInfos.end())
    return nullptr;
  return {I->second.first.StubAddress, I->second.second};
}

JITEvaluatedSymbol EPCIndirectStubsManager::findPointer(StringRef Name) {
  std::lock_guard<std::mutex> Lock(ISMMutex);
  auto I = StubInfos.find(Name);
  if (I == StubInfos.end())
    return nullptr;
  return {I->second.first.PointerAddress, I->second.second};
}

Error EPCIndirectStubsManager::updatePointer(StringRef Name,
                                             JITTargetAddress NewAddr) {

  JITTargetAddress PtrAddr = 0;
  {
    std::lock_guard<std::mutex> Lock(ISMMutex);
    auto I = StubInfos.find(Name);
    if (I == StubInfos.end())
      return make_error<StringError>("Unknown stub name",
                                     inconvertibleErrorCode());
    PtrAddr = I->second.first.PointerAddress;
  }

  auto &MemAccess = EPCIU.getExecutorProcessControl().getMemoryAccess();
  switch (EPCIU.getABISupport().getPointerSize()) {
  case 4: {
    tpctypes::UInt32Write PUpdate(PtrAddr, NewAddr);
    return MemAccess.writeUInt32s(PUpdate);
  }
  case 8: {
    tpctypes::UInt64Write PUpdate(PtrAddr, NewAddr);
    return MemAccess.writeUInt64s(PUpdate);
  }
  default:
    return make_error<StringError>("Unsupported pointer size",
                                   inconvertibleErrorCode());
  }
}

} // end anonymous namespace.

namespace llvm {
namespace orc {

EPCIndirectionUtils::ABISupport::~ABISupport() {}

Expected<std::unique_ptr<EPCIndirectionUtils>>
EPCIndirectionUtils::Create(ExecutorProcessControl &EPC) {
  const auto &TT = EPC.getTargetTriple();
  switch (TT.getArch()) {
  default:
    return make_error<StringError>(
        std::string("No EPCIndirectionUtils available for ") + TT.str(),
        inconvertibleErrorCode());
  case Triple::aarch64:
  case Triple::aarch64_32:
    return CreateWithABI<OrcAArch64>(EPC);

  case Triple::x86:
    return CreateWithABI<OrcI386>(EPC);

  case Triple::mips:
    return CreateWithABI<OrcMips32Be>(EPC);

  case Triple::mipsel:
    return CreateWithABI<OrcMips32Le>(EPC);

  case Triple::mips64:
  case Triple::mips64el:
    return CreateWithABI<OrcMips64>(EPC);

  case Triple::x86_64:
    if (TT.getOS() == Triple::OSType::Win32)
      return CreateWithABI<OrcX86_64_Win32>(EPC);
    else
      return CreateWithABI<OrcX86_64_SysV>(EPC);
  }
}

Error EPCIndirectionUtils::cleanup() {
  Error Err = Error::success();

  for (auto &A : IndirectStubAllocs)
    Err = joinErrors(std::move(Err), A->deallocate());

  if (TP)
    Err = joinErrors(std::move(Err),
                     static_cast<EPCTrampolinePool &>(*TP).deallocatePool());

  if (ResolverBlock)
    Err = joinErrors(std::move(Err), ResolverBlock->deallocate());

  return Err;
}

Expected<JITTargetAddress>
EPCIndirectionUtils::writeResolverBlock(JITTargetAddress ReentryFnAddr,
                                        JITTargetAddress ReentryCtxAddr) {
  assert(ABI && "ABI can not be null");
  constexpr auto ResolverBlockPermissions =
      static_cast<sys::Memory::ProtectionFlags>(sys::Memory::MF_READ |
                                                sys::Memory::MF_EXEC);
  auto ResolverSize = ABI->getResolverCodeSize();

  jitlink::JITLinkMemoryManager::SegmentsRequestMap Request;
  Request[ResolverBlockPermissions] = {EPC.getPageSize(),
                                       static_cast<size_t>(ResolverSize), 0};
  auto Alloc = EPC.getMemMgr().allocate(nullptr, Request);
  if (!Alloc)
    return Alloc.takeError();

  auto WorkingMemory = (*Alloc)->getWorkingMemory(ResolverBlockPermissions);
  ResolverBlockAddr = (*Alloc)->getTargetMemory(ResolverBlockPermissions);
  ABI->writeResolverCode(WorkingMemory.data(), ResolverBlockAddr, ReentryFnAddr,
                         ReentryCtxAddr);

  if (auto Err = (*Alloc)->finalize())
    return std::move(Err);

  ResolverBlock = std::move(*Alloc);
  return ResolverBlockAddr;
}

std::unique_ptr<IndirectStubsManager>
EPCIndirectionUtils::createIndirectStubsManager() {
  return std::make_unique<EPCIndirectStubsManager>(*this);
}

TrampolinePool &EPCIndirectionUtils::getTrampolinePool() {
  if (!TP)
    TP = std::make_unique<EPCTrampolinePool>(*this);
  return *TP;
}

LazyCallThroughManager &EPCIndirectionUtils::createLazyCallThroughManager(
    ExecutionSession &ES, JITTargetAddress ErrorHandlerAddr) {
  assert(!LCTM &&
         "createLazyCallThroughManager can not have been called before");
  LCTM = std::make_unique<LazyCallThroughManager>(ES, ErrorHandlerAddr,
                                                  &getTrampolinePool());
  return *LCTM;
}

EPCIndirectionUtils::EPCIndirectionUtils(ExecutorProcessControl &EPC,
                                         std::unique_ptr<ABISupport> ABI)
    : EPC(EPC), ABI(std::move(ABI)) {
  assert(this->ABI && "ABI can not be null");

  assert(EPC.getPageSize() > getABISupport().getStubSize() &&
         "Stubs larger than one page are not supported");
}

Expected<EPCIndirectionUtils::IndirectStubInfoVector>
EPCIndirectionUtils::getIndirectStubs(unsigned NumStubs) {

  std::lock_guard<std::mutex> Lock(EPCUIMutex);

  // If there aren't enough stubs available then allocate some more.
  if (NumStubs > AvailableIndirectStubs.size()) {
    auto NumStubsToAllocate = NumStubs;
    auto PageSize = EPC.getPageSize();
    auto StubBytes = alignTo(NumStubsToAllocate * ABI->getStubSize(), PageSize);
    NumStubsToAllocate = StubBytes / ABI->getStubSize();
    auto PointerBytes =
        alignTo(NumStubsToAllocate * ABI->getPointerSize(), PageSize);

    constexpr auto StubPagePermissions =
        static_cast<sys::Memory::ProtectionFlags>(sys::Memory::MF_READ |
                                                  sys::Memory::MF_EXEC);
    constexpr auto PointerPagePermissions =
        static_cast<sys::Memory::ProtectionFlags>(sys::Memory::MF_READ |
                                                  sys::Memory::MF_WRITE);

    jitlink::JITLinkMemoryManager::SegmentsRequestMap Request;
    Request[StubPagePermissions] = {PageSize, static_cast<size_t>(StubBytes),
                                    0};
    Request[PointerPagePermissions] = {PageSize, 0, PointerBytes};
    auto Alloc = EPC.getMemMgr().allocate(nullptr, Request);
    if (!Alloc)
      return Alloc.takeError();

    auto StubTargetAddr = (*Alloc)->getTargetMemory(StubPagePermissions);
    auto PointerTargetAddr = (*Alloc)->getTargetMemory(PointerPagePermissions);

    ABI->writeIndirectStubsBlock(
        (*Alloc)->getWorkingMemory(StubPagePermissions).data(), StubTargetAddr,
        PointerTargetAddr, NumStubsToAllocate);

    if (auto Err = (*Alloc)->finalize())
      return std::move(Err);

    for (unsigned I = 0; I != NumStubsToAllocate; ++I) {
      AvailableIndirectStubs.push_back(
          IndirectStubInfo(StubTargetAddr, PointerTargetAddr));
      StubTargetAddr += ABI->getStubSize();
      PointerTargetAddr += ABI->getPointerSize();
    }

    IndirectStubAllocs.push_back(std::move(*Alloc));
  }

  assert(NumStubs <= AvailableIndirectStubs.size() &&
         "Sufficient stubs should have been allocated above");

  IndirectStubInfoVector Result;
  while (NumStubs--) {
    Result.push_back(AvailableIndirectStubs.back());
    AvailableIndirectStubs.pop_back();
  }

  return std::move(Result);
}

static JITTargetAddress reentry(JITTargetAddress LCTMAddr,
                                JITTargetAddress TrampolineAddr) {
  auto &LCTM = *jitTargetAddressToPointer<LazyCallThroughManager *>(LCTMAddr);
  std::promise<JITTargetAddress> LandingAddrP;
  auto LandingAddrF = LandingAddrP.get_future();
  LCTM.resolveTrampolineLandingAddress(
      TrampolineAddr,
      [&](JITTargetAddress Addr) { LandingAddrP.set_value(Addr); });
  return LandingAddrF.get();
}

Error setUpInProcessLCTMReentryViaEPCIU(EPCIndirectionUtils &EPCIU) {
  auto &LCTM = EPCIU.getLazyCallThroughManager();
  return EPCIU
      .writeResolverBlock(pointerToJITTargetAddress(&reentry),
                          pointerToJITTargetAddress(&LCTM))
      .takeError();
}

} // end namespace orc
} // end namespace llvm
