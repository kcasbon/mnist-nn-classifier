.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    add t0, x0, x0 # initialize counter t0
    add t1, x0, x0 # initialize holder of index of max quantity to 0 in t1
    add t2, x0, x0 # initialize holder of max quantity t2
    add t4, x0, x0 # initialize temp value holder to 0
    
    add t3, x0, x0 # init t3 to 0
    addi t3, t3, 1# min length of array
    bge a1, t3, loop_start # ensure array is of valid length
    li a0, 36 # if not, load return code 36
    j exit # and exit
    

loop_start:
    bge t0, a1, loop_end # if reach end of array, jump to end
    lw t4, 0(a0) # load next element of input array into t4
    blt t4, t2, loop_continue # if t4 <= t2, jump to loop continue
    mv t1, t0 # update t1 with index
    mv t2, t4 # update t2 with max quantity

loop_continue:
    addi t0, t0, 1 # increment counter
    addi a0, a0, 4 # move to next int in array
    j loop_start # jump loop_start

loop_end:
    # Epilogue
    
    mv a0, t1 # store t1 in a0
    
    jr ra
