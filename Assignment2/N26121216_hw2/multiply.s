.globl multiply
.text

multiply:

    addi sp, sp, -8         
    sw t0, 0(sp)            
    sw t1, 4(sp)            
    
    li t0, 0                
    li t1, 0

multiply_loop:

    beq t1, a2, multiply_done  
    add t0, t0, a1            
    addi t1, t1, 1             
    j multiply_loop            

multiply_done:
    
    mv a0, t0                  

    lw t0, 0(sp)               
    lw t1, 4(sp)               

    addi sp, sp, 8             

    ret
