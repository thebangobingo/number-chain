
.include "constants.asm"

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


.globl DrawSprite
# Draws a sprite from a given array of 8 bytes (8x8 px)
# (x,y) position represents the top-left corner
# $a0 = x-coordinate
# $a1 = y-coordinate
# $a2 = array address
DrawSprite:

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # y counter
    li $t0, -1

    DrawSpriteYLoop:
        # Increment y counter
        addi $t0, $t0, 1

        beq $t0, 8, ReturnDrawSprite

        # x counter
        li $t1, -1

    DrawSpriteXLoop:
        # Increment x counter
        addi $t1, $t1, 1

        beq $t1, 8, DrawSpriteYLoop

        # Gets the correct row of data for the sprite (base address + y)
        add $t2, $a2, $t0
        lbu $t2, 0($t2)
        # Gets the correct pixel value for that row
        li $t3, 7
        subu $t3, $t3, $t1
        srlv $t2, $t2, $t3
        andi $t2, $t2, 1

        # Continue if there is no bit in this position
        beq $t2, 0, DrawSpriteXLoop

        # Save registers in stack
        addi $sp, $sp, -20
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $a0, 8($sp)
        sw $a1, 12($sp)
        sw $a2, 16($sp)

        # Get actual (x,y) coordinate
        add $a0, $a0, $t1
        add $a1, $a1, $t0
        li $a2, 1
        jal DrawPixel

        lw $t0, 0($sp)
        lw $t1, 4($sp)
        lw $a0, 8($sp)
        lw $a1, 12($sp)
        lw $a2, 16($sp)
        addi $sp, $sp, 20

        j DrawSpriteXLoop

    ReturnDrawSprite:
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    

