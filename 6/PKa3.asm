# lista 6, zad 3
      .text

main:
	addi $s0, $zero, 57
	move $s1, $zero
for:    
	beq  $s0, $zero, endfor
	subi $t0, $s0, 1
	and  $s0, $s0, $t0
	addi $s1, $s1, 1
	j for
endfor:
        li   $v0, 10 # 10 - code for exit
        syscall
