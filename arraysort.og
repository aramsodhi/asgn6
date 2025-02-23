.globl swap 
.globl selectionSort
 
#void selectionSort(int arr[], int i, int n){
# find minimum element in unsorted subarray [i..n-1] and swap with arr[i]

# s0 = address of array
# s1 = min
# s2 = j
# s3 = i
# s4 = n

selectionSort:
	# callee setup goes here
	# allocate space on the stack
	addi sp, sp, -32
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

for:
	# use s2 = j = i + 1
	addi s2, s3, 1

forloop:
	# end looping when j >= n
	bge s2, s4, endfor
	
	# t0 = j index converted to a byte offset
	slli t0, s2, 2
	
	# t1 = address of array plus byte offset (address of arr[j])
	add t1, t0, s0
	
	# t2 = load arr[j] from memory
	lw t2, 0(t1)

	# t3 = min index converted to a byte offset
	slli t3, s1, 2
	
	# t4 = address of array plus byte offset (address of arr[min])
	add t4, t3, s0
	
	# t5 = load arr[min] from memory
	lw t5, 0(t4)

if1:
	# only set min to j if arr[j] < arr[min]
	bge t2, t5, endif1
	
	# update index of minimum element (min = j)
	mv s1, s2

endif1:
	# increment j
	addi s2, s2, 1
	
	# branch to top of loop
	b forloop
	
endfor:
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
	
	# caller setup and subroutine call for selectionSort
	mv a0, s0
	mv a1, t6
	mv a2, s4
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

# Utility function to swap values at two indices in an array 
# a0 contains address of arr
# a1 contains index of first element to swap
# a2 contains index of second element to swap
swap: 
	# convert i and j to byte offsets
	slli a1, a1, 2
	slli a2, a2, 2
	
	# calculate addresses for elements and indicies i and j
	add a1, a0, a1
	add a2, a0, a2
	
	# get elements at addresses from memory
	lw t1, 0(a1)
	lw t2, 0(a2)
	
	# store each element at the other element's address (swap)
	sw t1, 0(a2)
	sw t2, 0(a1)
	
	ret