.data
    InputValue1: .word 22        # Input value for binaryGap 
    InputValue2: .word 8
    InputValue3: .word 2098185
    Actual1: .word 2
    Actual2: .word 0
    Actual3: .word 11
    max_gap: .word 0           # Store max_gap
    last_position: .word -1    # Store the position of the last '1'
    gap: .word 0               # Store temporary gap calculation
    result_text1: .string "The input value is "
    result_text2: .string " and the answer is "
    result_text3: .string " .The actual answer is "
    endl:   .string "\n"       # For printing
.text
    #First Input
    la t0, InputValue1
    lw t0, 0(t0)
    #First Actual
    la a2, Actual1
    lw a2, 0(a2)
    # Initialize max_gap = 0
    la t2, max_gap         
    li t3, 0            
    sw t3, 0(t2)           
    #last_positioan = -1 
    la t2, last_position   
    li t3, -1              
    sw t3, 0(t2)        
    jal ra, process_case
    
    #Second Input
    la t0, InputValue2
    lw t0, 0(t0)
    #Second Actual
    la a2, Actual2
    lw a2, 0(a2)
    # Initialize max_gap = 0
    la t2, max_gap         
    li t3, 0            
    sw t3, 0(t2)        
    #last_position = -1 
    la t2, last_position   
    li t3, -1           
    sw t3, 0(t2)                       
    jal ra, process_case
    
    #Third Input
    la t0, InputValue3
    lw t0, 0(t0)
    #Third Actual
    la a2, Actual3
    lw a2, 0(a2)
    # Initialize max_gap = 0
    la t2, max_gap      
    li t3, 0               
    sw t3, 0(t2)        
    #last_position = -1 
    la t2, last_position   
    li t3, -1           
    sw t3, 0(t2)                       
    jal ra, process_case
    
    # Exit program
    li a7, 10              # Syscall for exit
    ecall
    
process_case:   

    addi sp, sp, -4
    sw ra, 0(sp) 
    # Call count_leading_zero to get clz
    jal ra, my_clz
    
    lw ra, 0(sp)         
    addi sp, sp, 4 
    
    # Load clz value (from a0)
    mv t1, a0              # Store clz (leading zero count) from a0 to t1
    
    # Start scanning from the remaining valid bits: i = 31 - clz
    li t4, 31              # t4 = 31
    sub t4, t4, t1         # t4 = 31 - clz (i = 31 - clz)
    


scan_loop:
    blt t4, zero, print # If i < 0, exit loop
    
    # Check if (n & (1U << i))
    li t5, 1               # t5 = 1
    sll t5, t5, t4         # t5 = 1 << i
    and t6, t0, t5         # t6 = n & (1 << i)
 
    beqz t6, next          # If t6 == 0 (no '1' at this position), skip
    
    # Check if last_position != -1
    la t2, last_position   # Load last_position address
    lw t3, 0(t2)           # t3 = last_position
    
    li t2, -1              # Load -1 for comparison
    beq t3, t2, update_last_pos # If last_position == -1, update it
    
    # Calculate gap = last_position - i
    sub a1, t3, t4         # a1 = last_position - (gap)
    
    # Compare gap with max_gap, if gap > max_gap, update max_gap
    la t2, max_gap         # Load max_gap address
    lw t3, 0(t2)           # t3 = max_gap
    bge t3, a1, update_last_pos # if max_gap >= gap, skip update
    sw a1, 0(t2)           # Store a1 (new max_gap) in max_gap
    
update_last_pos:
    # Update last_position = i
    la t2, last_position   # Load last_position address
    sw t4, 0(t2)           # Store i in last_position
    
next:
    # Decrement i
    addi t4, t4, -1
    j scan_loop            # Repeat the loop
    
print:
    
    # Print descriptive text1
    la a0, result_text1     #(result_text1)
    li a7, 4                #(syscall number for print_string)
    ecall 
    # Return InputValue
    mv a0,t0        
    li a7, 1               # Load syscall number for print_int
    ecall
    # Print descriptive text2
    la a0, result_text2     #(result_text2)
    li a7, 4                #(syscall number for print_string)
    ecall                 
    # Return max_gap
    la t2, max_gap         # Load max_gap address
    lw a0, 0(t2)           # a0 = max_gap
    # Print the result
    li a7, 1               # Load syscall number for print_int
    ecall                  # Make the system call to print a0 (max_gap)
    # Print descriptive text3
    la a0, result_text3     #(result_text3)
    li a7, 4                #(syscall number for print_string)
    ecall 
    # Return ActualValue
    mv a0,a2      
    li a7, 1               # Load syscall number for print_int
    ecall
    # Print newline
    la a0, endl             # Load the address of the newline string (\n)
    li a7, 4                # Load syscall number for print_string
    ecall 
    
    ret
my_clz:
    addi    t4, x0, 31         
    addi    t1, x0, 0   #set a variable to count zero   
    addi    t2, x0, 1   #use unsign 1 to bitwise count       

loop:
    blt     t4, x0, exit      
    sll     t3, t2, t4         
    and     t3, t0, t3         
    bnez    t3, exit           
    addi    t4, t4, -1      
    addi    t1, t1, 1       
    j       loop            
exit:
    mv      a0, t1     
    ret