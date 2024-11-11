.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    li t6, 1
    blt a1, t6, handle_error

    li t1, 0            # t1 = counter
    li t2, 0            # t2 = index
    lw t3, 0(a0)        # t3 = max number
loop_start:
    beq t1, a1, loop_end
    # TODO: Add your own implementation
    lw t0, 0(a0)        # t0 = number
    ble t0, t3, next
    
new_big:
    mv t3, t0
    mv t2, t1
next:
    addi t1, t1, 1 
    addi a0, a0, 4
    
    j loop_start

loop_end:
    mv a0, t2
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    jr ra

handle_error:
    li a0, 36
    j exit
