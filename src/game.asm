
.include "constants.asm"


.data
BoardArray: .space BOARD_SIZE # 1 byte per cell (data format in README)

.text

.globl InitializeGame
# Starts the board from the initial state
InitializeGame:

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $s0, BoardArray

    jal ResetCells

    # Loads first player
    li $a3, 0

    # Sets diagonal of 1-2-3 for first player
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal SetCell

    li $a0, 1
    li $a1, 1
    li $a2, 2
    jal SetCell

    li $a0, 2
    li $a1, 2
    li $a2, 3
    jal SetCell

    # Loads second player
    li $a3, 1

    # Sets diagonal of 1-2-3 for second player
    li $a0, 5
    li $a1, 5
    li $a2, 1
    jal SetCell

    li $a0, 4
    li $a1, 4
    li $a2, 2
    jal SetCell

    li $a0, 3
    li $a1, 3
    li $a2, 3
    jal SetCell

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra


# Resets all cells back to zero state
ResetCells:
    li $t0, 0

    ResetCellsLoop:
        add $t1, $s0, $t0 
        sb $zero, 0($t1)
        addi $t0, $t0, 1
        blt $t0, BOARD_SIZE, ResetCellsLoop

    jr $ra

.globl GetCell
# Gets the current value in cell at (x,y) and which player number it belongs to
# $a0 = x-coordinate
# $a1 = y-coordinate
# $v0 = value
# $v1 = player number (0-1)
GetCell:

    # Memory address = base + x + ly
    li $t0, BOARD_LENGTH
    mul $t1, $t0, $a1 # $t1 = ly 
    add $t1, $t1, $a0 # $t1 += x
    add $t2, $s0, $t1 # $t2 = base + (x + ly)

    # Gets byte with player and value data
    lbu $t3, 0($t2)

    andi $v0, $t3, 127 # 01111111 -> Removes first player bit from value
    srl $v1, $t3, 7

    jr $ra


.globl SetCell
# Sets the cell at (x,y) for a certain player number
# $a0 = x-coordinate
# $a1 = y-coordinate
# $a2 = value
# $a3 = player number (0-1)
SetCell:

    # Memory address = base + x + ly
    li $t0, BOARD_LENGTH
    mul $t1, $t0, $a1 # $t1 = ly 
    add $t1, $t1, $a0 # $t1 += x
    add $t2, $s0, $t1 # $t2 = base + (x + ly)

    sll $t3, $a3, 7
    add $t4, $t3, $a2
    sb $t4, 0($t2)

    jr $ra

