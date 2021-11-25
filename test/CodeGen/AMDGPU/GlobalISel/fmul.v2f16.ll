; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=fiji < %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s

define <2 x half> @v_fmul_v2f16(<2 x half> %a, <2 x half> %b) {
; GFX9-LABEL: v_fmul_v2f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v2f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_f16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v1, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v2f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %mul = fmul <2 x half> %a, %b
  ret <2 x half> %mul
}

define <2 x half> @v_fmul_v2f16_fneg_lhs(<2 x half> %a, <2 x half> %b) {
; GFX9-LABEL: v_fmul_v2f16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v2f16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX8-NEXT:    v_mul_f16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v1, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v2f16_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <2 x half> %a
  %mul = fmul <2 x half> %neg.a, %b
  ret <2 x half> %mul
}

define <2 x half> @v_fmul_v2f16_fneg_rhs(<2 x half> %a, <2 x half> %b) {
; GFX9-LABEL: v_fmul_v2f16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v2f16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v1, 0x80008000, v1
; GFX8-NEXT:    v_mul_f16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v1, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v2f16_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.b = fneg <2 x half> %b
  %mul = fmul <2 x half> %a, %neg.b
  ret <2 x half> %mul
}

define <2 x half> @v_fmul_v2f16_fneg_lhs_fneg_rhs(<2 x half> %a, <2 x half> %b) {
; GFX9-LABEL: v_fmul_v2f16_fneg_lhs_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v2f16_fneg_lhs_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_mul_f16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v1, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v2f16_fneg_lhs_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v1 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <2 x half> %a
  %neg.b = fneg <2 x half> %b
  %mul = fmul <2 x half> %neg.a, %neg.b
  ret <2 x half> %mul
}

; FIXME
; define <3 x half> @v_fmul_v3f16(<3 x half> %a, <3 x half> %b) {
;   %mul = fmul <3 x half> %a, %b
;   ret <3 x half> %mul
; }

; define <3 x half> @v_fmul_v3f16_fneg_lhs(<3 x half> %a, <3 x half> %b) {
;   %neg.a = fneg <3 x half> %a
;   %mul = fmul <3 x half> %neg.a, %b
;   ret <3 x half> %mul
; }

; define <3 x half> @v_fmul_v3f16_fneg_rhs(<3 x half> %a, <3 x half> %b) {
;   %neg.b = fneg <3 x half> %b
;   %mul = fmul <3 x half> %a, %neg.b
;   ret <3 x half> %mul
; }

; define <3 x half> @v_fmul_v3f16_fneg_lhs_fneg_rhs(<3 x half> %a, <3 x half> %b) {
;   %neg.a = fneg <3 x half> %a
;   %neg.b = fneg <3 x half> %b
;   %mul = fmul <3 x half> %neg.a, %neg.b
;   ret <3 x half> %mul
; }

define <4 x half> @v_fmul_v4f16(<4 x half> %a, <4 x half> %b) {
; GFX9-LABEL: v_fmul_v4f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v4f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_f16_e32 v4, v0, v2
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v2, v1, v3
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v4, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v4f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %mul = fmul <4 x half> %a, %b
  ret <4 x half> %mul
}

define <4 x half> @v_fmul_v4f16_fneg_lhs(<4 x half> %a, <4 x half> %b) {
; GFX9-LABEL: v_fmul_v4f16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v4f16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_mul_f16_e32 v4, v0, v2
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v2, v1, v3
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v4, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v4f16_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <4 x half> %a
  %mul = fmul <4 x half> %neg.a, %b
  ret <4 x half> %mul
}

define <4 x half> @v_fmul_v4f16_fneg_rhs(<4 x half> %a, <4 x half> %b) {
; GFX9-LABEL: v_fmul_v4f16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v4f16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_mul_f16_e32 v4, v0, v2
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v2, v1, v3
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v4, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v4f16_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.b = fneg <4 x half> %b
  %mul = fmul <4 x half> %a, %neg.b
  ret <4 x half> %mul
}

define <4 x half> @v_fmul_v4f16_fneg_lhs_fneg_rhs(<4 x half> %a, <4 x half> %b) {
; GFX9-LABEL: v_fmul_v4f16_fneg_lhs_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v4f16_fneg_lhs_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_mul_f16_e32 v4, v0, v2
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v2, v1, v3
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v4, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v2, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v4f16_fneg_lhs_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <4 x half> %a
  %neg.b = fneg <4 x half> %b
  %mul = fmul <4 x half> %neg.a, %neg.b
  ret <4 x half> %mul
}

define <6 x half> @v_fmul_v6f16(<6 x half> %a, <6 x half> %b) {
; GFX9-LABEL: v_fmul_v6f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v3
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v4
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v5
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v6f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_f16_e32 v6, v0, v3
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v3, v1, v4
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v2, v5
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v5, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v5, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v3, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v6, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v4, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v6f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v3
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v4
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %mul = fmul <6 x half> %a, %b
  ret <6 x half> %mul
}

define <6 x half> @v_fmul_v6f16_fneg_lhs(<6 x half> %a, <6 x half> %b) {
; GFX9-LABEL: v_fmul_v6f16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v6f16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_mul_f16_e32 v6, v0, v3
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v3, v1, v4
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v2, v5
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v5, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v5, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v3, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v6, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v4, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v6f16_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <6 x half> %a
  %mul = fmul <6 x half> %neg.a, %b
  ret <6 x half> %mul
}

