# Assignment 2: Classify
contributed by <`hsuhsiang`> (Hsu, Han-Hsiang)
## Essential Operations
### abs 
Transforms any integer into its absolute (non-negative) value by modifying the original value through pointer dereferencing.

1. Load the value from the input address.
2. If the value is less than zero, update it by subtracting the element from zero.
3. Store the modified value back at the same address.
### multiply
The multiply operation is frequently used. I implemented by iterative addition. Here's the process:
1. Determine the Sign: Use the XOR operation on the most significant bits (MSB) of the two numbers to determine the resulting sign. If the MSBs are different, the result will be negative; otherwise, it will be positive.
2. Convert to Absolute Values: Apply an absolute function to both numbers to ensure they are positive, simplifying the iterative addition process.
3. Perform Iterative Addition: Use a loop to repeatedly add one number to itself for the number of times specified by the other number.
4. Apply the Sign: Finally, assign the appropriate sign to the result based on the outcome from step 1.
```c 
mul:
    li t4, 0             # t4 = t2 * t3
    xor t5, t2, t3  
    srli t5, t5, 31      # t5 = sign
    bge t2, zero, next1
    sub t2, x0, t2       # t2 = |t2|
next1:                      
    bge t3, zero, mul_loop
    sub t3, x0, t3       # t3 = |t3|  
mul_loop:
    beq t2, x0, next2
    add t4, t4, t3
    addi t2, t2, -1
    j mul_loop        
next2:                   # t4 = |t2| * |t3| 
    beq t5, x0, out      # if (sign == 1)
    sub t4, x0, t4       # t4 = -|t4|
out:
```
### dot
The dot function calculates the dot product of two vectors using iterative addition. Here's the process:
1. Initialize Accumulator and Stride: Begin by setting the accumulator to zero to store the running total of the dot product. Additionally, configure the stride to the appropriate length for processing the vector elements.
2. Element-wise Multiplication: For each pair of corresponding elements in the two vectors, compute their product.
3. Add to Accumulator: Add the product from step 2 to the accumulator.
4. Move to Next Pair: Shift to the next pair of elements in the vectors and repeat steps 2 and 3.
5. Repeat Until Complete: Continue the cycle until all elements in the vectors have been processed.
6. Return Result: Once all pairs are processed, the accumulator holds the final dot product.
### matmul
The matmul function performs matrix multiplication between two matrices M0 and M1, storing the result in a third matrix D. This function uses a nested loop structure. Here's the process:
1. The outer loop iterates over the rows of M0.
2. The inner loop iterates over the columns of M1, calling the dot function to compute the dot product for each pair.
3. The result matrix D is filled row by row, with each element being the dot product of the corresponding row of M0 and column of M1.
### relu
The relu function applies the ReLU (Rectified Linear Unit) activation to an integer array in-place. This operation modifies each element x in the array with $x = max(0,x)$. 
1. Iterate through each element of the array. 
2. If the element is less than zero, store x0 (representing zero) at its address. 
3. Then move to the next element and repeat the process.
### argmax
The argmax function efficiently finds the first occurrence of the maximum value in an integer array. Here's the process:
1. Load the current element from the array.
2. Compare it with the current maximum. If the current element is larger, update both the current maximum and its index.
3. Move to the next element and repeat these steps until all elements are processed.

## challenges
I encountered some challenges while working on this homework. In dot.s, I initially implemented multiplication using the following code:
```c
    li a1, 0
Loop4:
    add a1, a1, t1
    addi t0, t0, -1
    bne t0, x0, Loop4
```
I assumed all numbers involved were positive, and surprisingly, this implementation passed both test_dot and test_matmul. Because of this, I didn’t realize there was a significant mistake in my approach.

After completing all individual modules, the issue surfaced during the classify test, where the program entered an infinite loop. To debug, I turned to classify.s, but encountered another issue: classify.s requires specific inputs, so I couldn't run it in isolation. 

I discovered that chain.s calls classify.s. However, to run chain.s successfully, I needed to modify the file paths in chain.s. After making those adjustments, it finally ran as expected.

To locate where the infinite loop occurs, I added debugging code like this:
```c
    mv t6, a0
    li a0, 0
    jal print_int
    mv a0, t6
```
This prints numbers during execution, allowing me to pinpoint where it repeatedly prints infinite zeros.


Finally, I discovered that the issue was in the multiplication logic. If the multiplicand was negative, the loop would never reach zero, causing an infinite loop. To fix this, I modified the code to make both numbers positive and added a sign detection mechanism to handle the final result correctly.

