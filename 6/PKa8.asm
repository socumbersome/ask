# lista 6, zad 8

    .data
buffer: .space 64
 
    .text
main:
	la 	$a0, buffer
	li 	$a1, 64
	li 	$v0, 8
	syscall
	
	move	$s0, $a0
	jal	toggle
	move	$a0, $s0
	li	$v0, 4
	syscall
	li	$v0, 10
        syscall
	

toggle:
	li	$t2, 0x20	# ASCII code for space
    	# moreover, 0x20=0010 0000 and lower and upper letters
    	# differ exactly on sixth bit 
    	li	$t3, 0xA	# newline character
loop:
	lb	$t1, 0($a0) 
	beqz 	$t1, exit
	beq 	$t1, $t2, skip
	beq	$t1, $t3, skip
	xor 	$t1, $t1, $t2
	sb 	$t1, 0($a0)
skip:
	addi 	$a0, $a0, 1
	j 	loop
exit:
	jr	$ra
