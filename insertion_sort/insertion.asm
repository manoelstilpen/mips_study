#Aluno: Manoel Victor Stilpen
#Insertion Sort Algorithm 

.data
enter: .asciiz "\n"
line: .asciiz "-"
quant: .word 50
upper_bound: .word 100
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

		sb $a0, 0($s2)		# put the value at the position pointed by $s1

		addi $s2, $s2, 1	# increment by one the pointers

		addi $t0, $t0, 1	# i++

		bne $t0, $s1, for_generate	# if i < quant

	jal imprime

insertion:

	move $t2, $s0			# load array reference
	addi $t2, $t2, 1		# $t2 stores array + 1 reference	
	
	add $t0, $zero, 0		# i for counter
	add $t1, $t1, $zero	    # j while counter

	for_loop:
		addi $t0, $t0, 1
		beq $t0, $s1, end_for	# end for

		move $t1, $t0			# j = i
		sub $t1, $t1, 1

		add $t3, $s0, $t1
		add $t4, $t2, $t1

		while_loop:

			lb $t5, 0($t3)
			lb $t6, 0($t4)

			blt $t1, $zero, for_loop	# if j <= 0
			bgt $t6, $t5, for_loop		# array[j - 1] > array[j]

			jal while_stat

			sub $t1, $t1, 1

			add $t3, $s0, $t1
			add $t4, $t2, $t1

			j while_loop


	end_for:
		li $v0, 4
		la $a0, msg1
		syscall
		li $v0, 4
		la $a0, enter
		syscall
		jal imprime
		j exit

while_stat:

	lb $t5, 0($t4)
	lb $t6, 0($t3)

	sb $t5, 0($t3)
	sb $t6, 0($t4)

	jr $ra

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
