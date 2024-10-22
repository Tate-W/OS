#include "libos.h"
#define TRUE 1
#define FALSE 0

void p1();
void p2();
void p3();
void p4();

int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);
int clear_scr(int start_row, int start_col, int width, int height);


int main()
{
    // Ensure the screen is clear
    clear_scr(21, 49, 27, 79);



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

void p1()
{
    char message[] = "Process 1: 0";
    int num;

    box(9, 23, 11, 39);
    print_to(10, 25, message);

    num = 0;

    while (TRUE)
    {
        num = num + '0';
        message[11] = num;
        print_to(10, 25, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

void p2()
{
    char message[] = "Process 2: 0";
    int num;

    box(13, 23, 15, 39);
    print_to(14, 25, message);

    num = 0;

    while (TRUE)
    {
        num = num + '0';
        message[11] = num;
        print_to(14, 25, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

void p3()
{
    char message[] = "Process 3: 0";
    int num;

    box(9, 49, 11, 65);
    print_to(10, 51, message);

    num = 0;

    while (TRUE)
    {
        num = num + '0';
        message[11] = num;
        print_to(10, 51, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}

void p4()
{
    char message[] = "Process 4: 0";
    int num;

    box(13, 49, 15, 65);
    print_to(14, 51, message);

    num = 0;

    while (TRUE)
    {
        num = num + '0';
        message[11] = num;
        print_to(14, 51, message);
        num++;

        if (num > 9)
        {
            num = 0;
            dispatch();
        }
    }
}