define <6 x half> @v_fmul_v6f16_fneg_rhs(<6 x half> %a, <6 x half> %b) {
; GFX9-LABEL: v_fmul_v6f16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v6f16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_xor_b32_e32 v4, s4, v4
; GFX8-NEXT:    v_xor_b32_e32 v5, s4, v5
; GFX8-NEXT:    v_mul_f16_e32 v6, v0, v3
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v3, v1, v4
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v2, v5
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v5, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v5, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v3, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v6, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v4, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v6f16_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.b = fneg <6 x half> %b
  %mul = fmul <6 x half> %a, %neg.b
  ret <6 x half> %mul
}

define <6 x half> @v_fmul_v6f16_fneg_lhs_fneg_rhs(<6 x half> %a, <6 x half> %b) {
; GFX9-LABEL: v_fmul_v6f16_fneg_lhs_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v6f16_fneg_lhs_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_xor_b32_e32 v4, s4, v4
; GFX8-NEXT:    v_xor_b32_e32 v5, s4, v5
; GFX8-NEXT:    v_mul_f16_e32 v6, v0, v3
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v3, v1, v4
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v2, v5
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v5, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_mov_b32_e32 v3, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v5, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v3, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v6, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v4, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v6f16_fneg_lhs_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v3 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v4 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v5 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <6 x half> %a
  %neg.b = fneg <6 x half> %b
  %mul = fmul <6 x half> %neg.a, %neg.b
  ret <6 x half> %mul
}

define <8 x half> @v_fmul_v8f16(<8 x half> %a, <8 x half> %b) {
; GFX9-LABEL: v_fmul_v8f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v4
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v5
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v6
; GFX9-NEXT:    v_pk_mul_f16 v3, v3, v7
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v8f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_f16_e32 v8, v0, v4
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v1, v5
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v5, v2, v6
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v6, v3, v7
; GFX8-NEXT:    v_mul_f16_sdwa v3, v3, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v7, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v7, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v7, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v3, v7, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v8, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v4, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v5, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v3, v6, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v8f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v4
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v5
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v6
; GFX10-NEXT:    v_pk_mul_f16 v3, v3, v7
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %mul = fmul <8 x half> %a, %b
  ret <8 x half> %mul
}

define <8 x half> @v_fmul_v8f16_fneg_lhs(<8 x half> %a, <8 x half> %b) {
; GFX9-LABEL: v_fmul_v8f16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v8f16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_mul_f16_e32 v8, v0, v4
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v1, v5
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v5, v2, v6
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v6, v3, v7
; GFX8-NEXT:    v_mul_f16_sdwa v3, v3, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v7, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v7, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v7, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v3, v7, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v8, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v4, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v5, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v3, v6, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v8f16_fneg_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[1,0] neg_hi:[1,0]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <8 x half> %a
  %mul = fmul <8 x half> %neg.a, %b
  ret <8 x half> %mul
}

define <8 x half> @v_fmul_v8f16_fneg_rhs(<8 x half> %a, <8 x half> %b) {
; GFX9-LABEL: v_fmul_v8f16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v8f16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v4, s4, v4
; GFX8-NEXT:    v_xor_b32_e32 v5, s4, v5
; GFX8-NEXT:    v_xor_b32_e32 v6, s4, v6
; GFX8-NEXT:    v_xor_b32_e32 v7, s4, v7
; GFX8-NEXT:    v_mul_f16_e32 v8, v0, v4
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v1, v5
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v5, v2, v6
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v6, v3, v7
; GFX8-NEXT:    v_mul_f16_sdwa v3, v3, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v7, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v7, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v7, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v3, v7, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v8, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v4, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v5, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v3, v6, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v8f16_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[0,1] neg_hi:[0,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.b = fneg <8 x half> %b
  %mul = fmul <8 x half> %a, %neg.b
  ret <8 x half> %mul
}

define <8 x half> @v_fmul_v8f16_fneg_lhs_fneg_rhs(<8 x half> %a, <8 x half> %b) {
; GFX9-LABEL: v_fmul_v8f16_fneg_lhs_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_fmul_v8f16_fneg_lhs_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v4, s4, v4
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_xor_b32_e32 v2, s4, v2
; GFX8-NEXT:    v_xor_b32_e32 v3, s4, v3
; GFX8-NEXT:    v_xor_b32_e32 v5, s4, v5
; GFX8-NEXT:    v_xor_b32_e32 v6, s4, v6
; GFX8-NEXT:    v_xor_b32_e32 v7, s4, v7
; GFX8-NEXT:    v_mul_f16_e32 v8, v0, v4
; GFX8-NEXT:    v_mul_f16_sdwa v0, v0, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v4, v1, v5
; GFX8-NEXT:    v_mul_f16_sdwa v1, v1, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v5, v2, v6
; GFX8-NEXT:    v_mul_f16_sdwa v2, v2, v6 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mul_f16_e32 v6, v3, v7
; GFX8-NEXT:    v_mul_f16_sdwa v3, v3, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v7, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_e32 v7, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v7, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v2, v7, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v3, v7, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v8, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v4, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v2, v5, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v3, v6, v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_fmul_v8f16_fneg_lhs_fneg_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v4 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v5 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v2, v2, v6 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    v_pk_mul_f16 v3, v3, v7 neg_lo:[1,1] neg_hi:[1,1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <8 x half> %a
  %neg.b = fneg <8 x half> %b
  %mul = fmul <8 x half> %neg.a, %neg.b
  ret <8 x half> %mul
}
