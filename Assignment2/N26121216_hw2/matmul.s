.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    add s7, x0, x0 #set s7=0 to be the counter of m0 S0
    
outer_loop_start:
    beq s7, s1, outer_loop_end
    add s8, x0, x0 #set s8=0 to be the counter of m1
    
inner_loop_start:
    beq s8, a5, inner_loop_end  #s8 -> s1
    #deal with m0
    addi t0, x0, 4
    mul t0, t0, s7
    mul t0, t0, s2
    add t0, t0, s0
    #deal with m1
    addi t1, x0, 4
    mul t1, t1, s8
    add t1, t1, s3
    #use dot.s to caculate the dot answer
    mv a0, t0
    mv a1, t1
    mv a2, s2
    addi a3, x0, 1 #because m0's stride is 1
    mv a4, s5 #because m1's stride is its colums
    jal ra, dot
    
    #deal with the stroed place in d
    # i place
    addi t0, x0, 4
    mul t0, t0, s5
    mul t0, t0, s7
    #j place
    addi t1, x0, 4
    mul t1, t1, s8
    # i + j , because is column major
    add t0, t0, t1
    #get the d place
    add t0, t0, s6
    #stored in d
    sw a0, 0(t0)
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:
    
    # Epilogue
    #Restore sp status
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2