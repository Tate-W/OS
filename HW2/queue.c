#include <stdint.h>

void enqueue(PCB_Q_t *q, PCB_t *pcb);
PCB_t *dequeue(PCB_Q_t *q);

struct PCB
{
    uint64_t sp;
    uint32_t pid;
    struct PCB *next;
};
typedef struct PCB PCB_t;

struct PCB_Q
{
    PCB_t *head;
    PCB_t *tail;
};
typedef struct PCB_Q PCB_Q_t;

void enqueue(PCB_Q_t *q, PCB_t *pcb)
{
    pcb->next = 0;
    if (q->tail == 0)
        q->tail = q->head = pcb;
    else
    {
        q->tail->next = pcb;
        q->tail = pcb;
    }
}

PCB_t *dequeue(PCB_Q_t *q)
{
    if (q->head == 0)
    {
        /* code */
    }
    
}


