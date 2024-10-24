#include "pcb.h"
#include "queue.h"

#define MAX_STACKS 10
uint64_t stacks[MAX_STACKS][1024];
uint32_t next_stack = 0;

uint32_t next_pid = 0;

#define MAX_PCBS 4
uint64_t pcbs[MAX_PCBS][sizeof(PCB_t)];
uint32_t next_pcb = 0;

uint64_t *alloc_stack()
{

    if (next_stack == MAX_STACKS)
        return 0;

    return stacks[next_stack++];

}

uint64_t *alloc_pcb()
{

    if (next_pcb == MAX_PCBS)
        return 0;
    
    return pcbs[next_pcb++];

}

int create_process(int (*code_address)()) 
{

    uint64_t *st = alloc_stack();

    if (st == 0)
        return -1;

    uint64_t *sp = st + 1024;

    for (int i = 0; i < 32; i++)
    {
        sp--;
        *sp = 0;
    }

    sp += 30;
    *sp = (uint64_t) code_address;
    sp -= 30;

    PCB_t *pcb = (PCB_t *) alloc_pcb();

    if (pcb == 0)
        return -1;

    pcb->sp = sp;
    pcb->pid = next_pid;

    enqueue_r(pcb);

    return 0;

}