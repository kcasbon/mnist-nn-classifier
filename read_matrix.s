.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
   
    
    # move filepathname into s0 and store s0 on stack
    addi sp, sp -4
    sw s0, 0(sp)
    mv s0, a0
    
    addi sp, sp, -8
    sw s4, 0(sp)
    sw s5, 4(sp)
    
    mv s4, a1
    mv s5, a2

    
    # open the file, exit with 27 if error
    li a1, 0 # setting a1 to 0 (read permissions)
    
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fopen # open file
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi t0, x0, 0 # set t0 to 0
    addi t0, x0, -1
    beq a0, t0, fail_open # if failed to open, a0 == -1
    
    addi sp, sp, -4
    sw s2, 0(sp) 
    mv s2, a0 # store file descriptor on stack
    
    
    # allocate 8 bytes of space for rows, cols
    #li a0, 8 # number of bytes to be allocated
    #addi sp, sp, -4
    #sw ra, 0(sp)
    #jal malloc 
    #lw ra, 0(sp)
    #addi sp, sp, 4
    #beq a0, x0, fail_malloc # if malloc fails, exit with 26
    
    
    # read rows, cols from file, exit with 28 if error
    mv a1, s4 # pass the pointer to the buffer into a1
    addi sp, sp, -4
    sw s3, 0(sp)
    mv s3, a1
    mv a0, s2 # pass file descriptor into a0
    li a2, 8 # read first 8 bytes
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fread # read rows, cols
    lw ra, 0(sp)
    addi sp, sp, 4
    mv a1, s3
    lw s3, 0(sp)
    addi sp, sp, 4
    li a2, 8 # make sure a2 is still == 8 bytes
    bne a0, a2, fail_read # if 8 bytes are not read, exit with 29
    
    # store rows, cols in a1, a2
    addi t1, x0, 0 # set t1 to 0
    addi t2, x0, 0 # set t2 to 0
    
    lw t1, 0(a1) # hold num rows in a1
    lw t2, 4(a1) # hold num cols in a2
    
    sw t1, 0(s4) # store num rows in provided memory
    sw t2, 0(s5) # store num cols in provided memory
    
    
    # allocate space for matrix
    mul t2, t1, t2 # store total num of elements in t2
    slli t2, t2, 2 # mult num elements by 4 bytes
    mv a0, t2 # pass number of elements into a0
    addi sp, sp, -4
    sw t2, 0(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # alloate necessary space
    lw ra, 0(sp)
    addi sp, sp, 4
    lw t2, 0(sp)
    addi sp, sp, 4
    beq a0, x0, fail_malloc # if malloc fails, exit with 26
    
    
    # store pointer to matrix in s1
    addi sp, sp, -4
    sw s1, 0(sp)
    mv s1, a0
    
    
    # read matrix to allocated space
    mv a1, a0 # pass pointer to memory into a1
    mv a0, s2 # pass filepathname into a0
    mv a2, t2 # pass num elements into a2
    addi sp, sp -4 
    sw t2, 0(sp)
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fread # read matrix
    lw ra, 0(sp)
    addi sp, sp, 4
    lw t2, 0(sp)
    addi sp, sp, 4
    bne a0, t2, fail_read
    
    
    # close the file 
    mv a0, s2 # pass file descriptor into a0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal fclose # close the file
    lw ra, 0(sp)
    addi sp, sp, 4
    li t0, -1
    beq a0, t0, fail_close # if close fails, exit with 28
    
    
    # Epilogue
    mv a0, s1 # move pointer to matrix into a0

    # restore s and ra registers
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s4, 8(sp)
    lw s5, 12(sp)
    lw s0, 16(sp)
    
    addi sp, sp, 20
    
    jr ra
    
fail_malloc:
    li a0, 26
    j exit
    
fail_open:
    li a0, 27
    j exit
    
fail_close:
    li a0, 28
    j exit

fail_read:
    li a0, 29
    j exit


    
    
