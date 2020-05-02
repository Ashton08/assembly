####################################################################################
# Created by:  Null, Sheep
# CruzID       SheepNull
#              13 November 2018
#
# Assignment:  Lab 4: ASCII Decimal to 2SC
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program is to show how ascii values can convert to two's complement 
#
# Notes:       This program is intended to be run from the MARS IDE.
####################################################################################

# Pseudo code
####################################################################################
# read the two arguments
#	print $a0, $a1  # printing the two arguments
#	convert $a0,$a1 from ascii values to decimal
#	# save into new registers
#	$s1, $s2
#	add the two int's values save the int --> $s0
#	output the decimal to the console
#	output the sum as two's complement binary
####################################################################################

.data
printArgs: .asciiz "\nYou entered the decimal numbers:"
space: .asciiz" "
sumArgs: .asciiz "\n\nThe sum in decimal is:\n"
sumTwosComp: .asciiz "\n\nThe sum in two's complement binary is:\n"
morseCode: .asciiz "The sum in Morse code is:\n"
myArray: .space 32
print1: .asciiz "1"
print2: .asciiz "0"
line: "\n"

.text

main:
	# REGISTER USAGE
	# $a0: arguments
	# $a1: program arguments being passed through
	
	li $v0 4		# Print string($a0 = address of null terminated)
	la $a0 printArgs	# Passing the prompt
	syscall
	
	# Creating space between values
	li $v0 4
	la $a0 line
	syscall
	
	# Printing the first number
	lw $a0 ($a1)
	li $v0 4
	syscall
	
	# Creating space between values
	li $v0 4
	la $a0 space
	syscall
	
	# Printing the second number
	lw $a0 4($a1)
	li $v0 4
	syscall
	
	# REGISTER USAGE
	# $t0: Holding address for first byte
	# $t1: Holding actual first byte
	# $t2: Converted ascii value(FirstByte)
	# $t3: ANDing out & getting first num 
	# $t4: Holding the second byte
	# $t5: Flag for negative 
	# $s1: Holding first number passed through program arguments
	# $s2: Holding second number passed through program arguments
	
	lw $t0 ($a1)			# Loading arguments into $t0 register
	lb $t1 0($t0)			# Loading first byte from program argument passed through
	
	
	# First Number
while:
	beq $t1 0x2D negativeFound 	# 45 is the decimal number for a negative sign
	bne $t1 0x2D continue
	
	negativeFound:			
	add $t0 $t0 1
	add $t5 $t5 1		       # Flagging
	lb $t1 ($t0)
	
	continue:
	sub $t1 $t1 48			# Converting the actual byte from ascii
	or $t2 $t2 $t1			# Or'ing both values together, this is what puts it in the same register
	addi $t0 $t0 1			# Incrementing to move to the next byte
	lb $t1 ($t0)			# Loading that next byte into $t1
	
	beq $t1 0x00 finishStoring      # If you reach the null terminator exit now
	sll $t2 $t2 4			# Shifting over 4bits(x10)
	j while 
	
	convertToNegative:
	mul $s1 $s1 -1
	j next
	
	finishStoring:
	and $t3 $t2 0xF0		# This single's out that first byte
	srl $t3 $t3 4			# Now putting it back into the frist byte's place
	mul $t3 $t3 10			# Times by 10 to get the first num in it's right place
	and $t4 $t2 0xF			# Doing the samething but getting the second byte
	add $s1 $t3 $t4			# Adding both values together
	beq $t5 1 convertToNegative
		
next:

# Second number


# Clearing Registers out	
mul $t0 $t0 0
mul $t1 $t1 0
mul $t2 $t2 0
mul $t3 $t3 0
mul $t4 $t4 0
mul $t5 $t5 0
mul $t6 $t6 0
mul $t7 $t7 0
mul $t8 $t8 0

	lw $t0 4($a1)			# Loading arguments into $t0 register
	lb $t1 ($t0)			# Loading second byte from program argument passed through
	

while2:

	beq $t1 0x2D negativeFound2 	# 45 is the decimal number for a negative sign
	bne $t1 0x2D continue2
	
	negativeFound2:			
	add $t0 $t0 1
	add $t5 $t5 1
	lb $t1 ($t0)
	
	continue2:
	sub $t1 $t1 48			# Converting the actual byte from ascii
	or $t2 $t2 $t1			# Or'ing both values together, this is what puts it in the same register
	addi $t0 $t0 1			# Incrementing to move to the next byte
	lb $t1 ($t0)			# Loading that next byte into $t1
	
	beq $t1 0x00 finishStoring2     # If you reach the null terminator exit now
	sll $t2 $t2 4			# Shifting over 4bits(x10)
	j while2 
	
	convertToNegative2:
	mul $s2 $s2 -1
	j nextPart2
	
	
	finishStoring2:
	and $t3 $t2 0xF0		# This single's out that first byte
	srl $t3 $t3 4			# Now putting it back into the frist byte's place
	mul $t3 $t3 10			# Times by 10 to get the first num in it's right place
	and $t4 $t2 0xF			# Doing the samething but getting the second byte
	add $s2 $t3 $t4			# Adding both values together
	beq $t5 1 convertToNegative2
	
