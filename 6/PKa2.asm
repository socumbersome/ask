# lista 6, zad 2
      .data
tab:  .word   1, -3, 5, 88, -15, 1 #0 : 6        # "array"
size: .word  6             # size of "array" 
      .text

main:
	la   $a0, tab        # przygotowujemy tablice
        la   $a1, size        
        lw   $a1, 0($a1)      
        move $s0, $a0 # w $s0 bezpiecznie przechowujemy tab
        move $s1, $a1 # w $s1 bezp. przech. n (rozmiar tab)
        jal qsort
        move $a0, $s0
        move $a1, $s1
        #la $t1, print
        #jalr $t1
        #jal print
        li   $v0, 10 # 10 - code for exit
        syscall

qsort: 	# zał. $a0 - adres tab, $a1 - n (rozmiar tab)
	li 	$t0, 2
	slt 	$t1, $a1, $t0		# $t1 = 1 iff $a1 (n) < $t0 (2)
	bnez 	$t1, end		# n < 2 wiec nie trzeba sortowac
	addi 	$sp, $sp, -24		# zrob 6 miejsc na stosie (ostatnie miejsce wykorzystamy pozniej)
	sw 	$ra, 16($sp)		# zachowaj adres powrotu
	sw 	$a0, 12($sp)		# zachowaj adres tab
	sw 	$a1, 8($sp)		# zachowaj rozmiar tab
	sw	$s0, 4($sp)		# $s0 i $s1 przydzadza sie do
	sw	$s1, 0($sp)	 	# pamietania wskaznikow l i r
	lw 	$t0, 0($a0)		# $t0 = p (pivot)
	move	$s0, $zero		# $s0 = l (= 0)
	move	$s1, $a1		# $s1 = r (teraz = n, a chcemy n-1)
	addi	$s1, $s1, -1		# i juz r = n-1
part:	sle	$t3, $s0, $s1		# $t3 = 1 iff l <= r
	beqz	$t3, recur		# if l > r to idz do recur
	sll	$t4, $s0, 2		# $t4 = 4 * l
	add	$t4, $a0, $t4 		# $t4 = tab + 4 * l
	lw	$t5, 0($t4) 		# $t5 = tab[l]
	bge	$t5, $t0, sprr		# idz do sprr if tab[l] >= p
	addi	$s0, $s0, 1		# w p.p.tab[l] < p, no to l++
	j part				# i partycjonujemy dalej
sprr:	
	sll	$t6, $s1, 2		# $t6 = 4 * r
	add	$t6, $a0, $t6 		# $t6 = tab + 4 * r
	lw	$t7, 0($t6) 		# $t7 = tab[r]
	ble	$t7, $t0, swap		# idz do swap if tab[r] <= p
	addi	$s1, $s1, -1		# w p.p. tab[r] > p, no to p--
	j part				# i partycjonujemy dalej
swap:
	sw	$t7, 0($t4)		# tab + 4*l <-- tab[r]
	sw	$t5, 0($t6)		# tab + 4*r <-- tab[l]
	addi	$s0, $s0, 1		# l++
	addi	$s1, $s1, -1		# r--
	j part
recur:	
	addi	$a1, $s1, 1		# $a1 = r + 1
	sw 	$t4, 20($sp)		# zapisujemy $t4 = tab + 4 * l
	jal	qsort			# qsort(tab, r+1)
	lw	$a0, 20($sp)		# odczytujemy tab + 4 * l
	lw	$t0, 8($sp)		# $t0 = n
	sub	$a1, $t0, $s0		# $t0 = n - l
	jal	qsort			# qsort(tab + 4 * l, n - l)
	lw 	$ra, 16($sp)		# odnów adres powrotu
	lw 	$a0, 12($sp)		# odnów adres tab
	lw 	$a1, 8($sp)		# odnów rozmiar tab
	lw	$s0, 4($sp)		# bla bla
	lw	$s1, 0($sp)
	addi	$sp, $sp, 24
end:
	jr $ra

      .data
space:.asciiz  " "          # space to insert between numbers
print:
      add  $t0, $zero, $a0  # starting address of array
      add  $t1, $zero, $a1  # initialize loop counter to array size
out:  lw   $a0, 0($t0)      # load fibonacci number for syscall
      li   $v0, 1           # specify Print Integer service
      syscall               # print fibonacci number
      la   $a0, space       # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # output string
      addi $t0, $t0, 4      # increment address
      addi $t1, $t1, -1     # decrement loop counter
      bgtz $t1, out         # repeat if not finished
      jr   $ra              # return
