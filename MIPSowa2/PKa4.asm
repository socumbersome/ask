# ustawiania Bitmap Display:
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 (static data)
.data
frameBuffer:	.space 0x80000 # = 2^19
	# pixeli jest 256*512=2^17, ale 1px=4B, więc w sumie potrzeba 2^19B

.text


main:
	li	$s0, 15		# lb prostokatow
	li	$s1, 512	# upper bound szerokosci
	li	$s2, 256	# upper bound wysokosci
loop:	beqz	$s0, wyjdz
	move	$a1, $s1	# upper bound na xmin
	li	$v0, 42		# random int range
	syscall
	move	$t0, $a0	# $t0 xmin
	sub	$a1, $s1, $t0	# upper bound na width
	li	$v0, 42
	syscall
	move	$t1, $a0	# $t1 to width
	move	$a1, $s2
	li	$v0, 42
	syscall
	move	$t2, $a0	# $t2 to ymin
	sub	$a1, $s2, $t2
	li	$v0, 42
	syscall
	move	$t3, $a0	# $t3 to height
	li	$v0, 41		# random int
	syscall
	move	$s7, $a0	# $s7 to color
	
	move	$a0, $t0
	move	$a1, $t1
	move	$a2, $t2
	move	$a3, $t3
	jal rectangle
	
	li	$v0, 32		# sleep
	li	$a0, 50
	syscall
	addi	$s0, $s0, -1
	j	loop
wyjdz:	
	li	$v0, 10
        syscall


rectangle:
# $a0 - xmin
# $a1 - width
# $a2 - ymin
# $a3 - height
# $s7 - kolor do zmieszania
	beq	$a1, $zero, rectangleReturn
	beq	$a3, $zero, rectangleReturn
	la	$t1, frameBuffer
	add	$a1, $a1, $a0 # teraz $a1 to prawa krawedz prostokata
	add	$a3, $a3, $a2 # $a3 to dolna krawedz
	sll	$a0, $a0, 2 # skalowanie po x - 4B na pixel
	sll	$a1, $a1, 2
	sll	$a2, $a2, 11 # skalowanie po y - 512*4=2^11B na rzad
	sll	$a3, $a3, 11
	addu	$t2, $a2, $t1 # transformujemy y z globalnego ukladu na rel. do framebuffera
	addu	$a3, $a3, $t1
	addu	$a2, $t2, $a0 
	addu	$a3, $a3, $a0
	addu	$t2, $t2, $a1 # ostatni adres dla pierwszego rzedu prostokata
	li	$t4, 0x800 # lb bajtow na 1 rzad tj. 2^11

rectangleYloop:
	move	$t3, $a2 # w t3 adres aktualnego pixela

rectangleXloop:
	lw	$s6, ($t3) 	# ladujemy kolor do $s6
# w $t5,$t6,$t7 trzymamy srednie wartosci R, G i B
# w $s3, $s4 skladowa kolejno aktualnego i nowego koloru
# R
	srl	$s3, $s6, 16
	srl	$s4, $s7, 16
	add	$t5, $s3, $s4
	srl	$t5, $t5, 1 	# i mamy srednia R
	sll	$t5, $t5, 16	# ustaw na dobrej pozycji w slowie
# G
	sll	$s3, $s6, 8
	srl	$s3, $s3, 16
	sll	$s4, $s7, 8
	srl	$s4, $s4, 16
	add	$t6, $s3, $s4
	srl	$t6, $t6, 1 	
	sll	$t6, $t6, 8	# ustaw na dobrej pozycji w slowie
# B
	sll	$s3, $s6, 16
	srl	$s3, $s3, 16
	sll	$s4, $s7, 16
	srl	$s4, $s4, 16
	add	$t7, $s3, $s4
	srl	$t7, $t7, 1 	
				# laczymy skladowe kolorow
	or	$s5, $t5, $t6
	or	$s5, $s5, $t7
	sw 	$s5, ($t3)
	
				# i do kolejnego pixela
	addiu	$t3, $t3, 4
	bne	$t3, $t2, rectangleXloop # rysuj dalej jesli nie poza prawa krawedzia

	addu	$a2, $a2, $t4 # w p.p. zejdz rzad nizej i od lewej
	addu	$t2, $t2, $t4 # update adresu max z prawej
	bne	$a2, $a3, rectangleYloop # rysuj dalej jesli nie poza dolna krawedzia

rectangleReturn:
	jr	$ra
