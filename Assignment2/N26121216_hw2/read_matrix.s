.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)                # the pointer to string representing the filename
    sw s1, 4(sp)                # a pointer to the number of rows
    sw s2, 8(sp)                # a pointer to the number of columns
    sw s3, 12(sp)               # the file descriptor
    sw s4, 16(sp)               # the pointer to the matrix in memory
    sw s5, 20(sp)               # save the # of entries
    sw ra, 24(sp)
   
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    #call fopen
    add a1, s0, x0              # fopen("filename", "-r")
    add a2, x0, x0
    call fopen
    #check if error or not (a0 is the return of the file descriptor)
    addi t0, x0, -1
    beq t0, a0, fopen_error

    
    ##fread
    add s3, a0, x0


    #call fread (a1) to read the row mesenger
    add a1, s3, x0
    add a2, s1, x0
    addi a3, x0, 4
    call fread
    #check if error or not (a0 is the return of the number of bytes actually read)
    mv a1, a0
    call print_int
    bne a0, a3, fread_error
    #check the row > 0 or not
    lw t0, 0(s1)
    blt t0, x0, fread_error


    #call fread (a2) to read the column mesenger
    add a1, s3, x0
    add a2, s2, x0
    addi a3, x0, 4
    call fread
    #check if error or not (a0 is the return of the number of bytes actually read)
    bne a0, a3, fread_error
    #check the column > 0 or not
    lw t0, 0(s2)
    blt t0, x0, fread_error
    
    #call malloc
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a0, t0, t1 #get the entire element count
    add s4, a0, x0
    addi t0, x0, 4
    mul a0, a0, t0 #get the totel byte
    call malloc
    beq a0, x0, malloc_error #if return null
    
    add s5, a0, x0 #save the return pointer (a0) after malloc
    
    #to read the value of the matrix
    add a1, s3, x0 #set the file descripter after fopen
    add a2, s5, x0 #set the pointer after malloc
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a3, t0, t1
    addi t0, x0, 4
    mul a3, a3, t0
    call fread
    bne a0, a3, fread_error
    
    add a0, s3, x0
    call fclose
    bne a0, x0, fclose_error
    
    #Return the pointer to the matrix in memory
    add a0, s4, x0
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

malloc_error:
    li a1, 48          # error code 48 for malloc error
    jal exit2

fopen_error:
    li a1, 50          # error code 50 for fopen error
    jal exit2

fread_error:
    li a1, 51          # error code 51 for fread error
    jal exit2

fclose_error:
    li a1, 52          # error code 52 for fclose error
    jal exit2

        