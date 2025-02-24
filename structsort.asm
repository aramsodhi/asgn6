.globl swap
.globl selectionSort
.globl printArray

# struct studentNode {
#   char name[6];
#   int studentid;
#   int coursenum;
# };

# void selectionSort(studentNode arr[], int i, int n) {

# s0 = address of array
# s1 = min
# s2 = j
# s3 = i
# s4 = n
selectionSort:
	# callee setup and allocate space on the stack
	addi sp, sp -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)


	# use s0 for address of array
	mv s0, a0

	# use s1 for min = i
	mv s1, a1
	
	# use s3 for i
	mv s3, a1
	
	# use s4 for n
	mv s4, a2

for1:
	# use s2 = j = i + 1
	addi s2, s3, 1

forloop1:
	# end looping when j >= n
	bge s2, s4, endfor1
	
	# t0 = j index converted to a byte offset
	slli t0, s2, 4
	
	# t1 = calculate address of arr[j].studentid
	add t1, t0, s0
	addi t1, t1, 8
	
	# t2 = load arr[j].studentid from memory
	lw t2, 0(t1)
	
	# t3 = min index converted to a byte offset
	slli t3, s1, 4
	
	# t4 = cauculate address of arr[min].studentid
	add t4, t3, s0
	addi t4, t4, 8
	
	# t5 = load arr[min].studentid from memory
	lw t5, 0(t4)
	
if1:
	# only set min to j if arr[j].studentid < arr[min].studentid
	bge t2, t5, endif1

	# update index of min element (min = j)
	mv s1, s2
	
endif1:
	# increment j
	addi s2, s2, 1
	
	# branch to top of loop
	b forloop1

endfor1:
	# caller setup
	mv a0, s0
	mv a1, s1
	mv a2, s3
	
	# subroutine call to swap
	jal swap	

if2:
	# t6 = i + 1
	addi t6, s3, 1
	
	# only call selection sort if (t6 < n)
	bge t6, s4, endif2

	# caller setup
	mv a0, s0
	mv a1, t6
	mv a2, s4
	
	# recursive subroutine call to selectionSort
	jal selectionSort

endif2:
	# caller teardown for selectionSort
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)

	# deallocate space on the stack
	addi sp, sp, 32
    
	# return to main
	ret
 
 
# Function to print `n` elements of array `arr`
# a0 contains address of arr
# a1 contains n
printArray:
	# callee setup goes here
	# allocate space on the stack
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)

for2:
	# init i = 1
	li s0, 0
	
	# s1 = n  -- preserved across ecall
	mv s1, a1
	
	# s2 = address of arr -- preserved across ecall
	mv s2, a0

forloop2:
	# end for loop when i >= n
	bge s0, s1, endfor2

	# convert i to byte offset (each student struct is 16 bytes)
	slli t0, s0, 4
	
	# calculate address of arr[i].name (base address of student)
	add t1, t0, s2
	
	# calculate address of arr[i].studentid
	addi t2, t1, 8
	
	# calculate address of arr[i].coursenum
	addi t3, t1, 12
	
	# print student id
	lw a0, 0(t2)
	li a7, 1
	ecall
	
	# print a space
	li a0, ' '
	li a7, 11
	ecall
	
	# print student name
	mv a0, t1
	li a7, 4
	ecall
	
	# print a space
	li a0, ' '
	li a7, 11
	ecall

	# print coursenum
	lw a0, 0(t3)
	li a7, 1
	ecall
	
	# print newline char
	li a0, '\n'
	li a7, 11
	ecall

	# increment i
	addi s0, s0, 1
	
	# jump to top of loop
	b forloop2
	
endfor2:
	# caller teardown goes here
	# restore return address and saved registers
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	
	# deallocate space on the stack
	addi sp, sp, 16
	
	# return to main
	ret

# Utility function to swap values at two indices in an array
# a0 contains address of array of student structs
# a1 contains i
# a2 contains j
swap:
	# swap 16 bytes starting at i with 16 bytes starting at j
	# convert i and j to byte offsets
	slli t0, a1, 4
	slli t1, a2, 4

	# calculate base addresses of each student
	add t0, t0, a0
	add t1, t1, a0
	
	# swap bytes 0-3
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	
	# update addresses of next bytes to swap
	addi t0, t0, 4
	addi t1, t1, 4
	
	# swap bytes 4-7
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	
	# update addresses of next bytes to swap
	addi t0, t0, 4
	addi t1, t1, 4
	
	# swap bytes 8-11
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	
	# update addresses of next bytes to swap
	addi t0, t0, 4
	addi t1, t1, 4
	
	# swap bytes 12-15
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	
	# return to where subroutine was called from
	ret
