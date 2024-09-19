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

    // Draw the left and right:
    // +------+
    // |      |
    // +------+

    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl _box_draw_right_left_


    mov     w0, 0
    b       _box_exit_
    // +------+
    // |      |
    // +------+
_box_check_box_:
    add sp, sp, 32
    str x30, [sp]

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
    
    ldr x30, [sp]
    sub sp, sp, 32
    ret


_box_draw_corners_:
    str x30, [sp, 32]
    // Move + into x2 for putc_to
    mov x2, '+'

    // Print at start_row and start_col
    ldp x0, x1, [sp]
    bl putc_to

    mov x2, '+'
    // Load x1 with end_col
    ldr x0, [sp]
    ldr x1, [sp, 24]

    // Print at start_row and end_col
    bl putc_to

    // Load x0 with end_row
    ldr x0, [sp, 16]

    // Load x1 with start_col
    ldr x1, [sp, 8]
    mov x2, '+'

    // Print at end_row and start_col
    bl putc_to

    // Load x1 with end_col
    ldr x0, [sp, 16]
    ldr x1, [sp, 24]
    mov x2, '+'

    // Print at end_row and end_col
    bl putc_to
    
    ldr x30, [sp, 32]
    ret

_box_draw_top_bottom_:
    
    str x30, [sp, 32]
    // Load start_row and start_col from stack
    // Redundant loading but good for posterity, included in each draw
    ldp x0, x1, [sp]
    // start_col + 1
    add x1, x1, 1
    
    // Load x3 with end_col
    ldr x3, [sp, 24]
    sub x3, x3, 1
    mov x4, x1
top:
    mov x2, '-'
    bl putc_to
    mov x1, x4
    ldr x0, [sp]
    cmp x3, x1
    add x1, x1, 1
    mov x4, x1
    bne top

    // Load end_row into x0
    ldr x0, [sp, 16]
    // Load start_col into x1
    ldr x1, [sp, 8]
    add x1, x1, 1
    //Load x3 with end_col
    ldr x3, [sp, 24]
    sub x3, x3, 1
    mov x4, x1
bot:
    mov x2, '-'
    bl putc_to
    mov x1, x4
    ldr x0, [sp, 16]
    cmp x3, x1
    add x1, x1, 1
    mov x4, x1
    bne bot

    ldr x30, [sp, 32]
    mov x4, 0
    ret
    
    // sr in x0, sc in x1, er int x2, ec in x3
    // srow, scol, erow, ecol    ret
_box_draw_right_left_:
    // Load start_row and start_col from stack
    ldp x0, x1, [sp]
    // start_row + 1
    add x0, x0, 1
    // Load x3 with end_row
    ldr x3, [sp, 16]
    sub x3, x3, 1
    mov x4, x0
left:
    mov x2, '|'
    bl putc_to
    mov x0, x4
    ldr x1, [sp, 8]
    cmp x3, x0
    add x0, x0, 1
    mov x4, x0
    bne left

    // Load start_row and end_col from stack
    ldr x0, [sp]
    ldr x1, [sp, 24]
    // start_row + 1
    add x0, x0, 1
    // Load x3 with end_row
    ldr x3, [sp, 16]
    sub x3, x3, 1
    mov x4, x0
right:
    mov x2, '|'
    bl putc_to
    mov x0, x4
    ldr x1, [sp, 24]
    cmp x3, x0
    add x0, x0, 1
    mov x4, x0
    bne right

_box_error_:
    mov     w0, 1

_box_exit_:
    add     sp, sp, 32   // pop save arg regs

    ldp     x29, x30, [sp], 16
    ret

