	.globl	recurSelectionSort

# a0 contains address of head of linked list
# s0 = address of head
# s1 = min
# s2 = ptr
# s3 = beforeMin
# s4 = head->next
recurSelectionSort:
	# callee setup and allocate space on the stack
	addi 	sp, sp, -32
	sw 	ra, 28(sp)
	sw 	s0, 24(sp)
	sw 	s1, 20(sp)
	sw 	s2, 16(sp)
	sw 	s3, 12(sp)
	sw	s4, 8(sp)
	
	# use s0 for address of head
	mv 	s0, a0
	
	# struct Node* min = head;
	mv 	s1, s0
	
	# struct Node* beforeMin = NULL;
	mv 	s3, x0

	# return address of head if head->next == NULL (recursive base case)
	# calculate address of head->next
	addi 	t0, s0, 16
	
	# load head->next to t1
	lw 	t1, 0(t0)
	
	# jump to forinit if head->next != NULL
	bnez 	t1, forinit
	
	# return head if head->next == NULL
	mv 	a0, s0
	ret

forinit:
	# struct Node* ptr = head
	mv 	s2, s0
	
forloop:

	# calculate address of ptr-> next
	addi 	t0, s2, 16
	
	# load ptr->next to t1
	lw	t1, 0(t0)

	# end looping when ptr->next == NULL
	beqz 	t1, if2
	
	# calculate address of ptr->next->studentid
	addi 	t2, t1, 8
	
	# load ptr->next->studentid to t3
	lw 	t3, 0(t2)
	
	# calculate address of min->studentid
	addi 	t4, s1, 8
	
	# load min->studentid to t5
	lw	t5, 0(t4)

ifmin:
	# jump to endifmin if ptr->next->studentid >= min->studentid
	bge 	t3, t5, endifmin
	
	# min = ptr->next;
	mv 	s1, t1
	
	# beforeMin = ptr;
	mv 	s3, s2
	
endifmin:
	# ptr = ptr->next
	mv 	s2, t1

	# jump to top of loop
	b 	forloop

if2:
	# jump to endif2 if min == head
	beq 	s0, s1, endif2
	
	# push s0 to stack and pass through memory address
	# allocate 16 bytes of space
	addi 	a0, sp, 4
	sw 	s0, 0(a0)

	# if min != head, swap nodes
	# caller setup / setup arguments
	mv 	a1, s0
	mv 	a2, s1
	mv 	a3, s3
	
	# subroutine call
	# swapNodes(&head, head, min, beforeMin)
	jal 	swapNodes
	
	# restore head
	lw 	s0, 4(sp)

endif2:
	# recursive subroutine call setup
	# calculate address of head->next
	addi 	s4, s0, 16
	
	# setup argument
	lw 	a0, 0(s4)
	
	# subroutine call
	jal 	recurSelectionSort
	
	# head->next = recurSelectionSort(head->next)
	sw 	a0, 0(s4)

	# set return value to head
	mv 	a0, s0

	# callee teardown
	# restore return address and saved registers
	lw 	ra, 28(sp)
	lw 	s0, 24(sp)
	lw 	s1, 20(sp)
	lw 	s2, 16(sp)
	lw 	s3, 12(sp)
	lw	s4, 8(sp)
	
	# deallocate space on the stack
	addi 	sp, sp, 32
	
	# return to main
	ret
