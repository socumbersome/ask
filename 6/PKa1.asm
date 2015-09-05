# lista 6, zad 1
      .data
tab:  .word   0 : 4        # "array" of 4 words to contain values
size: .word  4             # size of "array" 
      .text
sumimax:
	la   $a0, tab        # przygotowujemy tablice
        la   $a1, size        
        lw   $a1, 0($a1)      
        li   $t0, 1           
        sw   $t0, 0($a0)
        li   $t0, -3
        sw   $t0, 4($a0)
        li   $t0, 5
        sw   $t0, 8($a0)
        li   $t0, 88
        sw   $t0, 12($a0)
	# zał. tab[] ma adres w $a0, a jej rozmiar n to $a1
	# wynik: w $v0 suma el., a w $v1 max
	move $t0, $zero # i = $t0
	move $t1, $zero # sum = 0
	lw   $t2, 0($a0) # max = tab[0]
petla:	slt  $t3, $t0, $a1 # $t3 = 0 iff i >= n
	beq  $t3, $zero, koniec
	sll  $t4, $t0, 2 # $t4 = 4 * i
	add  $t4, $a0, $t4 # $t4 = tab + 4 * i
	lw   $t5, 0($t4) # $t5 = tab[i]
	add  $t1, $t5, $t1 # sum += tab[i]
	slt  $t4, $t2, $t5 # $t4 = 1 iff max < tab[i]
	beq  $t4, $zero, nomax
	move $t2, $t5
nomax:  addi $t0, $t0, 1 # i++
	j    petla
koniec: move $v0, $t1
	move $v1, $t2