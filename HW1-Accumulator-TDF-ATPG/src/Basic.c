#include <stdio.h>
#include <stdbool.h>

int main() {
    printf("Truth Table for Combinational Part of Accumulator Circuit\n");
    printf("AC[3:0]\t|X[1:0]\t|New AC[3:0]\n");
    printf("--------------------------------------------\n");
    bool ac[4], x[2], s[4] ,c[3];
    for (int a = 0; a < 16; a++) {        
        for (int i = 0; i < 4; i++) {        
            ac[0] = (a >> 0) & 1;
            ac[1] = (a >> 1) & 1;
            ac[2] = (a >> 2) & 1;
            ac[3] = (a >> 3) & 1;
            
            x[0] = (i >> 0) & 1;
            x[1] = (i >> 1) & 1;
            
            s[0] = ac[0] ^ x[0];
            c[0] = ac[0] & x[0];
            
            s[1] = (ac[1] ^ x[1]) ^ c[0];
            c[1] = (ac[1] & x[1]) | ((ac[1] ^ x[1]) & c[0]);
            
            s[2] = ac[2] ^ c[1];
            c[2] = ac[2] & c[1];
            
            s[3] = ac[3] ^ c[2];
            
            printf("%d%d%d%d\t|%d%d\t|%d%d%d%d\n", ac[3], ac[2], ac[1], ac[0], x[1], x[0], s[3], s[2], s[1], s[0]);
        }
    }
    return 0;
}