nextPart2: 

gettingSum:
	add $s0 $s1 $s2			# Adding the program arguments
	
	li $v0 4
	la $a0 sumArgs
	syscall
	
# Clearing Registers out	
mul $t0 $t0 0
mul $t1 $t1 0
mul $t2 $t2 0
mul $t3 $t3 0
mul $t4 $t4 0
mul $t5 $t5 0
mul $t6 $t6 0
mul $t7 $t7 0
mul $t8 $t8 0


	# REGISTER USAGE
	# $s0: Sum from added program arguments
	# $t1: 0
	# $t2: 
	# $t3: Array
	# $t4: Holding address for array
	# $t5: Flagging for negative value
	# $t3: Loop counter
	# $t6: Quotient
	# $t7: Reminder
	# $t8: Where to start in the array
	# $t9: Holding the sum

		
	li $t1 0
	la $t4 myArray
	move $t3 $t4
	

	move $t9 $s0			# Holding the sum
	bltz $t9 addNegative		#<-- actually making it positive 
	bgtz $t9 loop
	beqz $t9 printValue
	addNegative:
	addi $t5 $t5 1			
	mul $t9 $t9 -1			# Making it negative
	li $a0 0x2D
	li $v0 11
	syscall
	

loop:		

	# Getting value in 100th's place
	
	bgt $t9 99 greaterThan100		
	blt $t9 100 skip100
	greaterThan100:
	div $t9 $t9 100
	mflo $t6		        # Quioent
	mfhi $t0		        # Reminder
	addi $t6 $t6 48
	
	sb $t6 ($t3)
	add $t3 $t3 1
	
	
	# Getting value from the 10th's place
	skip100:
	
	bgt $t9 9 nine
	beqz $t9 strZero
	
	blt $t9 10 skip10
	strZero:
	
	addi $t6 $t9 48
	sb $t6 ($t3)
	add $t3 $t3 1
	j skipAgain2
	
	blt $t9 10 skipAgain2
	nine:
	div $t9 $t9 10
	mflo $t6
	mfhi $t0
	addi $t6 $t6 48
	
	sb $t6 ($t3)
	add $t3 $t3 1
	
	
	# Getting value from the 1's place
	
	skip10:
	skipAgain2:
	
	less:
	beqz $t0 printValue
	add $t0 $t0 48
	add $t6 $t6 48
	j printA
	printValue:
	add $t9 $t9 48
	la $a0 ($t9)
	li $v0 11 
	syscall
	j OverMoon
	
	printA:
	sb $t0 ($t3)
	la $a0 myArray
	li $v0 4
	syscall

	OverMoon:
	
	
	beqz $t7 exit
	j loop


	exit: li $v0 10
	
# morseCode part

# Clearing Registers out	
mul $t0 $t0 0
mul $t1 $t1 0
mul $t2 $t2 0
mul $t3 $t3 0
mul $t4 $t4 0
mul $t5 $t5 0
mul $t6 $t6 0
mul $t7 $t7 0
mul $t8 $t8 0


complement:

	li $v0 4
	la $a0 sumTwosComp		 # Printing out prompt
	syscall
	
	li $t1 0x80000000		# Masking <- suggested from piazza (10000000000000000000000000000000) 32Bits
	li $t3 0			# Loop Condition		
	
loop12: 
	beq $t3 32 exit12		# Exit's after 32 bits are printed
	and $t2 $s0 $t1			# Anding together to get in binary
	beq $t2 $t1 printOne		# Printing 1
	bne $t2 $t1 printZero		# Printing 0
finishPart:
	srl $t1 $t1 1			# Move to the right
	addi $t3 $t3 1			# Incrementing for loop
	j loop12
	
	printOne:
	li $v0 4
	la $a0 print1
	syscall
	j finishPart
	
	printZero:
	li $v0 4
	la $a0 print2
	syscall 

	j finishPart
	
	
	exit12:
	# Creating space between values
	li $v0 4
	la $a0 line
	syscall
	li $v0 10
	
	
