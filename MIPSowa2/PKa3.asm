
	.text

main:
	li	$v0, 13		# open file
	la	$a0, file
	move	$a1, $zero	# flags = 0 i.e. for reading
	move	$a2, $zero	# mode is ignored
	syscall			# teraz $v0 = fd (na chwilę)
	bltz	$v0, uciekaj	# nie udało się otworzyć pliku
	move	$s0, $v0	# $s0 = fd (na stałe!)
	
	move	$t0, $zero	# $t0 = lb niepustych linii
	move	$t1, $zero	# $t1 = 0 lub 1; 0 iff akt. linia pusta
	li	$t2, 0x20	# ASCII code for space
	li	$t3, 0xA	# ASCII code for line Feed
	
czytaj:
	li	$v0, 14		# read from file
	move	$a0, $s0	# $a0 = fd
	la	$a1, buffer
	li	$a2, 1		# read 1 byte
	syscall
	blez	$v0, koniec	# EOF lub error przy czytaniu
	lb	$t5, buffer	# $t5 = wczytany znak
	bne	$t5, $t3, sprdalej	# skocz jestli $t5 != LF
	beqz	$t1, aktualizuj
	addi	$t0, $t0, 1	# niepusta więc zwiększ licznik
aktualizuj:
	move	$t1, $zero	# zał. kolejna linia jest jak na razie pusta
	j	czytaj
sprdalej:
	beq	$t5, $t2, pustosc
	addi	$t1, $zero, 1 	# akt. linia nie jest pusta
pustosc:
	j	czytaj

koniec:
	li	$v0, 1
	move	$a0, $t0	# lb niepustych linii
	syscall
	li	$v0, 16		# close file
	move	$a0, $s0	# $a0 = fd
	syscall
uciekaj:
	li	$v0, 10
	syscall

##################################################

	.data
file:	.asciiz	"pliczek" # musi byc w katalogu z ktorego uruchomiony jest MARS
			  #  a niekoniecznie z tego, w ktorym jest kod zrodlowy! oO
buffer: .space 1
