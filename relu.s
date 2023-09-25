.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t2, x0, 0 # initializing counter
    
    add t0, x0, x0 # init t0 to 0
    addi t0, t0, 1 # minimum length of array
    bge a1, t0 loop_start # ensure the array is of valid length
    li a0, 36 # if not, load return code 36
    j exit # and exit
    
loop_start:
    bge t2, a1, loop_end # if reach end of array, jump to end
    lw t1, 0(a0) # load next element of input array to t1
    bge t1, x0, loop_continue # if this is a nonnegative #, loop back to start
    sw x0, 0(a0) # store 0 in that element of the array
    j loop_continue

loop_continue:
    addi t2, t2, 1 # increment counter
    addi a0, a0, 4 # move to nex int in array
    j loop_start


loop_end:
    

    # Epilogue


    jr ra
