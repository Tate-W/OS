#include "libos.h"

int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);
// int clear_scr(int start_row, int start_col, int width, int height);

int main()
{

    box(21, 49, 27, 79);
    print_to(24, 59, "Hello World!");
    return 0;

}

