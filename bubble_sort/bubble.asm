#Aluno: Manoel Victor Stilpen
#Bubble Sort Ordenation Algorithm

.data
quant: .word 50
upper_bound: .word 100
enter: .asciiz "\n"
line: .asciiz "-"
msg1: .asciiz "ORDENADO:"

.text

.globl main
main:
	move $s0, $gp	# initial point to save array
	lw $s1, quant	# saves how many numbers will be generat

generate_values:
	li $t0, 0		# for counter
	move $s2, $s0 	# copy the pointer to array in $s2

	for_generate:
		li $v0, 42			# system call to generate random int
		lw $a1, upper_bound	# where you set the upper bound
		syscall				# your generated number will be in $a0

		sb $a0, 0($s2)		# put the value at the position pointed by $s2

		addi $s2, $s2, 1	# increment by one the pointers
		addi $t0, $t0, 1	# i++

		bne $t0, $s1, for_generate	# if i < quant

	jal imprime

bubble:
	# $s0 -> principal reference (dont change)
	# $s1 -> array size
	# $s2 -> last position
	# $s3 -> last position - 1
	# $t0 -> used to increment the array (i - outer for)
	# $t1 -> used to increment the array (j - inner for)

	move $t0, $s0
	move $t1, $s0
	add $s2, $s0, $s1
	sub $v0, $s1, 1
	add $s3, $s0, $v0

	outer:
		beq $t0, $s2, exit_bubble
		add $t0, $t0, 1

		move $t1, $s0
		inner:
			beq $t1, $s3, outer
			li $t4, 0

			addi $t4, $t1, 1
			lb $t3, 0($t4)
			lb $t2, 0($t1)

			addi $t1, $t1, 1
			blt $t2, $t3, inner

			sub $t5, $t1, 1
			lb $t3, 0($t4)
			lb $t2, 0($t5)
			sb $t3, 0($t5)
			sb $t2 0($t4)

			j inner

	exit_bubble:
		li $v0, 4
		la $a0, msg1
		syscall
		li $v0, 4
		la $a0, enter
		syscall
		jal imprime
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
	
	
