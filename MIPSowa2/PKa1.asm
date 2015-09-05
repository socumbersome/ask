
	.text

main:
	li	$a0, 0x1F12345	# stan planszy
	li	$s0, 15		# lb tur
loop:	beqz	$s0, wyjdz
	jal	tura
	move	$a0, $v0
	jal	wypisz
	addi	$s0, $s0, -1
	j	loop
wyjdz:	
	li	$v0, 10
        syscall

############################################################################	
	
tura:		# zał. wszystkie komórki zmieniają stan jednocześnie (równolegle)
	move	$t9, $a0	# kopia stanu planszy
	li	$t8, 31		# upper bound wskaznika na planszy (lower to 0 w $zero)
	move	$t0, $t8	# $t0 to wskaznik (lecimy od tyłu)
	li	$t1, 1		# $t1 to maska odpowiadająca aktualnemu położeniu wskaźnika
kolejny:
	bltz	$t0, turaend
	move	$t2, $zero	# $t2 - lb żywych sąsiadów
	move	$t3, $t0	# pomocniczy wskaźnik
	move	$t4, $t1	# maska odp. pomocniczemu wskaźnikowi
	beqz	$t3, prawisas 	# obrabiamy lewych sasiadow lol
	addi	$t3, $t3, -1
	sll	$t4, $t4, 1
	and	$t5, $t9, $t4	# czy pole wskazywane przez $t3(4) jest zywe?
	beqz	$t5, drugilewy
	addi	$t2, $t2, 1	# w p.p. jeden wiecej zywy sasiad
drugilewy:
	beqz	$t3, prawisas	# DRY all the way ,,,,,,,,,,
	addi	$t3, $t3, -1
	sll	$t4, $t4, 1
	and	$t5, $t9, $t4	# czy pole wskazywane przez $t3(4) jest zywe?
	beqz	$t5, prawisas
	addi	$t2, $t2, 1	# w p.p. jeden wiecej zywy sasiad
prawisas:
	move	$t3, $t0	# przywracamy pomocniczy wskaźnik
	move	$t4, $t1	# maska odp. pomocniczemu wskaźnikowi
	bge	$t3, $t8, podsumuj 	# obrabiamy prawych sasiadow
	addi	$t3, $t3, 1
	srl	$t4, $t4, 1
	and	$t5, $t9, $t4	# czy pole wskazywane przez $t3(4) jest zywe?
	beqz	$t5, drugiprawy
	addi	$t2, $t2, 1	# w p.p. jeden wiecej zywy sasiad
drugiprawy:
	bge	$t3, $t8, podsumuj 	# scorching
	addi	$t3, $t3, 1
	srl	$t4, $t4, 1
	and	$t5, $t9, $t4	# czy pole wskazywane przez $t3(4) jest zywe?
	beqz	$t5, podsumuj
	addi	$t2, $t2, 1	# w p.p. jeden wiecej zywy sasiad
podsumuj:
		# w $t2 lb zywych sasiadów
	and	$t3, $t9, $t1	# czy aktualne pole jest zywe
	beqz	$t3, martwe
	move	$t4, $zero	# w $t4 trzymamy przypadki, w których trzeba zmienic stan akt pola
				# tj. 0, 1, 3
	bne	$t2, $t4, zywe1
	j	ustawzero
zywe1:
	li	$t4, 1
	bne	$t2, $t4, zywe3
	j	ustawzero
zywe3:
	li	$t4, 3
	bne	$t2, $t4, inkrement
	j	ustawzero
ustawzero:
	nor	$t5, $t1, $t1	# odwracamy maske akt. wskaznika
	and	$a0, $a0, $t5
	j	inkrement	
martwe:
	li	$t4, 2		# w $t4 przypadki dla zmian tj. 2 lub 3
	bne	$t2, $t4, martwe3
	j	ustawjeden
martwe3:
	li	$t4, 3
	bne	$t2, $t4, inkrement
	j	ustawjeden
ustawjeden:
	or	$a0, $a0, $t1
	j	inkrement
inkrement:
	addi	$t0, $t0, -1
	sll	$t1, $t1, 1
	j	kolejny
turaend:
	move	$v0, $a0
	jr	$ra

############################################################################

wypisz:
	move	$t9, $a0	# $t9 - komórki do wypisania
	li	$t0, 32
	li	$t1, 1
nxtch:	
	beqz	$t0, endwyp
	and	$t2, $t9, $t1
	lb	$t8, dot	# zał. komórka martwa
	beqz	$t2, drukuj
	lb	$t8, star	# a może jednak żywa
drukuj:	
	li	$v0, 11		# print character
	move	$a0, $t8
	syscall
	sll	$t1, $t1, 1
	addi	$t0, $t0, -1
	j	nxtch		
endwyp:	
	lb	$t8, nline
	li	$v0, 11
	move	$a0, $t8
	syscall
	move	$a0, $t9
	jr	$ra

############################################################################

	.data
dot:	.byte	'.'
star:	.byte	'*'
nline:	.byte	'\n'
