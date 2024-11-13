.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory    
    addi a0, x0, 4
    call malloc
    add s0, a0, x0
    
    addi a0, x0, 4
    call malloc
    add s1, a0, x0
    #load the file_path and use read_matrix
    la a0, file_path
    add a1, s0, x0
    add a2, s1, x0
    call read_matrix
    add s5, a0, x0 # let s5 to record the answer of read_matrix
    
#     # Print out elements of matrix
#     #print the number of rows
#     lw a1, 0(s0)
#     call print_int
#     addi a1, x0, ' '
#     call print_char
#     #print the number of columns
#     lw a1, 0(s1)
#     call print_int
#     addi a1, x0, '\n'
#     call print_char    
    
    add s2, x0, x0 
    # Terminate the program
    addi a0, x0, 10
    ecall
