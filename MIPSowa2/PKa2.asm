
	.text

main:
	li	$v0, 7		# read double
	syscall			# czytamy a
	mov.d	$f2, $f0	# $f2 = a
	li	$v0, 7
	syscall
	mov.d	$f4, $f0	# $f4 = eps
		# zał x_n = $f6, x_n+1 = $f8
	li	$t0, 2
	mtc1.d	$t0, $f12	# $f12 = 2
	cvt.d.w	$f12, $f12	# musimy przekonwertowac
	mov.d	$f6, $f2	# x_n = a na poczatku
licz:		# teraz liczymy x_n+1
	div.d	$f14, $f2, $f6		# $f14 = a / x_n
	add.d	$f14, $f14, $f6		# $f14 = x_n + a / x_n
	div.d	$f8, $f14, $f12		# x_n+1 policzone
	
	c.le.d	$f6, $f8	# x_n <= x_n+1 => flag = true 
	bc1t	dalszywiekszy
	sub.d	$f14, $f6, $f8	# $f14 = |x_n - x_n+1|
	j spr
dalszywiekszy:
	sub.d	$f14, $f8, $f6
spr:
	c.lt.d	$f14, $f4	# czy |x_n - x_n+1| < eps ?
	bc1t	koniec
	mov.d	$f6, $f8	# x_n <- x_n+1
	j	licz
	
koniec:
	li	$v0, 3		# print double
	mov.d	$f12, $f8
	syscall
	li	$v0, 10
        syscall
