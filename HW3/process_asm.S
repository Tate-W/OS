.global dispatch
.global go
.global setup_EVT
.global init_timer
.global clear_timer
.global unsupported

.extern ReadyQ
.extern Running
dispatch:
    /* 
        This function will later be turned into a service/interrupt call.
        stack layout:
        x0
        x2
        ...
        x28
        x29
        x30
        PSTATE
    */

    msr DAIFSet, #0x2

    str x1, [sp]

    mrs x1, SP_EL0
    // Save the context of the current process 
    sub     x1, x1, 16*17               // Make room for the process context
   
    // Save the proces general purpose registers

    stp     x2, x3, [x1, 16]
    stp     x4, x5, [x1, 16*2]
    stp     x6, x7, [x1, 16*3]
    stp     x8, x9, [x1, 16*4]
    stp     x10, x11, [x1, 16*5]
    stp     x12, x13, [x1, 16*6]
    stp     x14, x15, [x1, 16*7]
    stp     x16, x17, [x1, 16*8]
    stp     x18, x19, [x1, 16*9]
    stp     x20, x21, [x1, 16*10]
    stp     x22, x23, [x1, 16*11]
    stp     x24, x25, [x1, 16*12]
    stp     x26, x27, [x1, 16*13]
    stp     x28, x29, [x1, 16*14]
    str     x30, [x1, 16*15]

    mrs     x0, SPSR_EL1            // Save the process PSTATE
    str     x0, [x1, 16*15+8]

    mrs x0, ELR_EL1
    str x0, [x1, 16*16]

    // Enqueue the current process to the ready Q (call enqueue) 
    adr     x0, ReadyQ              // enqueue takes a pointer to the queue and 
    adr     x4, Running             //    a pointer to a PCB
    ldr     x4, [x4]                // put the first value in the PCB (the stack pointer) into x1 
    str     x1, [x4]                //    Then store the new top of stack that is now in x4 to the PCB 
    mov     x1, x4                  // Note: the first element in the pcb is the top of stack
    bl      enqueue                 // Put the current processes PCB into the ready Q

 
 go:
    // Dequeue the next process to run
    adr     x0, ReadyQ              // dequeue has one argument, the address of the ready Q
    bl      dequeue                 // call dequeue, x0 will have a ptr to the returned PCB
    adr     x1, Running             // We need to set the returned PCB as "running"
    str     x0, [x1]                // store the pointer to the PCB into the Running variable
    ldr     x1, [x0]                // x1 now has the value of the stack ptr (we cant ldr sp directly)
    
    ldr     x0, [x1, 16*15+8]   // Restore PSTATE
    msr     SPSR_EL1, x0

    ldr     x0, [x1, 16*16]   
    msr     ELR_EL1, x0

    mov x0, x1
    add x0, x0, 16*17
    msr SP_EL0, x0

    ldp     x2, x3, [x1, 16]
    ldp     x4, x5, [x1, 16*2]
    ldp     x6, x7, [x1, 16*3]
    ldp     x8, x9, [x1, 16*4]
    ldp     x10, x11, [x1, 16*5]
    ldp     x12, x13, [x1, 16*6]
    ldp     x14, x15, [x1, 16*7]
    ldp     x16, x17, [x1, 16*8]
    ldp     x18, x19, [x1, 16*9]
    ldp     x20, x21, [x1, 16*10]
    ldp     x22, x23, [x1, 16*11]
    ldp     x24, x25, [x1, 16*12]
    ldp     x26, x27, [x1, 16*13]
    ldp     x28, x29, [x1, 16*14]
    
    mrs x2, SP_EL0
    sub x2, x2, 16*17
    
    stp x0, x1, [x2]
    bl clear_timer  // ***************

    ldp x0, x1, [x2]
    
    ldr x2, [x1, 16]

    ldr x30, [x1, 16*15]

    msr DAIFClr, #0x2

    eret

setup_EVT:
    // set up the exception vector table
    adr     x0, vector_table 
    msr     VBAR_EL1, x0        // Set the vector base address
    ret

init_timer:
    stp     x29, x30, [sp, -16]!
    bl      clear_timer
    //route core 0 counter to core 0 irq
    ldr     x0, =0x40000040
    mov     x1, 0x08
    str     w1, [x0]
    // enable timer
    mov     x0, 1
    msr     CNTV_CTL_EL0, x0
    ldp     x29, x30, [sp], 16
    ret

clear_timer:
    // read count frequency
    mrs     x0, CNTFRQ_EL0
    mov     x1, 20
    udiv    x0, x0, x1
    // clear cntv interrupt and set next 1 sec timer.
    msr     CNTV_TVAL_EL0, x0
    ret

unsupported:
    b unsupported_c

vector_table:
 .balign 128
    b unsupported
.balign 128
    b dispatch
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b dispatch    // yes
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b dispatch
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b unsupported
.balign 128
    b dispatch
.balign 128
    b unsupported
.balign 128
    b unsupported