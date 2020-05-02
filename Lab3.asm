####################################################################################
# Created by:  Null, Sheep
# CruzID       SheepNull
#              7 August 2018
#
# Assignment:  Lab 3: Looping in MIPS
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2018
#
# Description: This program shows a loop in  MIPS to the screen.
#
# Notes:       This program is intended to be run from the MARS IDE.
####################################################################################



.text 
main:
	# Prompting for the integer to enter
        li $v0, 4			# Using syscall 4 to print string
        la $a0, prompt 			# Passing the prompt wanted to print
	syscall 
        
        li $v0, 5			# Using syscall 5 to read the integer
        syscall 
        move $t0, $v0			# Placing value from $v0 inside $t0
        
        li $t1, 0 			# Starting point for loop i=0
        
        # REGISTER USAGE
        # $t0: user input
        # $t1: loop counter
        # $t2: 5 
        # $t3: remainder(i%5)
        # $t4: remainder(i%7)
        # $t5: 7
        
loop: 
	bgt $t1, $t0, end		# If $t1 < $t2 prompt(UserInput) end the loop 
	
	# Get flux
	li $t2, 5			# Placing 5 inside register $t2
	rem $t3, $t1, $t2		# $t3 = ($t1)/($t2) = remainder is now inside $t3
	
	
	# Get bunny
	li $t5, 7			# Placing 7 inside register $t5
	rem $t4,$t1,$t5			# $t4 = ($t1)/($t5) = remainder is now inside $t4
	
	

	beqz $t3, fluxprint		# If $t3(i%5) is equal to 0 go to fluxprint function
bunnyCheck:
	beqz $t4, bunnyprint		# If $t4(i%7) is equal to 0 go to bunnyprint function
	beqz $t3, newLine		# If $t3(i%5) is equal to 0 go to print newLine 
printNumber:
	li $v0, 1			# Using 1 from syscall to print integer
	move $a0, $t1			# Passing through loop counter to be printed
	syscall
newLine:
	li $v0, 4			# Using syscall 4 to print string
        la $a0, line 			# Passing the line text to be printed
	syscall 
	
	add $t1, $t1, 1			# Incrementing the loop (i = i+1)
	j loop
end:
	li $v0, 10			# Ending the program
	syscall
        
fluxprint:
	
	li $v0, 4		        # Syscall 4 prints string when null term. is reached
	la $a0, flux			# Passing through argument to be printed
	syscall
	j bunnyCheck
	
bunnyprint:
	
	li $v0, 4			# Syscall 4 prints string when null term. is reached
	la $a0, bunny			# Passing through argument to be printed
	syscall
	j newLine
			
.data 
	prompt: .asciiz "Please input a positive integer: "	
        flux: .asciiz "Flux "	
        bunny: .asciiz "Bunny"
        line: .asciiz "\n"
