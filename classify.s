.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    # check args
    addi t0, x0, 0 # init t0 to 0
    addi t0, x0, 3 # set t0 to 5
    blt a0, t0, invalid_args # if not 5 args, exit with 31 NOT CORRECT
    
    
    # store s registers on stack
    addi sp, sp, -52
    sw ra, 48(sp)
    sw s0, 44(sp)
    sw s1, 40(sp)
    sw s2, 36(sp)
    sw s3, 32(sp)
    sw s4, 28(sp)
    sw s5, 24(sp)
    sw s6, 20(sp)
    sw s7, 16(sp)
    sw s8, 12(sp)
    sw s9, 8(sp)
    sw s10, 4(sp)
    sw s11, 0(sp)
    
 
    # store original args in s registers
    addi a1, a1, 4 # moving a1 -> a1[1]
    lw s0, 0(a1) # pointer to filepath string of M0
    addi a1, a1, 4 # a[1] -> a[2]
    lw s1, 0(a1) # pointer to filepath string of M1
    addi a1, a1, 4 # a[2] -> a[3]
    lw s2, 0(a1) # pointer to filepath string of INPUT
    addi a1, a1, 4 # a[3] -> a[4]
    lw s3, 0(a1) # pointer to filepath string of OUTPUT
    mv s4, a2 # 0 if print, else no print
    
    
    # allocate space for m0 (a1, a2)
    li a0, 8 # allocate 8 bytes of memory
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # allocate space for a1, a2 ptrs
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq a0, x0, fail_malloc # if error allocating, return with 26
    
    
    # Read pretrained m0
    mv a1, a0 # pass ptr to first int 
    addi a0, a0, 4 # increment ptr to next int
    mv a2, a0 # pass ptr to second int
    mv a0, s0 # pass filename string for m0 into read_matrix
    
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    
    addi sp, sp -4
    sw ra, 0(sp)
    jal read_matrix # read m0, return ptr to m0 in memory
    lw ra, 0(sp)
    addi sp, sp, 4
    
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8
    
    
    mv s0, a0 # replace filepath with ptr to m0 in memory
    lw s5, 0(a1) # m0 rows
    lw s6, 0(a2) # m0 cols
    
    # free a1/a2
    
    mv a0, a1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free
    lw ra, 0(sp)
    addi sp, sp, 4
    
    
    
    # allocate space for m1 (a1, a2)
    li a0, 8 # allocate 8 bytes of memory
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # allocate space for a1, a2 ptrs
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq a0, x0, fail_malloc # if error allocating, return with 26


    # Read pretrained m1
    mv a1, a0 # pass ptr to first int 
    addi a0, a0, 4 # increment ptr to next int
    mv a2, a0 # pass ptr to second int
    mv a0, s1 # pass filename string for m1 into read_matrix
    
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    
    addi sp, sp -4
    sw ra, 0(sp)
    jal read_matrix # read m1, return ptr to m1 in memory
    lw ra, 0(sp)
    addi sp, sp, 4
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8
    
    
    mv s1, a0 # replace filepath with ptr to m1 in memory
    
    lw s7, 0(a1) # m1 rows
    lw s8, 0(a2) # m1 cols
    
    
    # free a1
    mv a0, a1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free
    lw ra, 0(sp)
    addi sp, sp, 4

    # allocate space for INPUT (a1, a2)
    li a0, 8 # allocate 8 bytes of memory
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # allocate space for a1, a2 ptrs
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq a0, x0, fail_malloc # if error allocating, return with 26
    
    
    # Read input matrix
    mv a1, a0 # pass ptr to first int 
    addi a0, a0, 4 # increment ptr to next int
    mv a2, a0 # pass ptr to second int
    mv a0, s2 # pass filename string for INPUT into read_matrix
    
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    
    addi sp, sp -4
    sw ra, 0(sp)
    jal read_matrix # read INPUT, return ptr to m0 in memory
    lw ra, 0(sp)
    addi sp, sp, 4
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8
    
    mv s2, a0 # replace filepath with ptr to INPUT in memory
    lw s9, 0(a1) # INPUT rows
    lw s10, 0(a2) # INPUT cols
    
    # free a1
    mv a0, a1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free
    lw ra, 0(sp)
    addi sp, sp, 4


    # Compute h = matmul(m0, input)
    addi a0, x0, 0 # init t0 to 0
    mul a0, s5, s10 # mul m0 rows by INPUT cols to find size of output matrix
    slli a0, a0, 2
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # allocate space for output matrix 
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq a0, x0, fail_malloc # if error allocating, return with 26
    
    mv s11, a0 # move ptr to matrix C into s register
    
    # pass in args for matmul
    mv a0, s0 # pass ptr to m0 
    mv a1, s5 # pass m0 rows
    mv a2, s6 # pass m0 cols
    mv a3, s2 # pass ptr to INPUT
    mv a4, s9 # pass INPUT rows
    mv a5, s10 # pass INPUT cols
    mv a6, s11 # pass ptr to output matrix C
    
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal matmul # h = matmul(m0, input)
    lw ra, 0(sp)
    addi sp, sp, 4
    
    # free ptr to m0
    mv a0, s0 
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free
    lw ra, 0(sp)
    addi sp, sp, 4

    # Compute h = relu(h)
    mv a0, s11 # pass ptr to h
    addi a1, x0, 0 # init t0 to 0
    mul a1, s5, s10 # mul m0 rows by INPUT cols to find size of output matrix
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal relu # h = relu(h)
    lw ra, 0(sp)
    addi sp, sp, 4
    

    # Compute o = matmul(m1, h)
    addi a0, x0, 0 # init a0 to 0
    mul a0, s7, s10 # mul m1 rows by INPUT cols to find size of o
    slli a0, a0, 2
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal malloc # allocate space for output matrix o
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq a0, x0, fail_malloc # if error allocating, return with 26
    
    mv s0, a0 # store ptr to o in s0
    
    # pass in args to matmul
    mv a0, s1 # pass ptr to m1
    mv a1, s7 # pass m1 rows
    mv a2, s8 # pass m1 cols
    mv a3, s11 # pass ptr to h
    mv a4, s5 # pass h rows (same as m0 rows)
    mv a5, s10 # pass h cols (same as INPUT cols)
    mv a6, s0 # pass ptr to output matrix o
    
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal matmul # o = matmul(m1, h)        
    lw ra, 0(sp)
    addi sp, sp, 4
    


    # Write output matrix o
    mv a0, s3 # pass ptr to output file 
    mv a1, s0 # pass ptr to o matrix
    mv a2, s7 # pass o rows (same as m1 rows)
    mv a3, s10 # pass o cols (same as INPUT cols)
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_matrix # write matrix o to output file
    lw ra, 0(sp)
    addi sp, sp, 4
    

    # Compute and return argmax(o)
    mv a0, s0 # pas ptr to o matrix
    addi a1, x0, 0 # init a1 to 0
    mul a1, s7, s10 # mul o rows by o cols gives num of elements
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal argmax # computes and returns argmax(o)
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv t0, a0
    addi sp, sp, -4
    sw t0, 0(sp)
    
    mv a0, s0
   
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free
    lw ra, 0(sp)
    addi sp, sp, 4
    
    lw t0, 0(sp)
    addi sp, sp, 4
    
    mv s0, t0

    # If enabled, print argmax(o) and newline
    
    beq s4, x0, print # if not print, jump to exit
    j epilogue
    
    # print argmax(o)
