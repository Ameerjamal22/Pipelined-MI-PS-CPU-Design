# Title: Filename:
# Author: Date:
# Description:
# Input:
# Output:
################# Data segment #####################
.data
var1: .byte 'A', 'E', 127, -1, '\n'
.align 0
var2: .half -10, 0xff
.align 2
var3: .word 0x12345678:100# repeat 0x12345678 100 times
.align 2
var4: .float 12.3, -0.1
.align 3
var5: .double 1.5e-10
.align 4
str1: .ascii "A String\n"
.align 4
str2: .asciiz "NULL Terminated String\0"
.align 0
input_str: .space 1024
.align 0


################# Code segment #####################
.text
.globl main
main: # main program entry

####################### system calls ########################
# syscall instruction for system calls
# to obtain services from the operating system .

# we should load the service number on the register $v0 that gives the return values
# we should load the arguments in register $a0 , $a1 . 
# issue the sys call instruction . 

# v0 = 1 print integer . (we put the value we want to print in a0)
#-li $a0, 100 #loading the argument that we want to print . 
#-li $v0, 1 
#-syscall

# for printing float and double load the value on $f12 use 2 for float , 3 for double

# to print string store the address of the null terminated string on a0 and use 4 
#la $a0, str2
#li $v0, 4
#syscall 
# use la to load adresses . 

#li $v0, 5
#syscall

#move $a0, $v0 
#li $v0, 1
#syscall

# the first 4 operations are used for reading int , float , double , string(null terminated)
# the 4 operation after them are used for printing int, float, double, string, respectively . 

# dynamic memory allocation . 
# operation number = 9 , number of bytes to be allocated the address of the allocated bytes will be returned in $v0 .  
# the you can use the address to store whatever you want on the allocated memory . 

# print char is on 11 , use a0 to store the value that will be printed . 
# read char 12 returns the read char in $v0 reg . 

# example that take an input string from the user and print it to the console . 
#li $v0, 8
#la $a0, input_str
#li $a1, 1024
#syscall


# R type (op , rs , rt , rd , sa , func ) , usually its opcode is zero . 

# 1 - add and subtract 

#li $t0, 14
#li $t1, -10

#addu $t0, $t0, $t1

#li $v0, 1
#move $a0, $t0
#syscall

# logic bitwise operations : and , or , xor , nor .

# and is used to clear the bits . 
# or us used to set bits . 
# xor is used to toggle bits . 
# nor is used as not and as nor . 
# nor $t1, $t2, $t2 #equivalent to t1 = !t2 


# arithmetic and logical shift :

#li $t1, 20
#sll $t1, $t1, 1

#move $a0, $t1
#li $v0, 1
#syscall

####### binary multiplication :
# we factor the number into a sum of powers of two and solve the problem by shifting and adding . 

####### I type instruction . 
#addi $t1, $t2, 2

#move $a0, $t1
#li $v0, 1
#syscall

# Mips control flow . 
# beq $t1, $t2, label
# bne $t1, $t2, label
    
    	
    li $t0, 2
    
    # read the the first integer from the user
#    li $v0, 5
#    syscall
#    addu $t3, $zero, $v0
    
#    li $v0, 5
#    syscall
#    addu $t4, $zero, $v0
    
#    bne $t0, $t1, Else
#    addu $t2, $t3, $t4
#    j End
#
#Else:
#    subu $t2, $t3, $t4
#    
#End:
#    li $v0, 1
#    addu $a0, $t2, $zero
#    syscall

# defining an array statically and dynamically 

#li $a0, 100
#li $v0, 9
#syscall

#move $t0, $v0

# load and store instruction . 
# 1- load and store words . 

# integer multiplication in Mips

#addiu $t1, $zero, 10        
#addiu $t2, $zero, 100
# use mfhi and mflo with the register you want to move the hi or lo registers values into the register . 

#mult $t1, $t2
#divu $t2, $t1
# remainder will be stored in hi , and quotient in lo . 

# functions 


jal Get_Print
j End

Get_Print:
    li $v0, 5
    syscall	
    	
    move $a0, $v0
    li $v0, 1 
    syscall
    
    jr $ra

End:

# Your code here
li $v0, 10 # Exit program
syscall
