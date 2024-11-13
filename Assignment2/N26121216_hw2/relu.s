.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the #total of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    beq t1 , a1, loop_end # for t1 from 0 to a1-1
    # Load value every 4 bytes
    addi t2, x0, 2 # one number has 4 bytes (sizeof(int))
    sll t3, t1, t2
    add t2, t3, a0 
    lw t4, 0(t2)
    
    # if t4 > 0
    bge t4, x0, loop_continue
    # if t4 < 0
    add t4 ,x0, x0
    sw t4, 0(t2)
    
loop_continue:
    addi t1, t1, 1
    j loop_start

loop_end:

    # Epilogue

	ret
error:
    li a0, 36          
    j exit          