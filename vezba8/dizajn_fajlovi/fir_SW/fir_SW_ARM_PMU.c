#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "test_vect.h"

static inline void init_perfcounters (int32_t do_reset, int32_t enable_divider)
{
  // in general enable all counters (including cycle counter)
  int32_t value = 1;

  // peform reset:
  if (do_reset)
  {
    value |= 2;     // reset all counters to zero.
    value |= 4;     // reset cycle counter to zero.
  }

  if (enable_divider)
    value |= 8;     // enable "by 64" divider for CCNT.

  value |= 16;

  // program the performance-counter control-register:
  asm volatile ("MCR p15, 0, %0, c9, c12, 0\t\n" :: "r"(value));

  // enable all counters:
  asm volatile ("MCR p15, 0, %0, c9, c12, 1\t\n" :: "r"(0x8000000f));

  // clear overflows:
  asm volatile ("MCR p15, 0, %0, c9, c12, 3\t\n" :: "r"(0x8000000f));
}

static inline unsigned int get_cyclecount (void)
{
  unsigned int value;
  // Read CCNT Register
  asm volatile ("MRC p15, 0, %0, c9, c13, 0\t\n": "=r"(value));
  return value;
}

int main()
{
    init_platform();
    int i,j;

    long long int reg[FIR_ORD+1];
    //reg init
    for (i=0;i<=FIR_ORD;i++)
    	reg[i] = 0;

    print("Test start!\n");

    /* enable user-mode access to the performance counter*/
    asm ("MCR p15, 0, %0, C9, C14, 0\n\t" :: "r"(1));
    /* disable counter overflow interrupts (just in case)*/
    asm ("MCR p15, 0, %0, C9, C14, 2\n\t" :: "r"(0x8000000f));
    // init counters:
    init_perfcounters (1, 1);
    unsigned int t = get_cyclecount();

    for(i = 0; i<SAMPLE_CNT; i++){
    	for(j = FIR_ORD; j>0;j--){
    		reg[j] = reg[j-1] + (((long long)(b_s[j-1])) * input[i]);
    	}
    }

    t = get_cyclecount() - t;
    printf("Clock cycle cnt/64 = %d\n",t);
    print("Test finished!\n");

    cleanup_platform();
    return 0;
}