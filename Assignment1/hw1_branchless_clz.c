// clz function without loop
#include <stdio.h>
#include <stdint.h>
    
uint16_t branchless_clz(uint32_t x)
{
    //fill all bits
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    //perform fast bit counting
    x -= ((x >> 1) & 0x55555555); 
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);  
    x = ((x >> 4) + x) & 0x0f0f0f0f;  
    x += (x >> 8);  
    x += (x >> 16);  
    return (32 - (x & 0x3f));  
}

int BinaryGap(int n) {
    // remove the leading zero
    int clz = branchless_clz(n);
    int max_gap = 0;
    int last_position = -1; // Store the position of the previous '1'

    // Start scanning from the remaining valid bits
    for (int i = 31 - clz; i >= 0; --i) {
        if (n & (1U << i)) {
            if (last_position != -1) {
                int gap = last_position - i;
                if (gap > max_gap) {
                    max_gap = gap;
                }
            }
            last_position = i; // Update the last occurrence of '1'
        }
    }
    return max_gap;
}
int main() {
    int example1 = 22;
    int binary_gap_result1 = BinaryGap(example1);
    
    int example2 = 8;
    int binary_gap_result2 = BinaryGap(example2);
    
    int example3 = 2098185;
    int binary_gap_result3 = BinaryGap(example3);

    printf("The Binary Gap of %d is: %d\n", example1, binary_gap_result1);
    printf("The Binary Gap of %d is: %d\n", example2, binary_gap_result2);
    printf("The Binary Gap of %d is: %d\n", example3, binary_gap_result3);

    return 0;
}