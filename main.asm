.include "indicator_output.s"

.macro scan_res
.text
	mv	t0, zero		# result
	li	t1, 1			# select row 1
	sb	t1, 0x12(a0) 	# apply voltage
	lb	t1, 0x14(a0)	# read
	or	t0, t0, t1		# add to result
	li	t1, 2			# select row 1
	sb	t1, 0x12(a0) 	# apply voltage
	lb	t1, 0x14(a0)	# read
	or	t0, t0, t1		# add to result	
	li	t1, 4			# select row 1
	sb	t1, 0x12(a0) 	# apply voltage
	lb	t1, 0x14(a0)	# read
	or	t0, t0, t1		# add to result
	li	t1, 8			# select row 1
	sb	t1, 0x12(a0) 	# apply voltage
	lb	t1, 0x14(a0)	# read
	or	t0, t0, t1		# add to result
	
	beqz	t0, ret_zero

	andi	t0, t0, 0xff	# only two last hex digits
	andi	t1, t0, 0xf0	# second last hex digit
	andi	t0, t0, 0xf		# last hex digit
	li	t2, 0x1
	mv	t3, zero
check:
	beq	t0, t2, found
	add	t2, t2, t2
	addi	t3, t3, 1
	b check
found:
	add	t0, t3, t3
	add t0, t0, t0
	
	li	t2, 0x10
	mv	t3, zero
check2:
	beq	t1, t2, found2
	add	t2, t2, t2
	addi	t3, t3, 1
	b check2
found2:
	add	t0, t0, t3
	b end
ret_zero:
	li	t0, -1
end:
	mv	a0, t0
.end_macro

.globl main
.text
main:
	lui	s0, 0xffff0		# MMIO base (higher address)
	li	s1, 300			# max number of repetitions
	li	s2, -1			# number
	li	s3,	0			# previous indicator (0 for left, 1 for right)
	loop:
		# read result from hex keyboard
		mv	a0, s0
		scan_res
		bltz	a0, sleep
		
		mv	s2, a0
		mv	a0, s2
		mv	a1, s0
		addi	a1, a1, 0x10
		add	a1, a1, s3
		addi	s3, s3, 1
		andi	s3, s3, 1
		display_hex_digit
		li	a0, -1
		mv	a1, s0
		addi	a1, a1, 0x10
		add	a1, a1, s3
		display_hex_digit
	sleep:
		li	a0, 1000
		li	a7, 32
		ecall
	end:
        addi	s1, s1, -1
        bgtz	s1	loop
	li	a7, 10
	ecall
