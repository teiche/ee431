
	;; test rol w/o wrapping, r3 = 65
mov r0, 0x0010 << 0
mov r1, 0x0004 << 0
rol r0, r1
cmp r0, 0x0100 << 0
brz 0, fail
mov r3, 0x0041 << 0

	;; test rol w/ wrapping, r3 = 650
mov r0, 0x1001 << 16
mov r1, 0x0004 << 0
rol r0, r1
mov r2, 0x0010 << 16
add r2, 0x0001 << 0
cmp r0, r2
brz 0, fail
mov r3, 0x028a << 0
	
	;; test ror w/o wrapping, r3 = 108
mov r0, 0xCA00 << 0
mov r1, 0x0008 << 0
ror r0, r1
cmp r0, 0x00CA << 0
brz 0, fail
mov r3, 0x006c << 0

	;; test rol w/ wrapping, r3 = 1080
mov r0, 0xBEEF << 0
mov r1, 0x0010 << 0
ror r0, r1
mov r2, 0xBEEF << 16
cmp r0, r2
brz 0, fail
mov r3, 0x0438 << 0

	;; test asr on negative value, r3 should be 702 on success
mov r0, 0x80F0 << 16
mov r1, 0x0001 << 2
asr r0 >>> r1
cmp r0, 0xF80F << 16
brz 0, fail
mov r3, 0x02be << 0
	
	;; test asr on positive value, r3 should be 7020 on success
mov r0, 0x0FF0 << 0
mov r1, 0x0001 << 2
asr r0 >>> r1
cmp r0, 0x00FF << 0
brz 0, fail
mov r3, 0x1b6c << 0

	;; Test lsl, r3 should be 72 on success
mov R0, 0x0FF0 << 0
mov R1, 0x0004 << 0
lsl R0 << R1
cmp R0, 0xFF00 << 0
brz 0, fail
mov r3, 0x0048 << 0

	;; Test lsr, r3 should be 7200
mov R0, 0x0FF0 << 0
mov R1, 0x0004 << 0
lsr R0 >> R1
cmp R0, 0x00FF << 0
brz 0, fail
mov r3, 0x1c20 << 0


	
wait:
	brn wait

fail:
	mov r1, 0x00 << 0
	mov r2, 0x00 << 0
	mov r3, 0x00 << 0
	mov r4, 0x00 << 0
	mov r5, 0x00 << 0
	mov r6, 0x00 << 0
	mov r7, 0x00 << 0
	mov r8, 0x00 << 0
