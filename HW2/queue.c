#include <stdint.h>
#include "queue.h"


PCB_Q_t rq;
PCB_t *Running;

void init_q(PCB_Q_t *q)
{
    q->head = q->tail = 0;
}

void init_rq()
{
    Running = 0;
    init_q(&rq);
}

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
        return 0;
    
    PCB_t *dq_pcb = q->head;
    q->head = q->head->next;
    return dq_pcb;
}

void enqueue_r(PCB_t *pcb)
{
    enqueue(&rq, pcb);
    return;
}

