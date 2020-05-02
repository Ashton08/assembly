####################################################################################
# Created by:  Null, Sheep
# CruzID       SheepNull
#              30 November 2018
#
# Assignment:  Lab 5: Subroutines
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program is to show how subrountines and the stack work 
#
# Notes:       This program is intended to be run from the MARS IDE.
####################################################################################

.text

#--------------------------------------------------------------------
# give_type_prompt
# input: $a0 - address of type prompt to be printed to user
# output: $v0 - lower 32 bit of time prompt was given in milliseconds
#--------------------------------------------------------------------

# REGISTER USAGE 
# $t0: Address of arguments passed

give_type_prompt:
        
	move $t0 $a0			# Moving first argument into $t0
	
   	li $v0 4			# Using syscall 4 to print string
   	la $a0 typePrompt     		# Passing the prompt wanted to print
   	syscall 

   	la $a0 ($t0)			# Called from LabTest.asm
   	syscall

	li $v0 30			# Your time is stored in $a0 argument
	syscall
	
	move $v0 $a0			# Moving your time into $v0 as per instructions
	
	jr $ra 				# jumps back to return address

#--------------------------------------------------------------------
# check_user_input_string
# input:  $a0 - address of type prompt printed to user
#         $a1 - time type prompt was given to user
#         $a2 - contains amount of time allowed for response
# output: $v0 - success or loss value (1 or 0)
#--------------------------------------------------------------------
  
  # REGISTER USAGE 
  # $t0: Allowed time
  # $t1: 
  # $t2: Holding the song
  # $t4: First time stamp
  # $t5: Actual time taken to type
  # $t8: Holding user input
  # $t9: Second time stamp
  # $a0: address of input buffer
  # $a1: maximum number of characters to read
  
check_user_input_string:

	# Pushing
	addi $sp $sp -4
	sw $ra ($sp) 
	
	move $t2 $a0			# Moving the address of song into $t2
	
	move $t0 $a2			# Moving the time allowed into $t0
	move $t4 $a1			# Contains the time from the first subroutine 

	# Taking user Input
	li $v0 8 			# Syscall 8 is for read string
	la $a0 input
	li $a1 100
	syscall
	move $t8 $a0			# Moving input $t8
	
	# Second time stamp
	li $v0 30
	syscall
	move $t9 $a0			# Moving second time into $t9
	
	sub $t5 $t9 $t4                 # Actual time it took to type prompt
	
	blt $t5 $t0 winner
	loser:
	li  $v0 0
	j   jumpWin
	
	winner:
	li   $v0 1
		
	la $a0 ($t2)			# Address the song
	la $a1 ($t8)			# User input
	jal compare_strings
	
	jumpWin:
	
	# Popping 
	lw $ra 0($sp)
	addi $sp $sp 4
	
	jr $ra

#--------------------------------------------------------------------
# compare_strings
#
# input:  $a0 - address of first string to compare
#         $a1 - address of second string to compare
#
# output: $v0 - comparison result (1 == strings the same, 0 == strings not the same)
#--------------------------------------------------------------------
compare_strings:

	# Pushing ra register
	addi $sp $sp -4
	sw $ra ($sp)
	
	move $t4 $a0			# Moving address of the song
	move $t6 $a1			# Moving address of the user input
	lb $t5 0($t4)
	lb $t2 0($t6)
	loop5:	
	
	beqz $t5 done
		
	move $a0 $t5			# Passing argument from song
	move $a1 $t2			# Passing argument from user
	
	jal compare_chars
	beqz $v0 nonEqual 
	
	addi $t4 $t4 1
	addi $t6 $t6 1
	
	lb $t5 ($t4)			# Loading byte from song
	lb $t2 ($t6)			# Loading byte from user(Array)

	
	j loop5	

	nonEqual:
	li $v0 0
	
	done:
	
	# Popping 
	lw $ra 0($sp)
	addi $sp $sp 4
	
	jr $ra

#--------------------------------------------------------------------
# compare_chars
#
# input:  $a0 - first char to compare (contained in the least significant byte)
#         $a1 - second char to compare (contained in the least significant byte)
#
# output: $v0 - comparison result (1 == chars the same, 0 == chars not the same)
#
#--------------------------------------------------------------------

compare_chars:


	move $t1 $a0			# Character from the song
	move $t2 $a1			# Character from the user
	
	bne $t2 $t1 notSame
	beq $t1 $t2 same
	
	notSame:
	li $v0 0			# Adding zero as per instructions
	j overSame
	
	same:
	li $v0 1			# Adding one as per instructions
	
	overSame:	
	jr $ra

.data



typePrompt: .asciiz "Type Prompt: "
input: .space 100
