#  CS 218, MIPS Assignment #1

#  Example program to find the:
#	min, max, and average of a list of numbers.
#	min, max, and average of the positive values in the list.
#	min, max, and average of the values that are evenly
#		divisible by 5.

###########################################################
#  data segment

.data

array:	.word	  1120,  193,  982, -339,  564, -631,  421, -148,  936, -1157
	.word	 -1117,  171, -697,  161, -147,  137, -327,  151, -147,  1354
	.word	   432, -551,  176, -487,  490, -810,  111, -523,  532, -1445
	.word	  -163,  745, -571,  529, -218,  219, -122,  934, -370,  1121
	.word	  1315, -145,  313, -174,  118, -259,  672, -126,  230, -1135
	.word	  -199,  104, -106,  107, -124,  625, -126,  229, -248,  1992
	.word	  1132, -133,  936,  136,  338, -941,  843, -645,  447, -1449
	.word	 -1171,  271, -477, -228,  178,  184, -586,  186, -388,  1188
	.word	   950, -852,  754,  256, -658, -760,  161, -562,  263, -1764
	.word	 -1199,  213, -124, -366,  740,  356, -375,  387, -115,  1426
len:	.word	  100

min:	.word	0
max:	.word	0
ave:	.word	0

posMin:	.word	0
posMax:	.word	0
posAve:	.word	0

fiveMin:	.word	0
fiveMax:	.word	0
fiveAve:	.word	0

hdr:	.ascii	"MIPS Assignment #1\n\n"	
	.ascii	"Program to find: \n"
	.ascii	"   * min, max, and average for a list of numbers.\n"
	.ascii	"   * min, max, and average of the positive values.\n"
	.ascii	"   * min, max, and average of the values that are"
	.asciiz	" evenly divisible by 5.\n\n"

new_ln:	.asciiz	"\n"

a0_st:	.asciiz	"\n    List min = "
a1_st:	.asciiz	"\n    List max = "
a2_st:	.asciiz	"\n    List ave = "

a3_st:	.asciiz	"\n\n    Positive min = "
a4_st:	.asciiz	"\n    Positive max = "
a5_st:	.asciiz	"\n    Positive ave = "

a6_st:	.asciiz	"\n\n    Divisible by 5 min = "
a7_st:	.asciiz	"\n    Divisible by 5 max = "
a8_st:	.asciiz	"\n    Divisible by 5 ave = "


###########################################################
#  text/code segment

.text
.globl	chk1
.globl	main
.ent	main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall

# *******************************************************************

# Find min and max of array :)

	la	$t0, array				# set $t0 addr of array
	lw 	$t1, len				# set $t1 to length

	li	$t2, 0					# posSum
	li 	$t3, 0					# divBy5Sum
	li	$t4, 0					# arraySum

	li	$s4, 0					# posSum - counter
	li	$s6, 0					# div by 5 - counter

	lw	$s2, ($t0)				# $s2 = min (array[0])
	lw	$s3, ($t0)				# $s3 = max (array[0])

arrayLoop:
	lw	$t5, ($t0)				# get array[n]
	add	$t4, $t4, $t5				# add result into sum

	div	$s6, $t5, 5
	bne	$s6, 1, skipFive

skipFive:
	blez	$t5, skipPos
	addu	$t2, $t2, $t5				# add positive numbers into posSum
	addu	$s4, $s4, 1				# pos counter
	
	bge	$t5, $t3, skipPos
	move	$t3, $t5
	sw	$t3, posMin
		
skipPos:
	bge	$t5, $s2, skipMin			# if array[n] > min, skip setting max
	move	$s2, $t5				# set new min
	sw	$s2, min				# update min

skipMin:
	ble	$t5, $s3, skipMax			# if array[n] < max, skip setting max	
	move	$s3, $t5				# set new max
	sw	$s3, max				# update max
	sw	$s3, posMax				# max == posMax

skipMax:
	sub	$t1, $t1, 1				# decrement length
	addu	$t0, $t0, 4				# increment address by 4 (word size)
	bnez	$t1, arrayLoop

	div	$s5, $s4, 100				# Array Avg
	sw	$s5, ave

	div	$s5, $t2, $t4				# Positive Avg
	sw	$s5, posAve


# *******************************************************************
#  Display results.

#  Print list min message followed by result.

	la	$a0, a0_st
	li	$v0, 4
	syscall						# print "List min = "

	lw		$a0, min
	li		$v0, 1
	syscall						# print min

# -----
#  Print max message followed by result.

	la		$a0, a1_st
	li		$v0, 4
	syscall						# print "List max = "

	lw		$a0, max
	li		$v0, 1
	syscall						# print max

# -----
#  Print average message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall						# print "List ave = "

	lw		$a0, ave
	li		$v0, 1
	syscall						# print average

# -----
#  Display results - positive numbers.

#  Print min message followed by result.

	la		$a0, a3_st
	li		$v0, 4
	syscall						# print "Positive min = "

	lw		$a0, posMin
	li		$v0, 1
	syscall						# print pos min

# -----
#  Print max message followed by result.

	la		$a0, a4_st
	li		$v0, 4
	syscall						# print "Positive max = "

	lw		$a0, posMax
	li	$v0, 1
	syscall						# print pos max

# -----
#  Print average message followed by result.

	la		$a0, a5_st
	li		$v0, 4
	syscall						# print "Psoitive ave = "

	lw		$a0, posAve
	li		$v0, 1
	syscall						# print pos average

	la	$a0, new_ln				# print a newline
	li	$v0, 4
	syscall

# -----
#  Display results - divisible by 5 numbers.

#  Print min message followed by result.

	la		$a0, a6_st
	li		$v0, 4
	syscall						# print "Divisible by 5 min = "

	lw		$a0, fiveMin
	li		$v0, 1
	syscall						# print min

# -----
#  Print max message followed by result.

	la		$a0, a7_st
	li		$v0, 4
	syscall						# print "Divisible by 5 max = "

	lw		$a0, fiveMax
	li	$v0, 1
	syscall						# print max

# -----
#  Print average message followed by result.

	la		$a0, a8_st
	li		$v0, 4
	syscall						# print "Divisible by 5 ave = "

	lw		$a0, fiveAve
	li		$v0, 1
	syscall						# print average

	la	$a0, new_ln				# print a newline
	li	$v0, 4
	syscall

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall						# all done!

.end main

