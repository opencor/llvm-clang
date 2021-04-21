; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

%S = type { %S* }

; Inlining should nuke the invoke (and any inlined calls) here even with
; argument promotion running along with it.
define void @zot() personality i32 (...)* @wibble {
; IS__TUNIT____: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@zot
; IS__TUNIT____-SAME: () [[ATTR0:#.*]] personality i32 (...)* @wibble {
; IS__TUNIT____-NEXT:  bb:
; IS__TUNIT____-NEXT:    call void @hoge() [[ATTR1:#.*]]
; IS__TUNIT____-NEXT:    unreachable
; IS__TUNIT____:       bb1:
; IS__TUNIT____-NEXT:    unreachable
; IS__TUNIT____:       bb2:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@zot
; IS__CGSCC____-SAME: () [[ATTR0:#.*]] personality i32 (...)* @wibble {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    call void @hoge() [[ATTR2:#.*]]
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       bb1:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       bb2:
; IS__CGSCC____-NEXT:    unreachable
;
bb:
  invoke void @hoge()
  to label %bb1 unwind label %bb2

bb1:
  unreachable

bb2:
  %tmp = landingpad { i8*, i32 }
  cleanup
  unreachable
}

define internal void @hoge() {
; IS__TUNIT____: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@hoge
; IS__TUNIT____-SAME: () [[ATTR0]] {
; IS__TUNIT____-NEXT:  bb:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@hoge
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    unreachable
;
bb:
  %tmp = call fastcc i8* @spam(i1 (i8*)* @eggs)
  %tmp1 = call fastcc i8* @spam(i1 (i8*)* @barney)
  unreachable
}

define internal fastcc i8* @spam(i1 (i8*)* %arg) {
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@spam
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    unreachable
;
bb:
  unreachable
}

define internal i1 @eggs(i8* %arg) {
bb:
  %tmp = call zeroext i1 @barney(i8* %arg)
  unreachable
}

define internal i1 @barney(i8* %arg) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@barney
; IS__CGSCC____-SAME: () [[ATTR1:#.*]] {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    ret i1 undef
;
bb:
  ret i1 undef
}

define i32 @test_inf_promote_caller(i32 %arg) {
; IS__TUNIT____: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_inf_promote_caller
; IS__TUNIT____-SAME: (i32 [[ARG:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:  bb:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_inf_promote_caller
; IS__CGSCC____-SAME: (i32 [[ARG:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    [[TMP:%.*]] = alloca [[S:%.*]], align 8
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = alloca [[S]], align 8
; IS__CGSCC____-NEXT:    unreachable
;
bb:
  %tmp = alloca %S
  %tmp1 = alloca %S
  %tmp2 = call i32 @test_inf_promote_callee(%S* %tmp, %S* %tmp1)

  ret i32 0
}

define internal i32 @test_inf_promote_callee(%S* %arg, %S* %arg1) {
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_inf_promote_callee
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:  bb:
; IS__CGSCC____-NEXT:    unreachable
;
bb:
  %tmp = getelementptr %S, %S* %arg1, i32 0, i32 0
  %tmp2 = load %S*, %S** %tmp
  %tmp3 = getelementptr %S, %S* %arg, i32 0, i32 0
  %tmp4 = load %S*, %S** %tmp3
  %tmp5 = call i32 @test_inf_promote_callee(%S* %tmp4, %S* %tmp2)

  ret i32 0
}

declare i32 @wibble(...)
