#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "test_vect.h"

int main()
{
    init_platform();
    int i,j;

    long long int reg[FIR_ORD+1];
    //inicijalizacija registara
    for (i=0;i<=FIR_ORD;i++)
    	reg[i] = 0;

    print("Test start!\n\r");
    for(i = 0; i<SAMPLE_CNT; i++){
    	for(j = FIR_ORD; j>0;j--){
    		reg[j] = reg[j-1] + (((long long)(b_s[j-1])) * input[i]);
    	}
    }
    print("Test finished!\n\r");

    cleanup_platform();
    return 0;
}