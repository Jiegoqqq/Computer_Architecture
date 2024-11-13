.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)                # the pointer to the start of the matrix
    sw s1, 4(sp)                # the number of rows in the matrix
    sw s2, 8(sp)                # the number of columns in the matrix
    sw s3, 12(sp)               # the returned file descriptor
    sw s4, 16(sp)               # the total of elements
    sw s5, 20(sp)               # counter for elements
    sw ra, 24(sp)
    
    add s0, a1, x0
    add s1, a2, x0
    add s2, a3, x0
    blt s1, x0, eof_or_error
    blt s2, x0, eof_or_error
    
    #fopen
    add a1, a0, x0
    addi a2, x0, 1 #permission 
    call fopen
    #check if error or not (a0 is the return of the file descriptor)
    addi t0, x0, -1
    beq t0, a0, fopen_error
    
    #fwrite (row)
    add s3, a0, x0 # let s3 to save the return file_description
    
    add a1, s3, x0
    addi sp, sp, -4
    sw s1, 0(sp)
    add a2, sp, x0
    addi sp, sp, 4
    addi a3, x0, 1
    addi a4, x0, 4
    call fwrite
    bne a0, a3, fwrite_error
    #fwrite (column)
    
    add a1, s3, x0
    addi sp, sp, -4
    sw s2, 0(sp)
    add a2, sp, x0
    addi sp, sp, 4
    addi a3, x0, 1
    addi a4, x0, 4
    call fwrite
    bne a0, a3, fwrite_error
    
    mul s4, s1, s2 #set s4=s1*s2
    add s5, x0, x0 #set s5 to be a counter
    
write_entry:
    beq s5, s4, finish_write
    add a1, s3, x0
    add a2, s5, x0 #buffer to read from
    addi t0, x0, 4 
    mul a2, a2, t0
    add a2, a2, s0
    addi a3, x0, 1
    addi a4, x0, 4
    call fwrite
    bne a0, a3, fwrite_error
    addi s5, s5, 1
    j write_entry

finish_write:
    add a1, s3, x0 #file descriptor
    call fclose
    bne a0, x0, fclose_error
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

eof_or_error:
    li a1 1
    jal exit2
fopen_error:
    li a1, 53         # error code 53 for fopen error
    jal exit2

fwrite_error:
    li a1, 54          # error code 54 for fwrite error
    jal exit2

fclose_error:
    li a1, 55          # error code 55 for fclose error
    jal exit2    
