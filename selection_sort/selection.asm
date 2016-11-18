# Aluno: Manoel Victor Stilpen
# Selection Sort Algorithm

# Vetor de entrada de tamanho 50 e gerado aleatoriamente

.data
enter: .asciiz "\n"
line: .asciiz "-"
quant: .word 5
msg1: .asciiz "ORDENADO:"

.text

.globl main
main:
	move $s0, $gp	# initial point to save array
	lw $s1, quant	# saves how many numbers will be generated

generate_values:
	li $t0, 0		# for counter
	move $s2, $s0 	# copy the pointer to array in $s2

	for_generate:
		li $v0, 42			# system call to generate random int
		li $a1, 100 		# where you set the upper bound
		syscall				# your generated number will be in $a0

		sb $a0, 0($s2)		# put the value at the position pointed by $s1

		addi $s2, $s2, 1	# increment by one the pointers

		addi $t0, $t0, 1	# i++

		bne $t0, $s1, for_generate	# if i < quant

	jal imprime

selection:
	# $s1 -> quant
	# $s2 -> array reference
	# $s3 -> last address
	# $s4 -> last address - 1 

	move $s2, $s0		# load the array reference
	add $s3, $s2, $s1	# $s3 contains the last array address

	sub $v0, $s1, 1		# $v0 = quant - 1
	add $s4, $s2, $v0	# contains the last address - 1

	move $t0, $s2		# min = vetor[0]

	outer:
		beq $s2, $s3, end_for

		move $t0, $s2	# min = &(vetor[i])
		move $t1, $s2	# $t1 contains local reference to array
		add $s2, $s2, 1
		add $t2, $t0, 1		# j = min + 1

		inner:
			
			beq $t2, $s3, end_inner

			lb $t4, 0($t2)		# vetor[j]
			lb $t5, 0($t0)		# vetor[min]

			blt $t4, $t5, if_stat	# vetor[j] < vetor[min]
			after_if:
				add $t2, $t2, 1		# j = min + 1
				j inner

	end_inner:
		lb $t6, 0($t1)
		lb $t7, 0($t0)

		sb $t6, 0($t0)
		sb $t7, 0($t1)
		
		j outer


	end_for:
		li $v0, 4
		la $a0, msg1
		syscall
		li $v0, 4
		la $a0, enter
		syscall
		jal imprime
		j exit

	if_stat:
		move $t0, $t2
		j after_if

imprime:
	
	move $a1, $s0	# get the array reference
	li $t8, 0

	loop_imprime:
		lb $a0, 0($a1)	# load bytes

		li $v0, 1
		syscall				# syscall passando $v0 = 1

		addi $a1, $a1, 1 	# increment array reference
		addi $t8, $t8, 1 	# i++
		
		li $v0, 4	
		la $a0, line
		syscall				# syscall passando $v0 = 4 - imprime string
		
		bne $t8, $s1, loop_imprime	# caso a contagem atual seja igual ao tamanho do vetor, quit

		la $a0, enter
		syscall

	jr $ra

exit:
	li $v0, 10
	syscall
