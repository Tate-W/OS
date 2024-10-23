#ifndef PCB_H
#define PCB_H

#include <stdint.h>

struct PCB
{
    uint64_t *sp;
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

#endif