
.text
.globl main

main:
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal DrawPixel

    li $v0, 10
    syscall

