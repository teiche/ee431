main:
	mov r0, 0x0006 << 0
	mov r1, 0x0000 << 0
	mov r2, 0x0000 << 0
	call fib

loop:
	mov r6, 0xDEAD << 0
	brn loop

	;; R0 - which Fibonacci number to calculate
	;; Return value placed in R1
fib:
	push r0
	push r2
	
	cmp r0, 0x0001 << 0
	brz 1, ret_o
	cmp r0, 0x0000 << 0
	brz 1, ret_z

	;; fib(n - 1)
	sub r0, 0x0001 << 0
	call fib
	mov r2, r1

	;; fib(n - 2)
	sub r0, 0x0001 << 0
	call fib

	add r1, r2
	brn fib_ret

ret_z:	mov r1, 0x0000 << 0
	brn fib_ret
ret_o:	mov r1, 0x0001 << 0
	brn fib_ret

fib_ret:
	pop r2
	pop r0
	ret			;