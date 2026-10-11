
.text
.globl main

main:
    jal InitializeGame
    jal DrawBoard

    li $v0, 10
    syscall

