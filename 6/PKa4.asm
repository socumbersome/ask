# lista 6, zad 4
      .text

main:
	addi 	$v0, $zero, 0
	addi	$a0, $zero, 846120592 # = Ox326EC690
	# Ox326E = 12910, OxC690= -14704
	addi	$t0, $zero, 0xFFFF0000
	addi	$t1, $zero, 0xFFFF
	and	$s0, $a0, $t0
	srl	$s0, $s0, 16	# $s0 = a
	and	$s1, $a0, $t1	# $s1 = b
	add	$s2, $s0, $s1	# $s2 = a + b
	sub	$s3, $s0, $s1	# $s3 = a - b
	sll	$s3, $s3, 16
	or	$v0, $s2, $s3
	
        li	$v0, 10 # 10 - code for exit
        syscall
