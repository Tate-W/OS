#ifndef QUEUE_H
#define QUEUE_H

#include "pcb.h"

void enqueue(PCB_Q_t *q, PCB_t *pcb);
PCB_t *dequeue(PCB_Q_t *q);
void init_rq();
void enqueue_r(PCB_t *pcb);



#endif