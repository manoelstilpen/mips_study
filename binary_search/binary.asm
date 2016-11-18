#Aluno: Manoel Victor Stilpen
#Key to search generated randomly

.data
enter: .asciiz "\n"
line: .asciiz "-"
encontrado: .asciiz "Chave Encontrada"
nao_encontrado: .asciiz "Chave Nao Encontrada"
msg1: .asciiz "Chave a ser pesquisada: "

quant: .word 50

.text

.globl main
main:
	move $s0, $gp	# initial point to save array
	lw $s1, quant	# saves how many numbers will be generated

generate_values:
	li $t0, 0		# for counter
	move $s2, $s0 	# copy the pointer to array in $s2

	for_generate:
		sb $t0, 0($s2)		# put the value at the position pointed by $s1
		addi $s2, $s2, 1	# increment by one the pointers
		addi $t0, $t0, 1	# i++
		bne $t0, $s1, for_generate	# if i < quant

	# Generating key...
	add $t1, $s1, 30
	li $v0, 42
	move $a1, $t1
	syscall
	move $s3, $a0
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, enter
	syscall

	# jal imprime

binaria:
	# $t0 -> key to be searched
	# $t1 -> left - esq
	# $t2 -> right - dir
	# $t3 -> middle

	move $s2, $s0	# load the array reference
	move $t0, $s3		# load the key to be searched
	li $t1, -1		# esq = -1
	move $t2, $s1	# dir = n

	while:
		sub $v1, $t2, 1		# v1 = dir-1
		bge $t1, $v1, end_while

		add $v1, $t1, $t2	# v1 = esq + dir
		li $v0, 2
		div $v1, $v0
		mflo $t3			# t3 = (esq + dir) / 2

		add $s2, $s0, $t3
		lb $t4, 0($s2)
		
		beq $t4, $t0, finded	# if vec[m] == key
		blt $t4, $t0, if_stat	# if vec[m] < key
		bgt $t4, $t0, else_stat	# if vec[m] > key

finded:
	li $v0, 4
	la $a0, encontrado
	syscall
	j exit

if_stat:
	move $t1, $t3
	j while

else_stat:
	move $t2, $t3
	j while

end_while:
	li $v0, 4
	la $a0, nao_encontrado
	syscall
	j exit

imprime:
	
	move $a1, $s0	# get the array reference
	li $t8, 0

	loop_show:
		lb $a0, 0($a1)	# load bytes

		li $v0, 1
		syscall				# syscall passando $v0 = 1

		addi $a1, $a1, 1 	# increment array reference
		addi $t8, $t8, 1 	# i++
		
		li $v0, 4	
		la $a0, line
		syscall		# syscall passando $v0 = 4 - imprime string
		
		bne $t8, $s1, loop_show	# caso a contagem atual seja igual ao tamanho do vetor, quit

		la $a0, enter
		syscall

	jr $ra

exit:
	li $v0, 10
	syscall