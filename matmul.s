.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1 # init t0 to min height/width of matrix
    blt a1, t0, exit_bad_dimensions # if rowsA < 1, exit
    blt a2, t0, exit_bad_dimensions # if colsA < 1, exit
    blt a4, t0, exit_bad_dimensions # if rowsB < 1, exit
    blt a5, t0, exit_bad_dimensions # if colsB < 1, exit
    bne a2, a4, exit_bad_dimensions # if colsA =/ rowsB, exit
    
    # Prologue
    
    addi sp, sp, -36 # move stack pointer down
    # store necessary s registers on the stack
    # sw s11, 48(sp)
    # sw s10, 44(sp)
    # sw s9, 40(sp)
    sw ra, 36(sp) # store return address before func call
    sw s0, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw s4, 16(sp)
    sw s5, 12(sp)
    sw s6, 8(sp)
    sw s7, 4(sp)
    sw s8, 0(sp)
    
    
    # load important info into s registers
    li s0, 0 # i counter
    li s1, 0 # j counter
    mv s2, a0 # pointer to matrix A
    mv s3, a1 # A rows
    mv s4, a2 # A cols
    mv s5, a3 # pointer to matrix B
    mv s6, a4 # B rows
    mv s7, a5 # B cols
    mv s8, a6 # pointer to matrix C
    
    
outer_loop_start:
    beq s0, s3, outer_loop_end # if i = A rows, j outer_loop_end
    j inner_loop_start # else, jump inner_loop_start
    
inner_loop_start:
    beq s1, s7, inner_loop_end # if j = B cols, jump inner_loop end
    mv a0, s2 # pass pointer to A into a0
    mv a1, s5 # pass pointer to B into a1
    mv a2, s4 # pass A cols into a2
    li a3, 1 # pass 1 (stride A) into a3
    mv a4, s7 # pass B cols (stride B) into a4
    jal dot # compute dot product of row i of A, row j of B
    lw ra, 36(sp) # recover return address after call returns
    sw a0, 0(s8) # place product in array C
    add t0, x0, x0 # zero out t0
    addi s1, s1, 1 # increment j
    addi s5, s5, 4 # update pointer to B
    addi s8, s8, 4 # update pointer to matrix C
    j inner_loop_start # else, jump innner_loop_end


inner_loop_end:
    add s1, x0, x0 # set j equal to 0
    add t0, x0, s7 # store number of B cols in t0
    slli t0, s7, 2 # mul by size of int
    sub s5, s5, t0 # set pointer back by 3 ints
    addi s0, s0, 1 # increment i
    add t1, x0, x0 # set t1 to 1
    slli t1, s4, 2 # num of elements to skip in array * sizeof int
    add s2, s2, t1 # update pointer to matrix A
    j outer_loop_start # jump outer_loop_start


outer_loop_end:


    # Epilogue
    
    mul t0, s3, s7 # store length of result array
    slli t0, t0, 2 # multiply by size of int
    sub s8, s8, t0 # return pointer to beginning of array
    mv a6, s8 # place pointer to C back in a6 
    
    
    # restore s registers
    
    lw s8, 0(sp)
    lw s7, 4(sp)
    lw s6, 8(sp)
    lw s5, 12(sp)
    lw s4, 16(sp)
    lw s3, 20(sp)
    lw s2, 24(sp)
    lw s1, 28(sp)
    lw s0, 32(sp)
    lw ra, 36(sp) # recover return address after call returns
    # lw s9, 40(sp)
    # lw s10, 44(sp)
    # lw s11, 48(sp)
    
  
    # update stack pointer
    addi sp, sp, 36
    
    jr ra
    
    
exit_bad_dimensions:
    li a0, 38 # load error code into a0
    j exit # exit