print:
    mv a0, s0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal print_int
    lw ra, 0(sp)
    addi sp, sp, 4
    
    # print newline
    li a0, '\n' # pass newline into print_char
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal print_char # print newline
    lw ra, 0(sp)
    addi sp, sp, 4

epilogue:
    # free all allocated data
    mv a0, s0
    addi sp, sp, -4
    sw ra, 0(sp)
    # jal free # free s0
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv a0, s1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free # free s1
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv a0, s2
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free # free s2
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv a0, s3
    addi sp, sp, -4
    sw ra, 0(sp)
    # jal free # free s3
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv a0, s11
    addi sp, sp, -4
    sw ra, 0(sp)
    jal free # free s11
    lw ra, 0(sp)
    addi sp, sp, 4
    
    
    
    
    # restore s registers and sp
    lw ra, 48(sp)
    
    lw s1, 40(sp)
    lw s2, 36(sp)
    lw s3, 32(sp)
    lw s4, 28(sp)
    lw s5, 24(sp)
    lw s6, 20(sp)
    lw s7, 16(sp)
    lw s8, 12(sp)
    lw s9, 8(sp)
    lw s10, 4(sp)
    lw s11, 0(sp)
    
    
   
    mv a0, s0 # return argmax(o)
    
    lw s0, 44(sp)
    addi sp, sp, 52
   
    
    jr ra


fail_malloc:
    li a0, 26 
    j exit


invalid_args:
    li a0, 31
    j exit
    
