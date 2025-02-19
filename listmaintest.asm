	.text

	.globl	main
main:
        li      sp, 0x7ffffe00

#init saved registers.
        li      s0, -1
        li      s1, -1
        li      s2, -1
        li      s3, -1
        li      s4, -1
        li      s5, -1
        li      s6, -1
        li      s7, -1
        li      s8, -1
        li      s9, -1
        li      s10, -1
        li      s11, -1

#init temp registers.
        li      t0, -1
        li      t1, -1
        li      t2, -1
        li      t3, -1
        li      t4, -1
        li      t5, -1
        li      t6, -1

#init arg registers.
        li      a0, -1
        li      a1, -1
        li      a2, -1
        li      a3, -1
        li      a4, -1
        li      a5, -1
        li      a6, -1
        li      a7, -1
		
#	studentlist = createList(studentArr, SIZE);
	li	a1,10
	la	a0, studentArr
	jal	createList
	sw      a0,12(sp)

#        sort(&studentlist);
        addi    a0,sp,12
	jal	sort

#        printList(studentlist);
	lw      a0,12(sp)
	jal		printList
	
	jal		checkregisters
#	return	
	li	a7, 10
	ecall
	

	.globl	addStudent
# asm is nutty as the struct was passed in the registers.
addStudent:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s1,a0
	mv	s0,a1
	li	a0,20
	jal	malloc
	lw	a2,0(s0)
	lw	a3,4(s0)
	lw	a4,8(s0)
	lw	a5,12(s0)
	sw	a2,0(a0)
	sw	a3,4(a0)
	sw	a4,8(a0)
	sw	a5,12(a0)
	sw	s1,16(a0)
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra

	.globl	createList
createList:
	blez	a1,endcreateList
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	mv	s0,a0
	slli	s1,a1,2
	add	s1,s1,a1
	slli	s1,s1,2
	add	s1,a0,s1
	li	a0,0
cloop:
	lw	a1,0(s0)
	lw	a2,4(s0)
	lw	a3,8(s0)
	lw	a4,12(s0)
	lw	a5,16(s0)
	sw	a1,0(sp)
	sw	a2,4(sp)
	sw	a3,8(sp)
	sw	a4,12(sp)
	sw	a5,16(sp)
	mv	a1,sp
	jal	addStudent
	addi	s0,s0,20
	bne	s0,s1,cloop
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
endcreateList:
	li	a0,0
	ret

	.globl	printList
printList:
	beqz	a0,endprintList
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	mv	s0,a0

	lw	a0,8(s0)
	jal	printint
	li	a0, 0x20
	jal	printchar
	mv	a0,s0
	jal	printstring
	li	a0, 0x20
	jal	printchar
	lw	a0,12(s0)
	jal	printint
	li	a0, '\n'
	jal	printchar
	lw	a0,16(s0)
	jal	printList
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra

endprintList:
	ret

#essentially swizzles the next pointers of the args.
	.globl	swapNodes
swapNodes:
	sw	a2,0(a0)
	sw	a1,16(a3)
	lw	a5,16(a2)
	lw	a4,16(a1)
	sw	a4,16(a2)
	sw	a5,16(a1)
	ret

	.globl	sort
sort:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	mv	s0,a0
	lw	a0,0(a0)
	beqz	a0,sortbasecase
	jal	recurSelectionSort
	sw	a0,0(s0)
sortbasecase:
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra


	.globl malloc
malloc:
# loosely simulates sbrk system call
# a0 = amount of memory in bytes
# a0 = address to the allocated block
	li	a7, 9
	ecall
	ret
	
	.globl printchar
printchar:
	li	a7, 11
	ecall
	ret
	
	.globl printint
printint:
	li	a7, 1
	ecall
	ret
	
	.globl printstring
printstring:
	li	a7, 4
	ecall
	ret
	
	.globl	studentArr
	.data
studentArr:
	.string	"Dougy"
	.word	13
	.word	2122
	.word	0
	.string	"Timmy"
	.word	15
	.word	2122
	.word	0
	.string	"Emily"
	.word	18
	.word	2123
	.word	0
	.string	"Jimmy"
	.word	14
	.word	2120
	.word	0
	.string	"Kimmy"
	.word	11
	.word	2123
	.word	0
	.string	"Carlo"
	.word	19
	.word	2123
	.word	0
	.string	"Vicky"
	.word	22
	.word	2120
	.word	0
	.string	"Anton"
	.word	12
	.word	2322
	.word	0
	.string	"Brady"
	.word	10
	.word	2120
	.word	0
	.string	"Sonya"
	.word	16
	.word	2123
	.word	0

.text
checkregisters:
	li 	t1, 1
     li   t0, 0x7ffffe00

	beq	t0, sp, SPOK
#sp corrupted
	la a0, spmsg
	li a7 4
	ecall
	li	t1, 0
SPOK:
	li   t0, -1
     beq	t0, s0, S0OK
#s0 corrupted
	la a0, s0msg
	li a7 4
	ecall
	li	t1, 0
S0OK:
     beq	t0, s1, S1OK
#s1 corrupted
	la a0, s1msg
	li a7 4
	ecall
	li	t1, 0
S1OK:

     beq	t0, s2, S2OK
#s2 corrupted
	la a0, s2msg
	li a7 4
	ecall
	li	t1, 0
S2OK:

     beq	t0, s3, S3OK
#s3 corrupted
	la a0, s3msg
	li a7 4
	ecall
	li	t1, 0
S3OK:

     beq	t0, s4, S4OK
#s4 corrupted
	la a0, s4msg
	li a7 4
	ecall
	li	t1, 0
S4OK:

     beq	t0, s5, S5OK
#s5 corrupted
	la a0, s5msg
	li a7 4
	ecall
	li	t1, 0
S5OK:

     beq	t0, s6, S6OK
#s6 corrupted
	la a0, s6msg
	li a7 4
	ecall
	li	t1, 0
S6OK:

     beq	t0, s7, S7OK
#s7 corrupted
	la a0, s7msg
	li a7 4
	ecall
	li	t1, 0
S7OK:

     beq	t0, s8, S8OK
#s8 corrupted
	la a0, s8msg
	li a7 4
	ecall
	li	t1, 0
S8OK:

     beq	t0, s9, S9OK
#s9 corrupted
	la a0, s9msg
	li a7 4
	ecall
	li	t1, 0
S9OK:

     beq	t0, s10, S10OK
#s10 corrupted
	la a0, s10msg
	li a7 4
	ecall
	li	t1, 0
S10OK:

     beq	t0, s11, S11OK
#s11 corrupted
	la a0, s11msg
	li a7 4
	ecall
	li	t1, 0
S11OK:

#check pass flag
     beqz	t1 NOPASS
	la a0, passmsg
	li a7 4
	ecall
NOPASS:
ret

.data
spmsg:	.string	 "SP not restored.\n"
s0msg:	.string	 "S0 not preserved.\n"
s1msg:	.string	 "S1 not preserved.\n"
s2msg:	.string	 "S2 not preserved.\n"
s3msg:	.string	 "S3 not preserved.\n"
s4msg:	.string	 "S4 not preserved.\n"
s5msg:	.string	 "S5 not preserved.\n"
s6msg:	.string	 "S6 not preserved.\n"
s7msg:	.string	 "S7 not preserved.\n"
s8msg:	.string	 "S8 not preserved.\n"
s9msg:	.string	 "S9 not preserved.\n"
s10msg:	.string	 "S10 not preserved.\n"
s11msg:	.string	 "S1 not preserved.\n"
passmsg:	.string	 "Callee Saved registers check passes.\n"
