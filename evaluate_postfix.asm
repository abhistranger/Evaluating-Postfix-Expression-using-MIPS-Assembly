.data
    postfix: .space 100000
    result: .word 0
    error_mess: .asciiz "Error: Incorrect Input\n"

.globl main

.text

main:
    li $v0, 8
    la $a0, postfix
    la $a1, 100000
    syscall

    li $s0, 0

loop:
    la $s1, postfix
    
    li $s2, '+'
    li $s3, '-'
    li $s4, '*'
    li $s5, '\n'

    add $s1, $s1, $s0
    lb $t1, 0($s1)

    add $s0, $s0, 1
    beq $t1, $s5, print

    beq $t1, $s2, addoperate
    beq $t1, $s3, suboperate
    beq $t1, $s4, muloperate

    blt $t1, 48, print_error
    bgt $t1, 57, print_error
    addi $t1, $t1, -48
    subu $sp, $sp, 4
    sw $t1, ($sp)
    j loop

addoperate:
    lw $t2, ($sp)
    lw $t3, 4($sp)
    addu $sp, $sp, 8
    add $t4, $t2, $t3
    j push_op
    
suboperate:
    lw $t2, ($sp)
    lw $t3, 4($sp)
    addu $sp, $sp, 8
    sub $t4, $t3, $t2
    j push_op

muloperate:
    lw $t2, ($sp)
    lw $t3, 4($sp)
    addu $sp, $sp, 8
    mul $t4, $t2, $t3
    j push_op

push_op:
    subu $sp, $sp, 4
    sw $t4, ($sp)
    j loop


print:
    lw $t5, ($sp)
    addu $sp, $sp, 4
    sw $t5, result 
#    lw $t6, ($sp)
#    addu $sp, $sp, 4
#    bge $t6, 0, check 
    li $v0, 1
    lw $a0, result  
    syscall             
    li $v0, 10
    syscall

#check:
#    blt $t6, 900000, print_error

print_error:
    li $v0, 4
    la $a0, error_mess  
    syscall             
    li $v0, 10     #call to end the program
    syscall