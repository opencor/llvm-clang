; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -slp-vectorizer -S | FileCheck %s

; REQUIRES: asserts

; SLP crashed when tried to delete instruction with uses.
; It tried to match reduction subsequently on %i23, then %i22 etc
; When it reached %i18 it was still failing to match reduction but
; succeeded with its operands pair: %i17, %i11.
; Then it popped instruction %i17 from stack to make next attempt on
; matching reduction but the instruction was actually erased on prior
; iteration (it was matched and vectorized, which added a use of a deleted
; instruction)

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[IF_END:%.*]], label [[FOR_COND_PREHEADER:%.*]]
; CHECK:       for.cond.preheader:
; CHECK-NEXT:    [[I:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 2
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 3
; CHECK-NEXT:    [[I2:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 4
; CHECK-NEXT:    [[I3:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 5
; CHECK-NEXT:    [[I4:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 6
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[I]] to <2 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i32>, <2 x i32>* [[TMP0]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[I1]] to <2 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x i32>, <2 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[I2]] to <2 x i32>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x i32>, <2 x i32>* [[TMP4]], align 16
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[I3]] to <2 x i32>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <2 x i32>, <2 x i32>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = add <2 x i32> undef, [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = add <2 x i32> [[TMP8]], [[TMP5]]
; CHECK-NEXT:    [[TMP10:%.*]] = add <2 x i32> [[TMP9]], [[TMP3]]
; CHECK-NEXT:    [[TMP11:%.*]] = add <2 x i32> [[TMP10]], [[TMP1]]
; CHECK-NEXT:    [[TMP12:%.*]] = add <2 x i32> [[TMP11]], undef
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x i32> [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x i32> [[TMP11]], i32 0
; CHECK-NEXT:    [[I11:%.*]] = add i32 [[TMP14]], [[TMP13]]
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x i32> [[TMP12]], i32 1
; CHECK-NEXT:    [[I18:%.*]] = add i32 [[TMP15]], [[I11]]
; CHECK-NEXT:    [[I19:%.*]] = add i32 [[TMP15]], [[I18]]
; CHECK-NEXT:    [[I20:%.*]] = add i32 undef, [[I19]]
; CHECK-NEXT:    [[I21:%.*]] = add i32 undef, [[I20]]
; CHECK-NEXT:    [[I22:%.*]] = add i32 undef, [[I21]]
; CHECK-NEXT:    [[I23:%.*]] = add i32 undef, [[I22]]
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[I23]], [[FOR_COND_PREHEADER]] ], [ undef, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %if.end, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry
  %i = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 2
  %i1 = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 3
  %i2 = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 4
  %i3 = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 5
  %i4 = getelementptr inbounds [100 x i32], [100 x i32]* undef, i64 0, i64 6
  %ld0 = load i32, i32* %i, align 8
  %ld1 = load i32, i32* %i1, align 4
  %ld2 = load i32, i32* %i2, align 16
  %ld3 = load i32, i32* %i3, align 4
  %i5 = add i32 undef, undef
  %i6 = add i32 %i5, %ld3
  %i7 = add i32 %i6, %ld2
  %i8 = add i32 %i7, %ld1
  %i9 = add i32 %i8, %ld0
  %i10 = add i32 %i9, undef
  %i11 = add i32 %i9, %i10
  %ld4 = load i32, i32* %i1, align 4
  %ld5 = load i32, i32* %i2, align 16
  %ld6 = load i32, i32* %i3, align 4
  %ld7 = load i32, i32* %i4, align 8
  %i12 = add i32 undef, undef
  %i13 = add i32 %i12, %ld7
  %i14 = add i32 %i13, %ld6
  %i15 = add i32 %i14, %ld5
  %i16 = add i32 %i15, %ld4
  %i17 = add i32 %i16, undef
  %i18 = add i32 %i17, %i11
  %i19 = add i32 %i17, %i18
  %i20 = add i32 undef, %i19
  %i21 = add i32 undef, %i20
  %i22 = add i32 undef, %i21
  %i23 = add i32 undef, %i22
  br label %if.end

if.end:                                           ; preds = %for.cond.preheader, %entry
  %r = phi i32 [ %i23, %for.cond.preheader ], [ undef, %entry ]
  ret void
}
