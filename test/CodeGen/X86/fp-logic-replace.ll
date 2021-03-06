; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX

; Test that we can replace "scalar" FP-bitwise-logic with the optimal instruction.
; Scalar x86 FP-logic instructions only exist in your imagination and/or the bowels
; of compilers, but float and double variants of FP-logic instructions are reality
; and float may be a shorter instruction depending on which flavor of vector ISA
; you have...so just prefer float all the time, ok? Yay, x86!

define double @FsANDPSrr(double %x, double %y) {
; SSE-LABEL: FsANDPSrr:
; SSE:       # BB#0:
; SSE-NEXT:    andps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: FsANDPSrr:
; AVX:       # BB#0:
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
  %bc1 = bitcast double %x to i64
  %bc2 = bitcast double %y to i64
  %and = and i64 %bc1, %bc2
  %bc3 = bitcast i64 %and to double
  ret double %bc3
}

define double @FsANDNPSrr(double %x, double %y) {
; SSE-LABEL: FsANDNPSrr:
; SSE:       # BB#0:
; SSE-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    xorpd %xmm1, %xmm2
; SSE-NEXT:    andpd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: FsANDNPSrr:
; AVX:       # BB#0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; AVX-NEXT:    vxorpd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vandpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
  %bc1 = bitcast double %x to i64
  %bc2 = bitcast double %y to i64
  %not = xor i64 %bc2, -1
  %and = and i64 %bc1, %not
  %bc3 = bitcast i64 %and to double
  ret double %bc3
}

define double @FsORPSrr(double %x, double %y) {
; SSE-LABEL: FsORPSrr:
; SSE:       # BB#0:
; SSE-NEXT:    orps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: FsORPSrr:
; AVX:       # BB#0:
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
  %bc1 = bitcast double %x to i64
  %bc2 = bitcast double %y to i64
  %or = or i64 %bc1, %bc2
  %bc3 = bitcast i64 %or to double
  ret double %bc3
}

define double @FsXORPSrr(double %x, double %y) {
; SSE-LABEL: FsXORPSrr:
; SSE:       # BB#0:
; SSE-NEXT:    xorps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: FsXORPSrr:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
  %bc1 = bitcast double %x to i64
  %bc2 = bitcast double %y to i64
  %xor = xor i64 %bc1, %bc2
  %bc3 = bitcast i64 %xor to double
  ret double %bc3
}

