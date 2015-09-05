# lista 6, zad 7

	.data
aux:	.byte 0x01, 0x02 # składa do kupy podane bajty i wrzuca do aux
	.text
main:
    lw $a0, aux($0)
    # jak widzimy koncowke 0201 w $a0 to little-endian
    li	$v0, 10
    syscall
