#include "libos.h"
#include "pcb.h"
#include "queue.h"
#include "process.h"
#define TRUE 1
#define FALSE 0

int p1();
int p2();
int p3();
int p4();

int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);
int clear_scr(int start_row, int start_col, int width, int height);

void go();
void dispatch();

int main()
{
    int retval;
    // Ensure the screen is clear
    clear_scr(21, 49, 27, 79);
    // Initialize the ready queue
    init_rq();
    // Create the 4 processes
    retval = create_process(p1);
    if (retval != 0)
        return -1;

    retval = create_process(p2);
    if (retval != 0)
        return -1;

    retval = create_process(p3);
    if (retval != 0)
        return -1;

    retval = create_process(p4);
    if (retval != 0)
        return -1;
    // Jump to go() in process_asm.S
    go();

    return 0;

}

int clear_scr(int srow,int scol,int w,int h)
{
    // Iterate over the rows
    for (int row = srow; row <= w; row++)
    {
        // Iterate over the columns
        for (int col = scol; col <= h; col++)
        {
            // Replace the character at (row, col) with ' ' 
            putc_to(row, col, ' ');
        }
        
    }
    
    return 0;
}

/********************************************************************
    These are the process function that will be switched between.
    Each process prints "Process X: 0" in a box to the screen.
    Each process counts to 9, updating the print as it counts.
    Once reaching 9, the process jumps to dispatch() in process_asm.S

*********************************************************************/

int p1()
{
    char message[] = "Process 1: 0";
    int num = 0;

    box(9, 23, 11, 39);
    print_to(10, 25, message);

    while (TRUE)
    {
        message[11] = num + '0';
        print_to(10, 25, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

int p2()
{
    char message[] = "Process 2: 0";
    int num = 0;

    box(13, 23, 15, 39);
    print_to(14, 25, message);

    while (TRUE)
    {
  
        message[11] = num + '0';
        print_to(14, 25, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

int p3()
{
    char message[] = "Process 3: 0";
    int num = 0;

    box(9, 49, 11, 65);
    print_to(10, 51, message);

    while (TRUE)
    {
        
        message[11] = num + '0';
        print_to(10, 51, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

int p4()
{
    char message[] = "Process 4: 0";
    int num = 0;

    box(13, 49, 15, 65);
    print_to(14, 51, message);

    while (TRUE)
    {
        message[11] = num + '0';
        print_to(14, 51, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}