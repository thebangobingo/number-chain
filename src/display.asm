
.include "config.asm"

.data
Colors:
    .word 0x000000 # Black (0)
    .word 0xFFFFFF # White (1)

.text

# Converts a pixels (x,y) coordinate to memory address
# $a0 = x-coordinate
# $a1 = y-coordinate
# $v0 = memory address
GetPixelAddress:
    li $v0, 0x10040000 # The initial pixel address is stored in the heap

    # w = screen width
    # Memory address = base + 4(x + wy)
    li $t0, DISPLAY_WIDTH
    mul $t1, $t0, $a1 # $t1 = wy 
    add $t1, $t1, $a0 # $t1 = $t1 + x
    sll $t1, $t1, 2 # $t1 = 4 * $t1
    add $v0, $v0, $t1
    
    jr $ra


# Gets a color from its index in 'Colors'
# $a2 = color index
# $v1 = color hex value
GetColor:
    la $t0, Colors # Loads base address of color table
    sll $a2, $a2, 2
    add $t0, $t0, $a2
    lw $v1, 0($t0)

    jr $ra

.globl DrawPixel
# Draws a pixel on the screen at (x,y) with specified color
# $a0 = x-coordinate
# $a1 = y-coordinate
# $a2 = color index
DrawPixel:

    # Saves the $ra to stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal GetPixelAddress
    jal GetColor

    # Draws the pixel
    sw $v1, 0($v0)

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra
