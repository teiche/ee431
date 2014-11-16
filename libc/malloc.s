; ...it is what it does...

; todo:
; -- block splitting
; -- faster memset
; -- extensive testing
	
; addresses
#define __flp (0x0000)

;; __heap_end points to the last word of the heap
;; until memory is allocated, __heap_end points to itself
#define __heap_end (0x0001)
	
; ld/st offset to use to get the size of the current block(next lowest word)
; equivalent to -1, but my assembler doesn't support negatives yet
#define sz 4095
; ld/st offset to get the address of the next free list block
#define nxt 0

#define FLP_HEADER_SIZE 1

; assemble with:
; cpp malloc.s | sed '/^#/ d' | sed 's/\s*$//g' > malloc_pp.s; asm ./malloc_pp.s
	
; to strip comments(doesn't assemble):
; cpp malloc.s | sed '/^#/ d' | sed 's/\;.*$//' | sed 's/\s*$//g' > malloc_pp.s; asm ./malloc_pp.s 
	
__start:
	;; set up the free list head for malloc
	mov r0, 0x0000 << 0
	st r0, __flp

	mov r0, 0x0001 << 0
	st r0, __heap_end

	brn main

main:
	;; malloc and free some memory
	mov r1, 0xADAD << 0
	mov r2, 0xADAD << 0
	mov r4, 0x0000 << 0
	
	;; try to malloc a 4-word chunk
	mov r0, 0x0008 << 0
	call malloc

	;; try to malloc a 4-word chunk
	mov r0, 0x0008 << 0
	call malloc
	mov r4, r0

	mov r0, 0x0008 << 0
	call malloc
	mov r5, r0
	mov r4, 72 << 0
	st r4, (r5), 0

	mov r0, 0x0008 << 0
	call malloc
	mov r6, r0
	mov r4, 65 << 0
	st r4, (r6), 0

	mov r0, 0x0008 << 0
	call malloc
	mov r7, r0
	mov r4, 206 << 0
	st r4, (r7), 0

	mov r0, r5
	call free

	mov r0, r7
	call free
	
	mov r0, r6
	call free
	
done:	
	brn done

;; BEGIN MALLOC FUNCTION CODE
	
;; r0 = size of memory chunk requested
;; return value(pointer to memory block) placed in r0
malloc:
	push r1
	push r2
	push r3
	push r4
	push r5
	;; we need a block that can fit the requested size + header
	add r0, FLP_HEADER_SIZE << 0
	
	;; get the free list pointer
	ld r1, __flp
	;; start the previous-block pointer off at the free list pointer
	mov r4, 0 << 0

	;; run through existing blocks to see if there's one big enough
	;; stop when we hit a null pointer(points back to __flp)
block_search_lp:
	;; if the next block pointer is null, there are no large enough blocks
	breq r1, 0, no_blocks

	;; is this block big enough?
	ld r2, (r1), sz
	cmp r2, r0
	brc 0, found_block

	;; keep the address of the last block around incase we have to re-splice
	mov r4, r1
	;; get the next free list block
	ld r1, (r1), nxt
	brn block_search_lp

found_block:
	;; return value
	mov r0, r1

	;; re-splice the free chain
	;; set the last pointer in the free list to the location
	;; of the block that follows this one

	;; next block address
	ld r3, (r1), nxt
	st r3, (r4), nxt
	
	;; done signal
	mov r7, 0x00FF << 0
	brn malloc_ret
	
	;; extend __heap_end by the size of the block requested
	;; to make room for the block
no_blocks:
	;; r5 = old __heap_end
	ld r5, __heap_end
	
	;; calculate the new __heap_end in r3
	mov r3, r5
	add r3, r0

	;; make sure we don't run into the stack
	rsp r4
	cmp r4, r3
	brc 1, malloc_fail
	
	st r3, __heap_end

	;; r5 = address of new block, which is now the address of the new block
	;; not old __heap_end or the size of the new block
	;; add 2 so that we point to the address portion of the new block
	add r5, 2 << 0

	;; store the size of the new block
	st r0, (r5), sz
	
	mov r0, r5
	;; done signal
	mov r7, 0x00FF << 16
	brn malloc_ret

malloc_fail:
	mov r0, 0x0000 << 0
	
malloc_ret:
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	ret			;
	
create_fake_freelist:
	;; make up a freelist to test malloc with
	;; next
	mov r0, 0x0007 << 0
	st r0, (0x0003)
	;; size
	mov r0, 0x0002 << 0
	st r0, (0x0002)

	;; next
	mov r0, 0x0000 << 0
	st r0, (0x0007)
	;; size
	mov r0, 0x0008 << 0
	st r0, (0x0006)

