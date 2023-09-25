.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    
    add t1, x0, x0 # init counter in t1
    add t2, x0, x0 # init running product in t2
    mv t3, a3 # init stride 1 increment in t3
    slli t3, t3, 2 # multiply stride 1 by size of int
    mv t4, a4 # init stride 2 increment in t4
    slli t4, t4, 2 # multiply stride 2 by size of int
    
    addi t0, x0, 1 # init t0 to 1
    
    bge a2, t0, check_s1 # if num elements >= 1, jump to start
    li a0, 36 # else, return code 36
    j exit # j exit
    
check_s1:
    bge a3, t0, check_s2 # if stride 1 >=, jump to start
    li a0, 37 # else return code 37
    j exit # j exit
    
check_s2:
    bge a4, t0, loop_start # if stride 2 >=, jump to start
    li a0, 37 # else return code 37
    j exit # j exit

loop_start:
    
    bge t1, a2, loop_end # if counter >= a2, jump to end
    lw t5, 0(a0) # load the next element of 1st array to t5
    lw t6, 0(a1) # load next element of 2nd array to t6
    mul t0, t5, t6 # multiply corresponding elements of each array
    add t2, t2, t0 # add product to running total
    add a0, a0, t3 # update pointer 1
    add a1, a1, t4 # update pointer 2
    addi t1, t1, 1 # update counter
    j loop_start # jump to loop_start


loop_end:


    # Epilogue
    
    mv a0, t2 # place the total value stored in t2 into a0

    jr ra
