;; Fill memory with a constant word
;; Calling Convention:
;; r0 - Start address (*s)
;; r1 - Word to fill (c)
;; r2 - Size of memory chunk (n)
;; Returns a pointer to the memory chunk in r0
memset:
	push r0
	push r1
	push r2
	add r2, r0
memset_loop:	
	st r1, (r2), 0
	sub r2, 0x0001 << 0
	cmp r0, r2
	brz 0, memset_loop

	pop r2
	pop r1
	pop r0
	ret			;
