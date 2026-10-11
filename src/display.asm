
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

.globl DrawBoard
DrawBoard:

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $a0, 0
    li $a1, 0
    la $a2, Sprite1
    jal DrawSprite

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra





