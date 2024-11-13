.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # YOUR CODE HERE
    # Initialize the result to 1 (factorial of 0 is 1)
    li t0, 1         # t0 will hold the result of factorial

    # Loop through numbers from 1 to n
loop:
    beq a0, x0, end  # If a0 (n) is 0, we are done
    mul t0, t0, a0   # Multiply t0 by current value in a0 (t0 *= a0)
    addi a0, a0, -1  # Decrement a0 (n) by 1
    j loop           # Repeat until a0 becomes 0

end:
    mv a0, t0        # Move the result from t0 into a0
    jr ra
