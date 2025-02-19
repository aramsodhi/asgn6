.globl main

.data

#studentNode studentlist[SIZE] = {
#                {"Doug", 13, 2122},
#                {"Timmy", 15, 2122},
#                {"Emily", 18, 2123},
#                {"Joel", 14, 2120},
#                {"Kimmy", 11, 2123},
#                {"Carlo", 19, 2123},
#                {"Vicky", 22, 2120},
#                {"Anton", 12, 2322},
#                {"Brad", 10, 2120},
#                {"Sonya", 16, 2123}
#            };
    
studentlist:
        .string "Doug"
        .byte -1
        .word   13
        .word   2122
        .string "Timmy"
        .word   15
        .word   2122
        .string "Emily"
        .word   18
        .word   2123
        .string "Joel"
        .word   14
        .word   2120
        .string "Kimmy"
        .word   11
        .word   2123
        .string "Carl"
        .byte -1
        .word   19
        .word   2123
        .string "Vicky"
        .word   17
        .word   2120
        .string "Anton"
        .word   12
        .word   2322
        .string "Brad"
        .byte -1
        .word   10
        .word   2120
        .string "Sonya"
        .word   16
        .word   2123

.text

#int main() {
main:
     li   sp, 0x7ffffe00
     

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
		
		
#    int n = SIZE;
#   printArray(studentlist, n);
    la  a0, studentlist
    li  a1, 10
    jal printArray
	li	a0, '\n'
     li	a7,	11
     ecall
	
#    selectionSort(studentlist, 0, n);
    la  a0, studentlist
    mv  a1, zero
    li  a2, 10
    jal selectionSort
    
#   printArray(studentlist, n);
    la  a0, studentlist
    li  a1, 10
    jal printArray
	
	
#    check callee saved registers.
        jal 	 checkregisters
        li      sp, 0x7ffffd00
		
#    return 0;
        addi    a7, x0, 10
        ecall

 

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
