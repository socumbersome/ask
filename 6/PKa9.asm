# lista 6, zad 9

main:
	add	$v0, $zero, 5
	syscall			# wczytujemy inta
	move	$a0, $v0
	jal	fib
	move	$a0, $v0	# $a0 = fib(n)
	add	$v0, $zero, 1	
	syscall			# print
	li   	$v0, 10
        syscall


	# w $a0 argument wywolania
fib:
	bgt	$a0, 1, fib_rec		# dla n < 2 od razu zwroc 1
	li	$v0, 1
	jr 	$ra
fib_rec:
	addi 	$sp, $sp, -12		# miejsce dla 4 slow
	sw	$ra, 8($sp)
	
	move	$t0, $a0		# $t0 <-- n
	sw	$t0, 4($sp)		# zapisujemy n
	sub	$a0, $t0, 1		# $a0 = n - 1
	jal	fib
	move	$t1, $v0		# $t1 = fib(n-1)
	lw	$t0, 4($sp)		# przywroc n
	sw	$t1, 0($sp)		# zapisz fib(n-1)
	sub	$a0, $t0, 2		# $a0 = n - 2
	jal	fib
	move	$t2, $v0		# $t2 = fib(n-2)
	lw	$t1, 0($sp)		# przywroc fib(n-1)
	add	$v0, $t1, $t2		# $v0 = fib(n-1) + fib(n-2)
	
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
	