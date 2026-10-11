
.data

Sprite1: .byte 0,24,56,24,24,24,60,0
Sprite2: .byte 0,60,102,6,60,96,126,0
Sprite3: .byte 0,60,102,12,6,102,60,0
Sprite4: .byte 0,96,108,108,126,12,12,0
Sprite5: .byte 0,126,64,124,6,102,60,0
Sprite6: .byte 0,60,96,124,102,102,60,0
Sprite7: .byte 0,126,12,12,24,24,24,0
Sprite8: .byte 0,60,102,60,102,102,60,0
Sprite9: .byte 0,60,102,102,62,6,60,0

.text

.globl DrawBoardTest
DrawBoardTest:

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $a0, 0
    li $a1, 0
    la $a2, Sprite1
    jal DrawSprite

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

.globl DrawBoard
DrawBoard:

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Border Insets
    li $a0, 0
    li $a1, 0
    li $a2, 64
    li $a3, 2
    jal DrawSquare

    li $a0, 1
    li $a1, 1
    li $a2, 62
    li $a3, 3
    jal DrawSquare

    li $a0, 2
    li $a1, 2
    li $a2, 60
    li $a3, 2
    jal DrawSquare

    # Cell Drawing

    # Set y
    li $t0, -1
    CellYLoop:
        addi $t0, $t0, 1
        beq $t0, 6, DrawBoardReturn

        # Set x
        li $t1, -1

    CellXLoop:
        addi $t1, $t1, 1
        beq $t1, 6, CellYLoop

        li $t2, 10
        mult $t2, $t1
        mflo $t2

        li $t3, 10
        mult $t3, $t0
        mflo $t3

        addi $a0, $t2, 3
        addi $a1, $t3, 3

        addi $sp, $sp, -16
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $a0, 8($sp)
        sw $a1, 12($sp)

        li $a2, 8
        li $a3, 4
        jal DrawSquare

        lw $t0, 0($sp)
        lw $t1, 4($sp)

        move $a0, $t1
        move $a1, $t0
        jal GetCell

        la $t2, Sprite1

        beq $v0, $zero, CellXLoopJump

        # Times value by 8 (bytes per sprite)
        sll $t3, $v0, 3
        addi $t3, $t3, -8
        add $a2, $t2, $t3

        lw $a0, 8($sp)
        lw $a1, 12($sp)

        # Get team color
        addi $a3, $v1, 5

        jal DrawSprite

    CellXLoopJump:
        lw $t0, 0($sp)
        lw $t1, 4($sp)
        addi $sp, $sp, 16
        j CellXLoop


    DrawBoardReturn:
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra


    





