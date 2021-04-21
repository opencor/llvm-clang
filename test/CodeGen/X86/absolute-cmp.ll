; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -show-mc-encoding | FileCheck %s --check-prefix=NOPIC
; RUN: llc -relocation-model=pic -show-mc-encoding < %s | FileCheck %s --check-prefix=PIC

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@cmp8 = external hidden global i8, !absolute_symbol !0
@cmp32 = external hidden global i8, !absolute_symbol !1

declare void @f()

define void @foo8(i64 %val) {
; NOPIC-LABEL: foo8:
; NOPIC:       # %bb.0:
; NOPIC-NEXT:    cmpq $cmp8@ABS8, %rdi # encoding: [0x48,0x83,0xff,A]
; NOPIC-NEXT:    # fixup A - offset: 3, value: cmp8@ABS8, kind: FK_Data_1
; NOPIC-NEXT:    ja .LBB0_2 # encoding: [0x77,A]
; NOPIC-NEXT:    # fixup A - offset: 1, value: .LBB0_2-1, kind: FK_PCRel_1
; NOPIC-NEXT:  # %bb.1: # %t
; NOPIC-NEXT:    pushq %rax # encoding: [0x50]
; NOPIC-NEXT:    .cfi_def_cfa_offset 16
; NOPIC-NEXT:    callq f@PLT # encoding: [0xe8,A,A,A,A]
; NOPIC-NEXT:    # fixup A - offset: 1, value: f@PLT-4, kind: FK_PCRel_4
; NOPIC-NEXT:    popq %rax # encoding: [0x58]
; NOPIC-NEXT:    .cfi_def_cfa_offset 8
; NOPIC-NEXT:  .LBB0_2: # %f
; NOPIC-NEXT:    retq # encoding: [0xc3]
;
; PIC-LABEL: foo8:
; PIC:       # %bb.0:
; PIC-NEXT:    cmpq $cmp8@ABS8, %rdi # encoding: [0x48,0x83,0xff,A]
; PIC-NEXT:    # fixup A - offset: 3, value: cmp8@ABS8, kind: FK_Data_1
; PIC-NEXT:    ja .LBB0_2 # encoding: [0x77,A]
; PIC-NEXT:    # fixup A - offset: 1, value: .LBB0_2-1, kind: FK_PCRel_1
; PIC-NEXT:  # %bb.1: # %t
; PIC-NEXT:    pushq %rax # encoding: [0x50]
; PIC-NEXT:    .cfi_def_cfa_offset 16
; PIC-NEXT:    callq f@PLT # encoding: [0xe8,A,A,A,A]
; PIC-NEXT:    # fixup A - offset: 1, value: f@PLT-4, kind: FK_PCRel_4
; PIC-NEXT:    popq %rax # encoding: [0x58]
; PIC-NEXT:    .cfi_def_cfa_offset 8
; PIC-NEXT:  .LBB0_2: # %f
; PIC-NEXT:    retq # encoding: [0xc3]
  %cmp = icmp ule i64 %val, ptrtoint (i8* @cmp8 to i64)
  br i1 %cmp, label %t, label %f

t:
  call void @f()
  ret void

f:
  ret void
}

define void @foo32(i64 %val) {
; NOPIC-LABEL: foo32:
; NOPIC:       # %bb.0:
; NOPIC-NEXT:    cmpq $cmp32, %rdi # encoding: [0x48,0x81,0xff,A,A,A,A]
; NOPIC-NEXT:    # fixup A - offset: 3, value: cmp32, kind: reloc_signed_4byte
; NOPIC-NEXT:    ja .LBB1_2 # encoding: [0x77,A]
; NOPIC-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; NOPIC-NEXT:  # %bb.1: # %t
; NOPIC-NEXT:    pushq %rax # encoding: [0x50]
; NOPIC-NEXT:    .cfi_def_cfa_offset 16
; NOPIC-NEXT:    callq f@PLT # encoding: [0xe8,A,A,A,A]
; NOPIC-NEXT:    # fixup A - offset: 1, value: f@PLT-4, kind: FK_PCRel_4
; NOPIC-NEXT:    popq %rax # encoding: [0x58]
; NOPIC-NEXT:    .cfi_def_cfa_offset 8
; NOPIC-NEXT:  .LBB1_2: # %f
; NOPIC-NEXT:    retq # encoding: [0xc3]
;
; PIC-LABEL: foo32:
; PIC:       # %bb.0:
; PIC-NEXT:    cmpq $cmp32, %rdi # encoding: [0x48,0x81,0xff,A,A,A,A]
; PIC-NEXT:    # fixup A - offset: 3, value: cmp32, kind: reloc_signed_4byte
; PIC-NEXT:    ja .LBB1_2 # encoding: [0x77,A]
; PIC-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; PIC-NEXT:  # %bb.1: # %t
; PIC-NEXT:    pushq %rax # encoding: [0x50]
; PIC-NEXT:    .cfi_def_cfa_offset 16
; PIC-NEXT:    callq f@PLT # encoding: [0xe8,A,A,A,A]
; PIC-NEXT:    # fixup A - offset: 1, value: f@PLT-4, kind: FK_PCRel_4
; PIC-NEXT:    popq %rax # encoding: [0x58]
; PIC-NEXT:    .cfi_def_cfa_offset 8
; PIC-NEXT:  .LBB1_2: # %f
; PIC-NEXT:    retq # encoding: [0xc3]
  %cmp = icmp ule i64 %val, ptrtoint (i8* @cmp32 to i64)
  br i1 %cmp, label %t, label %f

t:
  call void @f()
  ret void

f:
  ret void
}

!0 = !{i64 0, i64 128}
!1 = !{i64 0, i64 2147483648}
