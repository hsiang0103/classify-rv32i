.import abs.s
.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    mv s0, a0       # Pointer to first input array
    mv s1, a1       # Pointer to second input array
    mv s2, a2       # Number of elements to process
    li t0, 0        # output        
    li t1, 0        # counter of Number of elements to process
    slli s3, a3, 2  # s3 = stride0 * 4
    slli s4, a4, 2  # s4 = stride1 * 4

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    lw t2, 0(s0)
    lw t3, 0(s1)

    li t4, 0            # t4 = t2 * t3
    xor t5, t2, t3  
    srli t5, t5, 31     # t5 = sign
    bge t2, zero, next1
    sub t2, x0, t2
    
next1:
    bge t3, zero, mul_loop
    sub t3, x0, t3
mul_loop:
    beq t2, x0, next2
    add t4, t4, t3
    addi t2, t2, -1
    j mul_loop
next2:
    beq t5, x0, out
    sub t4, x0, t4
out:
    add t0, t0, t4
    addi t1, t1, 1
    add s0, s0, s3
    add s1, s1, s4
    j loop_start
loop_end:
    mv a0, t0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
