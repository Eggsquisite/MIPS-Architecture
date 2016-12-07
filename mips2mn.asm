#  CS 218, MIPS Assignment #2
#  Provided Template

#	Program to calculate area of each trapezoid in a
#	series of trapezoids.
#	Also finds min, med, max, sum, and average for
#	the trapezoid areas.

#	Formula:
#	   tAreas[n] = (heights[i] * (aSides[i] + cSides[i] / 2))

###########################################################
#  data segment

.data

aSides:
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	 202,  209,  215,  219,  223,  225,  231,  242,  244,  249
	.word	 251,  253,  266,  269,  271,  272,  280,  288,  291,  299
	.word	  15,   25,   33,   44,   58,   69,   72,   86,   99,  101
	.word	1469, 2474, 3477, 4479, 5482, 5484, 6486, 7788, 8492, 9493
	.word	 107,  121,  137,  141,  157,  167,  177,  181,  191,  199
	.word	 369,  374,  377,  379,  382,  384,  386,  388,  392,  393

cSides:
	.word	 206,  212,  222,  231,  246,  250,  254,  278,  288,  292
	.word	 332,  351,  376,  387,  390,  400,  411,  423,  432,  445
	.word	 457,  487,  499,  501,  523,  524,  525,  526,  575,  594
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	1782, 2795, 3807, 3812, 4827, 5847, 6867, 7879, 7888, 9894
	.word	  32,   51,   76,   87,   90,  100,  111,  123,  132,  145
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753

heights:
	.word	 203,  215,  221,  239,  248,  259,  262,  274,  280,  291
	.word	 400,  404,  406,  407,  424,  425,  426,  429,  448,  492
	.word	 501,  513,  524,  536,  540,  556,  575,  587,  590,  596
	.word	1912, 2925, 3927, 4932, 5447, 5957, 6967, 7979, 7988, 9994
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	 782,  795,  807,  812,  827,  847,  867,  879,  888,  894

tAreas:	.space	280

len:	.word	70

taMin:	.word	0
taMed:	.word	0
taMax:	.word	0
taSum:	.word	0
taAve:	.word	0

LN_CNTR	= 7


# -----

hdr:	.ascii	"MIPS Assignment #2 \n\n"
	.ascii	"  Program to calculate area of each trapezoid"
	.ascii	" in a series of trapezoids.\n"
	.ascii	"  Also finds min, est. med, max, sum, and average "
	.ascii	"for the trapezoid areas. \n\n"
	.ascii	"  Formula: \n"
	.asciiz	"    tAreas[n] = (heights[i] * (aSides[i] + cSides[i] / 2))\n\n"

newLine:
	.asciiz	"\n"
blnks:	.asciiz	"  "

a1_st:	.asciiz	"\nTrapezoid areas min = "
a2_st:	.asciiz	"\nTrapezoid areas emed = "
a3_st:	.asciiz	"\nTrapezoid areas max = "
a4_st:	.asciiz	"\nTrapezoid areas sum = "
a5_st:	.asciiz	"\nTrapezoid areas ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main

main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# -----

	la	$t0, tAreas		# $t0 will contain addr of tAreas
	la	$t1, aSides		# set aSides array to $t0
	la	$t2, cSides		# set cSides array to $t1
	la	$t3, heights		# set heights values to $t2

	lw	$t4, len		# set length to $s0
	li	$s7, 0

	#	$s0 will contain value at current tAreas
	# 	$s1 will contain value at current aSides
	# 	$s2 will contain value at current cSides
	#	$s3 will contain value at current heights

	# 	$s4 will contain min
	#	$s5 will contain emed
	#	$s6 will contain max
	#	$s7 will contain sum

findAreas:
	lw	$s0, ($t0)		# $s0 pointing at next location in tAreas
	lw	$s1, ($t1)		# value at current aSides insert to $s1
	lw	$s2, ($t2)		# value at current cSides insert to $s2
	lw	$s3, ($t3)		# value at current heights insert to $s3

	addu	$s0, $s1, $s2		# $t0 = aSides[i] + cSides[i]
	divu	$s0, $s0, 2		# $t0 = $t0 / 2
	mul	$s0, $s0, $s3		# $t0 = $t0 * heights[i]

	add	$s7, $s7, $s0		# add tAreas to sum
	sw	$s0, tAreas		

	bne	$t4, 70, skipCheck	# check if first time
	move	$s4, $s0		# store first tArea into min
	move	$s5, $s0		# store first tArea into emed
	move	$s6, $s0		# store first tArea into max

	bne	$t4, 45, skipCheck	# check if halfway
	addu	$s5, $s5, $s0		# add middle tAreas value to emed

skipCheck:
	bge	$s0, $s4, minDone
	move	$s4, $s0
	sw	$s4, taMin

minDone:
	ble	$s0, $s6, maxDone
	move	$s6, $s0
	sw	$s6, taMax

maxDone:
	remu	$t5, $t4, 7
	bne	$t5, 0, skipLine
	
	la	$a0, newLine
	li	$v0, 4
	syscall

skipLine:
	lw	$a0, tAreas
	li	$v0, 1
	syscall

	la	$a0, blnks
	li	$v0, 4
	syscall

	addu	$t0, $t0, 4
	addu 	$t1, $t1, 4		# increment all arrays to the next value
	addu	$t2, $t2, 4
	addu	$t3, $t3, 4

	subu	$t4, $t4, 1		# decrement length
	bnez	$t4, findAreas		# loop

	sw	$s7, taSum
	div	$s7, $s7, 70
	sw	$s7, taAve

	addu	$s5, $s5, $s0		# add final tArea to eMed
	divu	$s5, $s5, 3		# find avg of eMed
	sw	$s5, taMed		# store to taMed


##########################################################
#  Display results.

	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall
	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, taMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, taMed
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, taMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, taSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, taAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

