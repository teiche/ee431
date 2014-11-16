#define MARK_MERGED_MEMORY

#include "memset.s"
#include "malloc.s"
	
;; BEGIN FREE FUNCTION DEFINITION
; r0 = address of block to free
free:
	push r1
	push r2
	push r3
	push r4
	push r5
	;; get the free list pointer
	ld r1, __flp
	;; start the previous-block pointer off at the free list pointer
	mov r4, 0 << 0

	;; run through existing blocks to insert the freed block back in the right spot
	;; stop when we hit a block that starts after the block to free
freeblock_insert_lp:
	;; if the next block pointer is null, extend the chain
	breq r1, 0, extend_chain

	;; if this block beyond the block to free?
	cmp r1, r0
	brc 0, extend_chain

	;; keep the address of the last block around incase we have to re-splice
	mov r4, r1
	;; get the next free list block
	ld r1, (r1), 0
	brn freeblock_insert_lp

extend_chain:
	;; check to see if the last block is adjacent
	ld r2, (r4), sz
	add r2, r4
	cmp r2, r0
	brz 1, merge_blocks
	
	;; next pointer in the new blocks gets the next pointer of the last block
	ld r2, (r4), nxt
	st r2, (r0), nxt

	;; set the pointer from the last block in the chain to the freed block
	st r0, (r4), nxt
	
	brn free_ret

merge_blocks:
	;; merge_blocks expects the address of the first and second blocks in the merge pair
	;; to be in r4 and r0, respectively
	;; get the size of the first block
	ld r2, (r4), sz
	ld r1, (r0), sz
	;; the size of the new merged block
	add r2, r1
	sub r2, 2 << 0
	;; set the size
	st r2, (r4), sz

	#ifdef MARK_MERGED_MEMORY
	mov r0, r4
	mov r1, 0xDEAD << 0
	call memset
	#endif

	;; now that we've merged two blocks, we need to see if a block immediately follows the
	;; merged pair, and merge it if so
	;; r4 has the address of the recently merged block
	;; r2 has the size of the recently merged block
	;; r0 = address of next block
	ld r0, (r4), nxt
	mov r5, r4
	add r5, r2
	;; add 2 to account for the 2-word freelist information not included in the size
	add r5, 2 << 0
	;; check to see if the blocks are adjacent
	cmp r5, r0
	brz 0, free_ret

	;; the blocks are adjacent, merge them
	;; set the first block's next pointer to the second block's next pointer
	ld r3, (r0), nxt
	st r3, (r4), nxt

	;; calculate the new size
	;; r3 = size of block to merge
	ld r3, (r0), sz
	add r2, r3
	sub r2, 2 << 0
	st r2, (r4), sz

	#ifdef MARK_MERGED_MEMORY
	mov r0, r4
	mov r1, 0xDEAD << 0
	call memset
	#endif
	
	brn free_ret
	
free_ret:
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	ret			;
