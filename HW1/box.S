    .extern term_txtheight
    .extern term_txtwidth
    .extern putc_to

.global     box
box:
 
    // standard entry: save link and stack frame registers
    //    load the stack frame with the pointer to current frame
    stp     x29, x30, [sp, -16]!
    
    // Save the arguments.  Called functions may overwrite x0-x3
    sub     sp, sp, 32
    stp     x0, x1, [sp]
    stp     x2, x3, [sp, 16]

    // sr in w0, sc in w1, er int w2, ec in w3
    // srow, scol, erow, ecol

    // Make sure the argument are valid

    bl      _box_check_box_
    cmp     w0, 0
    bne     _box_error_

 
    // first, draw the corners:
    // +        +
    // +        +
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_corners_

    // Now, draw the top and bottom:
    // +------+
    // +------+
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl _box_draw_top_bottom_

    // You figure out what goes here

    // draw left and right sides

    // You figure out what goes here

    mov     w0, 0
    b       _box_exit_
    // +------+
    // |      |
    // +------+
_box_check_box_:
    //erow <= ecol
    cmp x2, x0
    ble _box_error_
    //ecol <= scol
    cmp x3, x1
    ble _box_error_
    //erow >= max_rows
    bl term_txtheight
    
    cmp x2, x0
    bge _box_error_
    //ecol >= max_cols
    bl term_txtwidth
    cmp x3, x0
    bge _box_error_
    //else, return 0
    mov w0, 0
    ret


_box_draw_corners_:
    // Move + into x2 for putc_to
    mov x2, '+'

    // Print at start_row and start_col
    bl putc_to

    // Load x1 with end_col
    ldr x1, [sp, 24]

    // Print at start_row and end_col
    bl putc_to

    // Load x0 with end_row
    ldr x0, [sp, 16]

    // Load x1 with start_col
    ldr x1, [sp, 8]

    // Print at end_row and start_col
    bl putc_to

    // Load x1 with end_col
    ldr x1, [sp, 24]

    // Print at end_row and end_col
    bl putc_to

    ret

_box_draw_top_bottom_:
    
    mov x2, '-'
    // Load start_row and start_col from stack
    ldp x0, x1, [sp]
    // start_col + 1
    add x1, x1, 1
    // Load x3 with end_col
    ldr x3, [sp, 24]
    sub x3, x3, 1
loop:
    bl putc_to
    cmp x3, x1
    add x1, x1, 1
    bne loop
    ret

    // sr in w0, sc in w1, er int w2, ec in w3
    // srow, scol, erow, ecol    ret
_box_draw_right_left_:
    
    mov x2, '|'
    // Load start_row and start_col from stack
    ldp x0, x1, [sp]
    // start_col + 1
    add x1, x1, 1
    // Load x3 with end_col
    ldr x3, [sp, 24]
    sub x3, x3, 1
loop:
    bl putc_to
    cmp x3, x1
    add x1, x1, 1
    bne loop

    ret

_box_error_:
    mov     w0, 1

_box_exit_:
    add     sp, sp, 32   // pop save arg regs

    ldp     x29, x30, [sp], 16
    ret

