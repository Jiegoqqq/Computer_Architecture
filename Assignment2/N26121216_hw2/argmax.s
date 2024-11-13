.globl argmax
.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)
    
    li t1, 0 #counter to end
    li t2, 1  
    
    slli t2, t2, 1 #set t2=2
    add t3, x0, x0 #set t3 to record maximum index
    
loop_start:
    beq t1, a1, loop_end
    sll t4, t1, t2
    add t4, t4, a0
    lw t5, 0(t4)
    
    ble t5, t0, loop_continue
    mv t0, t5 #update the maximum value
    mv t3, t1 #update the maximum index
    
loop_continue:
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t3  # return the maximum index
    
    ret
    
handle_error:
    li a0, 36
    j exit
