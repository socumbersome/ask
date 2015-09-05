# lista 6, zad 5
      .text

main:
    srl  $v0, $a0, 23
    andi $v0, $v0, 0xFF # w $v0 mamy teraz sam wykladnik
    add  $v0, $v0, $a1  # dodajemy do niego $a1 (=k)
    slti $t0, $v0, 0x100
    bnez $t0, nooverflow
    nop       #overflow!
    
    li	$v0, 10
    syscall
 
nooverflow:
    sll  $v0, $v0, 23
    andi $t0, $a0, 0x807FFFFF
    or   $v0, $v0, $t0
    
    li	$v0, 10
    syscall
