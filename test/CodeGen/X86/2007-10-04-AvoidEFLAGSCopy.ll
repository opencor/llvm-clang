; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

	%struct.gl_texture_image = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8*, i8* }
	%struct.gl_texture_object = type { i32, i32, i32, float, [4 x i32], i32, i32, i32, i32, i32, float, [11 x %struct.gl_texture_image*], [1024 x i8], i32, i32, i32, i8, i8*, i8, void (%struct.gl_texture_object*, i32, float*, float*, float*, float*, i8*, i8*, i8*, i8*)*, %struct.gl_texture_object* }

define fastcc void @sample_3d_linear(%struct.gl_texture_object* %tObj, %struct.gl_texture_image* %img, float %s, float %t, float %r, i8* %red, i8* %green, i8* %blue, i8* %alpha) {
; CHECK-LABEL: sample_3d_linear:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movl 0, %esi
; CHECK-NEXT:    pushl $0
; CHECK-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-NEXT:    calll floorf@PLT
; CHECK-NEXT:    fstp %st(0)
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK-NEXT:    cmpl $10497, %esi # imm = 0x2901
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
	%tmp15 = load i32, i32* null, align 4		; <i32> [#uses=1]
	%tmp16 = icmp eq i32 %tmp15, 10497		; <i1> [#uses=1]
	%tmp2152 = call float @floorf( float 0.000000e+00 )		; <float> [#uses=0]
	br i1 %tmp16, label %cond_true, label %cond_false

cond_true:		; preds = %entry
	ret void

cond_false:		; preds = %entry
	ret void
}

declare float @floorf(float)
