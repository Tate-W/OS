#include "libos.h"

int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);
int clear_scr(int start_row, int start_col, int width, int height);

int main()
{
    // Ensure the screen is clear
    clear_scr(21, 49, 27, 79);
    //Creates the box 
    box(21, 49, 27, 79);
    // Prints the string "Hello World" inside the box
    print_to(24, 59, "Hello World");

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