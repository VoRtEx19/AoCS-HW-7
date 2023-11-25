#===============================================================================
# Subprogram for displaying hexadecimal digit on the number indicator
#===============================================================================
.data
numbers:
	.byte
		0x3f,	# number 0
		0x06,	# number 1
		0x5b,	# number 2
		0x4f,	# number 3
		0x66,	# number 4
		0x6d,	# number 5
		0x7d,	# number 6
		0x07,	# number 7
		0x7f,	# number 8
		0x6f,	# number 9
		0x77,	# number a
		0x7c,	# number b
		0x39,	# number c
		0x5e,	# number d
		0x79,	# number e
		0x71	# number f
	.align	2

#-------------------------------------------------------------------------------
# display_hex_digit:
# macro that displays given hexadecimal digit on the Digital Lab Sim
# arguments:
# - a0: hexadecimal number to be displayed
# - a1:	address of the indicator (left or right)
# result: hexadecimal digit in the given register
# if hexadecimal number is not a digit, displays the lowest 4 radices with a dot
.macro	display_hex_digit
.text
main:
	bgez	a0, normal_display
	mv	a0, zero
	j	display
normal_display:	
	li	a2, 0x10				# 0x10 = 16 - upper bound
	bltu	a0, a2, skip_mod	# compare a0 with 16 to see if it is already a digit
	
	andi	a0, a0, 0xf			# a0 %= 16
	li	a3, 1					# set flag that the number had exceeded the digit bound
skip_mod:
	la	a2, numbers				# array numbers
	add	a2, a2, a0				# setting offset
	lb	a0, (a2)				# loading code for number
	beqz	a3, display		# if there was no overflow, skip

	addi	a0, a0, 0x80		# add bit for dot
display:
	sb	a0, (a1)				# display number
	
.end_macro
