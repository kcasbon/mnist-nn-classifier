.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue



    # store necessary s registers on stack
    addi sp, sp, -16
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)
    
    # load original args into s registers
    mv s0, a0 # ptr to filename
    mv s1, a1 # ptr to matrix in memory
    mv s2, a2 # matrix rows
    mv s3, a3 # matrix cols
    
    
    # open file with write permissions, exit with 27 if error
    li a1, 1 # write only permissions 
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fopen # open the file w write perms
    lw ra 0(sp)
    addi sp, sp, 4
    addi t0, x0, 0 # initialize t0 to 0
    addi t0, t0, -1
    beq a0, t0, fail_open # exit with 27 if error
    addi sp, sp, -4
    sw s4, 0(sp)
    mv s4, a0 # store file descriptor in s4
    
    
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # store number of rows/cols to memory 
    addi sp, sp, -8
    sw s2, 0(sp) # store num rows to memory
    sw s3, 4(sp) # store num cols to memory 
    
    
    # write address of num rows/cols to file
    addi t0, x0, 0 # init t0 to 0
    addi t2, x0, 0 # init t1 to 0
    addi t0, x0, 2 # num of elements to write
    addi t2, x0, 4 # size of each element
   
    
    mv a0, s4 # pass file descriptor into fwrite
    mv a1, sp # pass ptr to memory (rows/cols) into fwrite
    mv a2, t0 # pass num elements into fwrite
    mv a3, t2 # pass size of elements into fwrite
    
    addi sp, sp, 8
    
    
    jal fwrite # write rows, cols to file
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi t0, x0, 0 # init t0 to 0
    addi t0, x0, 2 # num of elements that should have been written
    bne a0, t0, fail_write # exit with 30 if error
    
    
    # write rest of matrix to file
    addi t0, x0, 0 # init t0 to 0
    addi t1, x0, 0 # init t1 to 0
    
    mul t0, s2, s3 # store num elements in t0
    addi t1, x0, 4 # store size of elements in t1
    
    mv a0, s4 # pass file descriptor into a0
    mv a1, s1 # pass pointer to matrix into a1
    mv a2, t0 # pass num elements into a2
    mv a3, t1 # pass size of elements into a3
    
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fwrite # write matrix to file
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi t0, x0, 0 # init t0 to 0
    mul t0, s2, s3 # num of elements that should have been written
    bne a0, t0, fail_write # exit with 30 if error
    
    # close the file
    mv a0, s4 # pass file descriptor into fclose
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fclose # close the file
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi t0, x0, 0 # init t0 to 0
    addi t0, x0, -1 # -1 returned from fclose if failure
    beq a0, t0, fail_close # exit with 28 if error


    # Epilogue

    # restore s registers from the stack
    lw s4, 0(sp)
    lw s3, 4(sp)
    lw s2, 8(sp)
    lw s1, 12(sp)
    lw s0, 16(sp)
    
    addi sp, sp, 20

    jr ra
    
    
    
fail_open:
    li a0, 27
    j exit


fail_write:
    li a0, 30
    j exit


fail_close:
    li a0, 28
    j exit
    
    