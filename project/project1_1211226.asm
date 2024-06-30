# Title: project 1 .
# Author: Ameer Rabie . 
################# Data segment #####################
.data
# Messages.......................................................................................................................................

menu_message: .asciiz "\n\nEnter you choice please:\n1- Add a new medical test\n2- Search for a test by patient id\n3- Search for unnormal test\n4- Get Average value for each test\n5- Update an existing test result\n6- Delete a test \n7- exit\n\n" 
exit_message: .asciiz "\nThanks for using the program ." 
invalid_choice_message: .asciiz "\n\nInvalid choice enter a valid choice please \n\n" 
list_exist_message: .asciiz "\n\nList already exist check the contents of $s1"
invalid_char_pid: .asciiz "\nPatient id contains invalid char .\n"
invalid_number_of_digits_pid: .asciiz "\nInvalid number of digits in pid, number of digits should be 7\n"
invalid_char_test_name: .asciiz "\nInvalid char in test name"
invalid_test_name: .asciiz "\nInvalid test name\n"
invalid_char_test_date: .asciiz "\nInvalid chars in test date check input and try again !\n" 
invalid_year_digits: .asciiz "\ninvalid test date there is check the input year and make sure it consist of 4 digits\n"
invalid_month_digits: .asciiz "\ninvalid test date there is check the input month and make sure it consist of 2 digits\n"
invalid_char_test_result: .asciiz "\nInvalid char in test result check the input passed and try again\n"
invalid_test_result_no_value: .asciiz "\nInvalid test result, no value in the passed input."
reading_patient_id_message: .asciiz "\nEnter patient id (make sure it is 7 digit number):"
invalid_test_creation: .asciiz "\nFailed to create a new test, try again please .\n"
reading_test_name: .asciiz "\nEnter test name should be one of the following (Hgb, BGT, BPT, LDL):"
reading_test_date: .asciiz "\nEnter the test date make sure it follows the following format yyyy-mm :" 
reading_test_result: .asciiz "\nEnter test result floating point number (if the test is Bpt Enter the systolic blood pressure):" 
reading_test_result2: .asciiz "\nEnter the second test result as floating point number (Diastolic blood presure):" 
invalid_Bpt_test_result: .asciiz "\nThe test value is invalid make sure to enter the Systolic before the diastolic blood pressure\n\n"
invalid_month: .asciiz "\nInvalid input month\n"
null_list: .asciiz "\nThe passed list head is null, make sure the list is created .\n"
test_node_null: .asciiz "\nThe passed test node is null .\n"
list_header: .asciiz "\npatientId , testName , date , result\n" 
delete_input_message: .asciiz "\nEnter the index of the test you want to delete:" 
successful_deletion: .asciiz "\nTest was deleted successfully.\n"
invalid_index: .asciiz "\nThe input index is invalid, choose an available index ."
empty_list: .asciiz "\nThe input list is empty make sure that the list is created"
update_input_message: .asciiz "\nEnter the index of the test you want to update:"
update_menu: .asciiz "\nEnter your choice for updare:\n1- patient_id\n2- test name\n3- date\n4- result\n5- exit\n"
invalid_update_choice: .asciiz "\nInvalid update choice .\n"
invalid_update_attempt: .asciiz "\nInvalid Update Attempt, Try again later\n"
Hgb_average: .asciiz "\nAverage Test Result (HGB):" 
empty_list1: .asciiz " There is no tests in the list ." 
Hgb_unit: .asciiz " grams per deciliter \n"
BGT_average: .asciiz "\nAverage Test Result (BGT):"
BGT_unit: .asciiz " milligrams per deciliter\n"
LDL_average: .asciiz "\nAverage Test Result (LDL):"
LDL_unit: .asciiz " milligrams per deciliter\n"
BPT_average: .asciiz "\nAverage Test Result (BPT):"
BPT_unit: .asciiz " millimeters of mercury\n"
no_test_type: .asciiz "\nThere is no test of this type \n"
read_patient_id_search: .asciiz "\nEnter the patient id for search:"
Search_by_patient_id_menu: .asciiz "Enter your choice:\n1-Retrieve all patient tests\n2-Retrieve all up normal patient tests\n3-Retrieve all patient tests in a given specific period\n4-Exit\n\n"
empty_patient_list: .asciiz "\n\nThere is not tests that match the specified patient id . \n\n"


# Values:.......................................................................................................................................

Hgb_comparison:  .align 2
                .asciiz "hgb"
BGT_comparison:  .align 2
                .asciiz "bgt"
LDL_comparison:  .align 2
                .asciiz "ldl"
BPT_comparison:  .align 2
                .asciiz "bpt"
comma: .asciiz ", "
vertical_points: .asciiz ": "
endl: .asciiz "\n"
dash: .asciiz "-"
slash: .asciiz "/"
hgb_upper_bound: .align 2
		.float 13.8
hgb_lower_bound: .align 2
		.float 17.2		
BGT_lower_bound: .align 2
		.float 77.0	
BGT_upper_bound: .align 2
		.float 99.0
LDL_upper_bound: .align 2
		.float 100.0
Bpt_systolic_upper_bound: .align 2
		.float 120.0
Bpt_Diastolic_upper_bound: .align 2
		.float 80.0		

################# Code segment #####################
.text
.globl Main

Main:	
	# we should load the data from file here	
	jal CreateTestsList
	
	j MainLoop
	
	beq $v0, $zero, ExitProgram
	
	ExitProgram:
		li $v0, 4
		la $a0, exit_message
		syscall
				
		li $v0, 10 # Exit program
		syscall
	
MainLoop:
	#1- read the file contents. 
	#   prompt if there is something wrong
	
	li $v0, 4
	la $a0, menu_message
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0 # user choice = $t0  
	move $t1, $zero
	
	AddMedicalTest:
			addiu $t1, $t1, 1  # checking if this is the choice of the user .
			bne $t0, $t1, SearchTestByPatienttId
			
			jal CreateTestByUser  # calling test by user function . 
			
			beq $v0, $zero, MainLoop
			
			move $a0, $v1  # inserting test into the list of tests . 
			move $a1, $s1
			jal InsertTestIntoList
			
			j MainLoop 
			
			
	SearchTestByPatienttId:
			addiu $t1, $t1, 1 
			bne $t0, $t1, SearchForUnnormalTests
			
			addi $sp, $sp, -12  # saving register value .
			sw $t0, 0($sp)
			sw $t1, 0($sp)
			sw $v1, 0($sp)
			
			move $a0, $s1
			jal SearchTestsByPatientId
			
			addi $sp, $sp, 12  # loading the saved registers . 
			lw $t0, 0($sp)
			lw $t1, 0($sp)
			lw $v1, 0($sp)
			
			j MainLoop
			
			
	SearchForUnnormalTests:
			addiu $t1, $t1, 1
			bne $t0, $t1, GetAverageValueForEachTest
			
			addi $sp, $sp, -12  # saving register value .
			sw $t0, 0($sp)
			sw $t1, 0($sp)
			sw $v1, 0($sp)
			
			move $a0, $s1
			jal SearchForUnnormalTest
			
			addi $sp, $sp, 12  # loading the saved registers . 
			lw $t0, 0($sp)
			lw $t1, 0($sp)
			lw $v1, 0($sp)
			
			j MainLoop
			
			
	GetAverageValueForEachTest:
			addiu $t1, $t1, 1 
			bne $t0, $t1, UpdateAnExistingTestResult
			
			addi $sp, $sp, -12  # saving register value .
			sw $t0, 0($sp)
			sw $t1, 0($sp)
			sw $v1, 0($sp)
			
			move $a0, $s1
			jal AverageTestValueForMedicalTests
			
			addi $sp, $sp, 12  # loading the saved registers . 
			lw $t0, 0($sp)
			lw $t1, 0($sp)
			lw $v1, 0($sp)
			
			j MainLoop
			
	UpdateAnExistingTestResult:
			addiu $t1, $t1, 1 
			bne $t0, $t1, DeleteTest
			
			addi $sp, $sp, -12  # saving register value .
			sw $t0, 0($sp)
			sw $t1, 0($sp)
			sw $v1, 0($sp)
			
			move $a0, $s1
			jal UpdateTest
			
			addi $sp, $sp, 12  # loading the saved registers . 
			lw $t0, 0($sp)
			lw $t1, 0($sp)
			lw $v1, 0($sp)
			
			j MainLoop
			
			
	DeleteTest:
			addiu $t1, $t1, 1 
			bne $t0, $t1, ExitMainLoop
			
			addi $sp, $sp, -12  # saving register value .
			sw $t0, 0($sp)
			sw $t1, 0($sp)
			sw $v1, 0($sp)
			
			move $a0, $s1  # calling delete test function . 
			jal DeleteTests
			
			addi $sp, $sp, 12  # loading the saved registers . 
			lw $t0, 0($sp)
			lw $t1, 0($sp)
			lw $v1, 0($sp)
			
			j MainLoop
			
			
	ExitMainLoop:
			addiu $t1, $t1, 1	 
			bne $t0, $t1, InvalidChoice
			j ExitProgram
			
			
	InvalidChoice:	
			li $v0, 4
			la $a0, invalid_choice_message
			syscall
			
			j MainLoop

# works	
CreateTestsList:
	
	bne $s1, $zero, ListExist  # Checks if the list already exist (created list is always stored in $s1 since we only need one list)
	
	
	li $a0, 8
	li $v0, 9
	syscall  # Dynamically allocating a memory space for the list head Node .
	
	move $s1, $v0  # $s1 = (Address of the head node) 
	sw $zero, 0($s1)  # List size = 0  
	sw $zero, 4($s1)  # Head Next = Null
	
	jr $ra 
	
	ListExist:
		la $a0, list_exist_message
		li $v0, 4 
		syscall
		
		jr $ra	


IsValidPatientId:
	# user should pass the address of the string in $a0
	# the function return if the patient id is valid or not
	move $t9, $zero # $t9 = 0 (the number of digits found till the first ',')
	
	Loop1:
		lbu $t6, 0($a0) 
		j IsDigit
		
		IsDigit:
			blt $t6, '0', IsSpace 

			bgt $t6, '9', IsSpace
			
			addiu $t9, $t9, 1
			addiu $a0, $a0, 1
			j Loop1
			
		IsSpace:
			bne $t6, ' ', IsCommaOrNull
			
			addiu $a0, $a0, 1
			j Loop1
			
		IsCommaOrNull:
			beq $t6, ' ', IsCorrectNumberOfDigits
			beq $t6, ',', IsCorrectNumberOfDigits
			beq $t6, '\n', IsCorrectNumberOfDigits
			beq $t6, 13, IsCorrectNumberOfDigits
			beq $t6, $zero, IsCorrectNumberOfDigits
			j NotValidChar
			
	NotValidChar:
		li $v0, 4	
		la $a0, invalid_char_pid
		syscall
		
		move $v0, $zero
		jr $ra
		
	IsCorrectNumberOfDigits:
		li $t4, 7
		bne $t9, $t4, IncorrectNumberOfDigits
		
		CorrectNumberOfDigits:
			addiu $v0, $zero, 1
			jr $ra
			
		IncorrectNumberOfDigits:
			li $v0, 4
			la $a0, invalid_number_of_digits_pid
			syscall
			
			move $v0, $zero
			jr $ra
			
			
StringToInt:
	# integer should be valid in order for it to be converted
	# the string may contain spaces after or before
	# the address of the string is received on $a0
	# the returned value is stored in $v0
	move $v0, $zero  # sum($v0) = 0  
	li $t0, 10  # base($t0) = 10
	
	Loop2:
		lb $t1, 0($a0)
		
		blt $t1, '0', NotDigit	
		bgt $t1, '9', NotDigit
		addiu $t1, $t1, -48
		
		mul $v0, $v0, $t0
		addu $v0, $v0, $t1
		
		addiu $a0, $a0, 1
		j Loop2
		
	NotDigit:
		beq $t1, ' ', Skip
		jr $ra
	Skip:
		addiu $a0, $a0, 1
		j Loop2
	

ValidateAndReturnTestName:
	# the address of the string should be passed in $a0
	# return if the testname is valid or not in $v0
	# return the test null terminated string address in memory $v1
	
	SkipSpacesLoop:
		lbu $t8, 0($a0)  # $t8 = str[i] 
		addiu $a0, $a0, 1 # i += 1
		beq $t8, ' ', SkipSpacesLoop
	
	# dynamically allocating 4 bytes to store the string
	li $v0, 9
	move $t5, $a0
	li $a0, 4
	syscall
	
	move $t4, $v0  # the address where we store string chars in memory is in $t4
	move $a0, $t5
	sb $zero, 3($t4)
	
	li $t3, 0  # counter($t3) = 0 
	
	UpperCaseHandler:
		blt $t8, 'A', LowerCaseHandler
		bgt $t8, 'Z', LowerCaseHandler
		addiu $t8, $t8, 32 #  Converting the char to lower case if it is uppercaae .
		
	LowerCaseHandler:
		beq $t8, ',', FinalCheck  # Checks if the string ended .
		beq $t8, 0, FinalCheck
		beq $t8, '\n', FinalCheck
		beq $t8, 13, FinalCheck
		blt $t8, 'a', NotValidChar1
		bgt $t8, 'z', NotValidChar1
		
		beq $t3, 3, FinalCheck # Check if Three chars were parsed .we may change it ............................
		addiu $t3, $t3, 1
		
		sb $t8, 0($t4)
		addiu $t4, $t4, 1
		
		lbu $t8, 0($a0)
		addiu $a0, $a0, 1 
		
		j UpperCaseHandler
		
	NotValidChar1:
		li $v0, 4
		la $a0, invalid_char_test_name
		syscall
		
		move $v0, $zero
		jr $ra
		
	FinalCheck:
		subu $t4, $t4, $t3
		lw $t6, 0($t4)
		
		la $v1, Hgb_comparison
		lw $t3, 0($v1)
		beq $t3, $t6, ValidTestName
		
		la $v1, BGT_comparison
		lw $t3, 0($v1)
		beq $t3, $t6, ValidTestName 		 	 		 	
		
		la $v1, LDL_comparison
		lw $t3, 0($v1)
		beq $t3, $t6, ValidTestName
		
		la $v1, BPT_comparison
		lw $t3, 0($v1)
		beq $t3, $t6, ValidTestName
		
		li $v0, 4
		la $a0, invalid_test_name
		syscall
		
		li $v0, 0
		jr $ra
		
	ValidTestName:
		li $v0, 1 
		jr $ra
		

ValidateAndReturnTestDATE:
	# pass the address of the string you want to validate in $a0
	# the function will return if the input is valid or not in the register $v0
	# if the input is valid the function will return test date as an encrypted integer in $v1
		
	SkipSpacesLoop1:
		lbu $t8, 0($a0)  # $t8 = str[i] . 
		addiu $a0, $a0, 1 # i += 1 .
		beq $t8, ' ', SkipSpacesLoop1	
	
	move $t6, $zero  # digits counter($t6) = 0 . 
	
	move $t5, $a0  # storing the address of our string in a temporary register to preserve its value .
	
	li $a0, 5 # dynamically allocating a word in memory to store the year bytes  .
	li $v0, 9
	syscall
	
	move $t4, $v0  # the address of the dynamically allocated word is stored in $t4 .
	move $a0, $t5
	
	YearsHandler:
		beq $t8, '-', DashHandler
		blt $t8, '0', NotValidChar2
		bgt $t8, '9', NotValidChar2
		
		sb $t8, 0($t4)
		
		addiu $t4, $t4, 1  # updating the address of word and the digits counter .
		addiu $t6, $t6, 1
		
		lb $t8, 0($a0)  # loading the new char and updating the address . 
		addiu $a0, $a0, 1 
		
		beq $t6, 5, InvalidYearsDigits				
		j YearsHandler
		
	DashHandler:
		bne $t6, 4, InvalidYearsDigits  # checking if the number of digits in the year section is valid
		
		lb $zero, 0($t4)  # adding null at the end of the string to be able to convert it to int . 
		addi $t4, $t4, -4  # updating the address to be at the start if the string . 
		
		addi $sp, $sp, -12  # storing the important variables in the stack segment to be able to retrive after the function call .
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $t4, 8($sp)
		
		move $a0, $t4  # calling the function to convert the year string into int
		jal StringToInt
		
		move $v1, $v0  # v1 = int(year_section_string)
		mul $v1, $v1, 100 # v1 *= 100
		
		lw $ra, 0($sp)  # retriving data stored in stack segment and closing it
		lw $a0, 4($sp)
		lw $t4, 8($sp)
		addi $sp, $sp, 12
		
		move $t6, $zero
		sb $zero, 2($t4)
		
	MonthHandler:
		lb $t8, 0($a0)  # loading char from the month section
	
		beq $t8, ',', CommaAndNullHandler
		beq $t8, $zero, CommaAndNullHandler
		beq $t8, '\n', CommaAndNullHandler
		beq $t8, 13, CommaAndNullHandler
		blt $t8, '0', NotValidChar2
		bgt $t8, '9', NotValidChar2
		
		sb $t8, 0($t4)
		
		addiu $t4, $t4, 1  # updating the address of word and the digits counter .
		addiu $t6, $t6, 1
		
		addiu $a0, $a0, 1  # updating the address of the string .
		
		beq $t6, 3, InvalidMonthDigits				
		j MonthHandler
		
	CommaAndNullHandler:
		bne $t6, 2, InvalidMonthDigits  # checking if the number of digits in the year section is valid
		
		lb $zero, 0($t4)
		addi $t4, $t4, -2
		
		addi $sp, $sp, -12  # storing the important variables in the stack segment to be able to retrive after the function call .
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $t4, 8($sp)
		
		move $a0, $t4  # calling the function to convert the month string into int
		jal StringToInt
		
		blt $v0, $zero, InvalidMonth  # checking if the month is valid or not . 
		bgt $v0, 12, InvalidMonth
		
		addu $v1, $v1, $v0  # v1 += int(month_section_string)
		
		lw $ra, 0($sp)  # retriving data stored in stack segment and closing it
		lw $a0, 4($sp)
		lw $t4, 8($sp)
		addi $sp, $sp, 12
		
		jr $ra
		
	InvalidMonth:
		la $a0, invalid_month  # prompting the user that the month is invalid 
		li $v0, 4
		syscall
		
		move $v0, $zero 
		jr $ra
		
	InvalidMonthDigits:
		li $v0, 4  # prompting the user that there is more or less than specified digits in month part
		la $a0, invalid_month_digits
		syscall  
	
		move $v0, $zero
		jr $ra	
		
	NotValidChar2:
		li $v0, 4  # prompting the user that there is an invalid char in the test date .
		la $a0, invalid_char_test_date
		syscall  
		
		move $v0, $zero
		jr $ra
	
	InvalidYearsDigits:
		li $v0, 4  # prompting the user that there is an extra digits in year part
		la $a0, invalid_year_digits
		syscall  
	
		move $v0, $zero
		jr $ra	
		

ValidateAndReturnTestResult:
	# the address of the test result should be passed in $a0
	# the function will return if the test result is valid in $v0
	# the function will return the test result as floating point number in $f0
	
	move $t6, $zero  # integer part digits counter = 0 
	move $t5, $zero  # decimal part digits counter = 0
	
	SkipSpacesLoop2:
		lbu $t8, 0($a0)  # $t8 = str[i] . 
		addiu $a0, $a0, 1 # i += 1 .
		beq $t8, ' ', SkipSpacesLoop2	
	
	move $t4, $a0  # storing the address of the test result in a temp register .
	
	li $a0, 19  # dynamically allocating 19 bytes to store the digits of the integer part
	li $v0, 9
	syscall
	
	move $a0, $t4
	move $t4, $v0  # the address of the dynamically allocated array of digits in ($t4)
		
	IntegerPartHandler:
		beq $t8, '.', DecimalPartHandler
		beq $t8, ',', CommaAndNullHandler1
		beq $t8, 13, CommaAndNullHandler1
		beq $t8, '\n', CommaAndNullHandler1
		beq $t8, $zero, CommaAndNullHandler1
		blt $t8, '0', NotValidChar3
		bgt $t8, '9', NotValidChar3
		
		addiu $t6, $t6, 1  # incrementing the integer digits counter .
		
		sb $t8, 0($t4)  # storing the digit and incrementing the storing address
		addiu $t4, $t4, 1
		
		lb $t8, 0($a0)  # loading the next digit updating the address . 
		addiu $a0, $a0, 1
		
		j IntegerPartHandler
		
	DecimalPartHandler:
		move $t3, $a0
		
		li $a0, 11  # dynamically allocating array to store the deciaml part digits .
		li $v0, 9
		syscall
		
		move $a0, $t3
		move $t3, $v0  # the dynamically allocated array is stored in ($t3)
		
		Loop3:
			lb $t8, 0($a0)  # loading the digit from the memory
			addiu $a0, $a0, 1
			
			beq $t8, ',', CommaAndNullHandler1
			beq $t8, 13, CommaAndNullHandler1
			beq $t8, '\n', CommaAndNullHandler1
			beq $t8, $zero, CommaAndNullHandler1
			blt $t8, '0', NotValidChar3
			bgt $t8, '9', NotValidChar3
			
			addiu $t5, $t5, 1  # incrementing the integer digits counter .
			
			sb $t8, 0($t3)  # storing the digit and incrementing the storing address
			addiu $t3, $t3, 1
			
			j Loop3 
			
	CommaAndNullHandler1:
		bgt $t6, $zero, AddIntegerPart 
		
		
		AddIntegerPart:
			subu $t9, $t4, $t6  # adjusting the address to the start of integer part array of digits .	
			
			addi $sp, $sp, -20  # storing variables in the stack segment before calling the function . 
			sw $t3, 0($sp)
			sw $t4, 4($sp)
			sw $t5, 8($sp)
			sw $t6, 12($sp)
			sw $ra, 16($sp)
			
			move $a0, $t9  # converting integer part into int 
			jal StringToInt
			
			lw $t3, 0($sp)  # loading data that was stored in the stack segment before the function call .
			lw $t4, 4($sp)
			lw $t5, 8($sp)
			lw $t6, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20   
			
			mtc1 $v0, $f3  # storing the integer part in floating point register .
			beq $t5, $zero, ReturnHandler
			j AddDecimalPart
			
		AddDecimalPart:
			subu $t9, $t3, $t5  # adjusting the address to the start of integer part array of digits .	
			
			addi $sp, $sp, -20  # storing variables in the stack segment before calling the function . 
			sw $t3, 0($sp)
			sw $t4, 4($sp)
			sw $t5, 8($sp)
			sw $t6, 12($sp)
			sw $ra, 16($sp)
			
			move $a0, $t9
			jal StringToInt
			
			mtc1 $v0, $f5
			
			lw $t3, 0($sp)  # loading data that was stored in the stack segment before the function call .
			lw $t4, 4($sp)
			lw $t5, 8($sp)
			lw $t6, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20   
			
			addi $sp, $sp, -20  # storing variables in the stack segment before calling the function . 
			sw $t3, 0($sp)
			sw $t4, 4($sp)
			sw $t5, 8($sp)
			sw $t6, 12($sp)
			sw $ra, 16($sp)
			
			move $a0, $t5
			jal GetPowerOf10
			
			lw $t3, 0($sp)  # loading data that was stored in the stack segment before the function call .
			lw $t4, 4($sp)
			lw $t5, 8($sp)
			lw $t6, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20   
			
			mtc1 $v0, $f7
				
		ReturnHandler:
			cvt.s.w $f3, $f3
			cvt.s.w $f5, $f5
			cvt.s.w $f7, $f7
			
			ReturnIntegerPart:
				bgt $t5, $zero, ReturnDecimalAndIntegerPart		
				beq $t6, $zero, NoValuePassedHandler
				
				mov.s $f0, $f3
				li $v0, 1 
				
				jr $ra
				
			ReturnDecimalAndIntegerPart:
				li $v0, 1
				
				div.s $f5, $f5, $f7
				add.s $f0, $f5,$f3
				
				jr $ra
				
			NoValuePassedHandler:
				la $a0, invalid_test_result_no_value
				li $v0, 4
				syscall
				
				li $v0, 0
				jr $ra
						
	NotValidChar3:
		li $v0, 4  # promting the user that there is invalid char in the test result .
		la $a0, invalid_char_test_result
		syscall
		
		li $v0, 0  # return that the test result is invalid .
		jr $ra

GetPowerOf10:
	# you should pass the power that 10 will be raised to		
	# the number will be returned in $v0
	li $v0, 1  
	addiu $t1, $t1, 10
	
	Loop4:
		beq $a0, $zero, Exit  # if digits counter = 0 , exit loop and return .
		mul $v0, $v0, $t1  # v0 = v0 * 10
		addi $a0, $a0, -1  # digits counter -= 1
		
		j Loop4
			
	Exit:
		jr $ra

	
CreateTestByUser:
	# no input for the function . 
	# returns a pointer to the test in memeory in $v1
	# returns if the creation is valid or not in $v0
	
	li $v0, 9  # dynmically allocate a memory to store the test created by the user .
	li $a0, 20 
	syscall
	
	move $t9, $v0  # Test start address = $t9
	
	li $v0, 9  # dynmically allocate memory to read strings . 
	li $a0, 10
	syscall
	
	move $t8, $v0  # address of the read string = $t8 . 
	
	la $a0, reading_patient_id_message  # displaying a message to user (reading patient_id)						
	li $v0, 4
	syscall	
																																																																												
	move $a0, $t8  # reading patient id from the user, $t8 = input(str) . 
	li $a1, 10																																														
	li $v0, 8
	syscall
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)

	move $a0, $t8  # checking if the user input is valid or not
	jal IsValidPatientId
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	beq $v0, $zero, InvalidTestCreation
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t8  # converting input string into an integer .
	jal StringToInt 
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 
	
	sw $v0, 0($t9)  # Storing patient id in the memory allocated for test
	
	la $a0, reading_test_name  # propmting message for the user to enter the test name
	li $v0, 4
	syscall
	
	move $a0, $t8  # reading test name from user and storing it in address $t8 . 
	li $a1, 10
	li $v0, 8
	syscall
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t8  # calling function to validate and return the input name
	jal ValidateAndReturnTestName
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 
	
	beq $v0, $zero, InvalidTestCreation  # Check if the test name is not valid .
	
	sb $zero, 3($t8)  # inserting null on the end of the input string for comparison . 
	
	lw $t0, 0($t8)  # loading test name and BPT 
	la $t1, BPT_comparison
	lw $t1, 0($t1)
	
	seq $t2, $t1, $t0  # the value of $t0 indicates if the test is BPt
	
	lw $t7, 0($v1)  # Storing the test name in the memory allocated for the test .
	sw $t7, 4($t9)
	
	la $a0, reading_test_date  # prompting the user to enter the test date in the appropriate format . 
	li $v0, 4
	syscall
	
	move $a0, $t8  # reading the test date from the user as a string .
	li $a1, 10
	li $v0, 8
	syscall
	
	addi $sp, $sp, -20  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	sw $t2, 12($sp)
	sw $t6, 16($sp)
	
	move $a0, $t8  # validating and encrypting test date as an integer . 
	jal ValidateAndReturnTestDATE
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	lw $t2, 12($sp)
	lw $t6, 16($sp)
	addi $sp, $sp, 20
	
	beq $v0, $zero, InvalidTestCreation  # Check if the test name is not valid .
	
	sw $v1, 8($t9)  # stroing date in the memory allocated for test .
	
	la $a0, reading_test_result  # prompting the user to enter the test result input .
 	li $v0, 4
	syscall 
	
	move $a0, $t8  # reading the test result input from the user .
	li $a1, 10
	li $v0, 8
	syscall
	
	addi $sp, $sp, -20  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	sw $t2, 12($sp)
	sw $t6, 16($sp)
	
	move $a0, $t8  # calling function to validate test result and convert it to floating point number .
	jal ValidateAndReturnTestResult
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	lw $t2, 12($sp)
	lw $t6, 16($sp)
	addi $sp, $sp, 20
	
	beq $v0, $zero, InvalidTestCreation
	bnez $t2, TwoResultsHandler
	
	s.s $f0, 12($t9)  # storing result in memory allocated for the test .
	
	li $v0, 1  # adjusting return values then return out of the function . 
	move $v1, $t9 
	
	addi $sp, $sp, -20  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	sw $t2, 12($sp)
	sw $t6, 16($sp)
	
	move $a0, $t9  # calling function to validate test result and convert it to floating point number .
	jal IsNormalHgb
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	lw $t2, 12($sp)
	lw $t6, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra
	
	
	
	TwoResultsHandler:
		la $a0, reading_test_result  # prompting the user to enter the second test result . 
		li $v0, 4
		syscall
		
		move $a0, $t8  # reading second result from the user .
		li $a1, 10
		li $v0, 8
		syscall
		
		mov.s $f1, $f0
		
		addi $sp, $sp, -20  # saving registers in stack segment .
		sw $t8, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t2, 12($sp)
		s.s $f1, 16($sp)
		
		move $a0, $t8
		jal ValidateAndReturnTestResult
		
		lw $t8, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t2, 12($sp)
		l.s $f1, 16($sp)
		addi $sp, $sp, 20
		
		beq $v0, $zero, InvalidTestCreation  # checking if the test result is valid or not .
		c.lt.s $f1, $f0
		
		bc1t InvalidBptResult
		
		li $a0, 8  # dynamically allocating memory to store the two results of the Bpt test . 
		li $v0, 9
		syscall
		
		move $t7, $v0  # address of the allocated memory = $t7
		
		s.s $f1, 0($t7)  # storing the two result in the created memory . 
		s.s $f0, 4($t7)
		
		sw $t7, 12($t9)
		
		li $v0, 1
		move $v1, $t9
		jr $ra
		
		InvalidBptResult:
			la $a0, invalid_Bpt_test_result  # propmting the user that the entered test result is invalid . 
			li $v0, 4
			syscall
		
			li $v0, 0
			li $v1, 0
			jr $ra
		
	InvalidTestCreation:
		li $v0, 4  # printing message to the user when creation fails .
		la $a0, invalid_test_creation
		syscall 
		
		move $v0, $zero
		
		jr $ra


InsertTestIntoList:
	# pass the address of the test node in $a0
	# pass the address of the head node of the list in $a1
	# the node will be inserted in the list that head address is in $a2
	
	beq $a1, $zero, HeadIsNull  # checking if the list head is null . 
	
	beq $a0, $zero, TestNodeIsNull  # checling if the passed node is null .
	
	lw $t1, 0($a1)  # $t1 = list size .
	
	addiu $t1, $t1, 1  # incrementing size and storing it back in memory . 
	sw $t1, 0($a1)
	
	lw $t1, 4($a1)  # node -> next = head -> next . 
	sw $t1, 16($a0)
	
	sw $a0, 4($a1)  # head -> next = node .
	
	li $v0, 1
	jr $ra
	
	HeadIsNull:
		la $a0, null_list  # prompting the user that the list is null . 
		li $v0, 4
		syscall
		
		move $v0, $zero
		jr $ra
	TestNodeIsNull:
		la $a0, test_node_null  # prompting the user that the test node is null . 
		li $v0, 4
		syscall
		
		move $v0, $zero
		jr $ra
		
		
DisplayTest:
	# pass the address of the test in $a0
	
	beq $a0, $zero, TestNodeIsNull1  # checking if the passed node is null . 
	
	move $t0, $a0  # address of the test node = $t0
	move $s2, $t0
	
	lw $t9, 0($t0)  # loading the patient id from memory
	
	move $a0, $t9  # printing patient id .
	li $v0, 1
	syscall
	
	la $a0, vertical_points # printing ": " .
	li $v0, 4
	syscall
	
	addiu $a0, $t0, 4  # printing the test name  
	li $v0, 4
	syscall
	
	la $a0, comma  # printing ", " . 
 	syscall
 	
 	lw $t9, 8($t0)  # ($t9) = test date as following month + (year * 100) . 
 	
 	li $t8, 100  # dividing $t9 by 100 .
	divu $t9, $t8
	
	mflo $a0  # printing the year 
	li $v0, 1
	syscall
	
	la $a0, dash  # printing dash .
	li $v0, 4
	syscall
	
	mfhi $a0  # printing month .
	li $v0, 1
	syscall
	
	la $a0, comma  # printing ", " . 
	li $v0, 4
	syscall
	
	la $s2, BPT_comparison
	lw $t8, 0($s2)
	lw $t9, 4($t0)  # checking if the test is bpt .
	
	beq $t9, $t8, TwoResultsHandler1
	
	l.s $f12, 12($t0)  # printing the single test result
	li $v0, 2
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	li $v0, 1 
	
	jr $ra
	
	TwoResultsHandler1:
		lw $t4, 12($t0)  # loading the address of the result .
		
		l.s $f12, 0($t4)  # printing the first part of the result .
		li $v0, 2
		syscall
		
		la $a0, slash  # printing "/" . 
		li $v0, 4
		syscall
		
		l.s $f12, 4($t4)  # printing the second part result .
		li $v0, 2
		syscall
		
		la $a0, endl  # printing the end of the line .
		li $v0, 4
		syscall
	
		li $v0, 1  # status code = 1 .
	
		jr $ra
		
	TestNodeIsNull1:
		la $a0, test_node_null  # prompting the user that the test node is null . 
		li $v0, 4
		syscall
		
		move $v0, $zero
		jr $ra
		

DisplayListOfTests:
	# you should pass the address of the list head node in $a0 .
	
	move $t0, $zero  # test counter initialized to zero .
	move $t9, $a0
	
	lw $t1, 0($a0)  # $t1 = size of the list .   
	
	lw $t2, 4($a0)  # $t2 = head -> next, will be used as a pointer to traverse the list .  
	
	la $a0, list_header
	li $v0, 4
	syscall
	
	Loop5:
		ble $t1, $zero, ExitLoop5
		
		addiu $t0, $t0, 1  # printing the test number and incrementing it .
		move $a0, $t0
		li $v0, 1
		syscall
		
		la $a0, dash  # printing "-"
		li $v0, 4
		syscall
		
		addi $sp, $sp, -16  # saving register in stack segment .
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $ra, 12($sp)
		
		move $a0, $t2  # displatying test . 
		jal DisplayTest
		
		lw $t0, 0($sp)  # loading reigters saved in stack segment . 
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16

		addi $t1, $t1, -1  # decrementing size . 
		
		lw $t2, 16($t2)  # pointer = pointer -> next
		
		j Loop5
		
	ExitLoop5:
		jr $ra
		

DeleteTests:
	# pass the address of the list in $a0
	# the user will choose the index of the test that will be deleted . 
	
	move $t0, $a0  # $t0 = address of the list head
	 
	beq $a0, $zero, NullPointer  # checking if the passed list is null . 
	
	lw $t8, 0($t0)  # $t8 = size of the list . 
	beq $t8, $zero, EmptyList1
			
	addi $sp, $sp, -12  # saving the return address before calling a nested function .
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t8, 8($sp)
	 
	jal DisplayListOfTests  
	
	lw $ra, 0($sp)  # loading saved register frem stack segment .
	lw $t0, 4($sp)
	lw $t8, 8($sp)
	addi $sp, $sp, 12
			
	la $a0, delete_input_message  # rompting the user to enter the index of the test he want to delete .
	li $v0, 4
	syscall
	
	li $v0, 5  # reading integer from the user . 
	syscall
	
	move $t9, $v0  # t9 = input
	
	blt $t9, 0, InvalidIndex  # checking if the index passed by user is valid . 
	bgt $t9, $t8, InvalidIndex
	
	li $t5, 1  # initializing the counter to zero . 
	move $t6, $t0  # pointer1 = head of the list .
	lw $t7, 4($t0)  # pointer2 = the first test .
	
	Loop6:
		beq $t5, $t9, Delete  # checking if the index equal the counter .
		
		addiu $t5, $t5, 1  # incrementing counter .
		
		lw $t7, 16($t7)  # pointer = pointer -> next .
		
		j Loop6
		
	Delete: 
		beq $t5, 1, DeleteFirstCase  # checking if the test to be deleted is the first test . 
		
		lw $t4, 16($t7)  # pointer1 -> next = pointer2 -> next
		sw $t4, 16($t6)
		
		sw $zero, 0($t7) # cleaning the test node . 
		sw $zero, 4($t7)
		sw $zero, 8($t7)
		sw $zero, 12($t7)
		sw $zero, 16($t7)
		
		la $a0, successful_deletion  # prompting the user that deletion was successful. 
		li $v0, 4
		syscall 
		
		lw $t1, 0($t0)  # incrementing the list size . 
		addi $t1, $t1, -1
		sw $t1, 0($t0)
		
		jr $ra
	
	DeleteFirstCase:
		lw $t4, 16($t7)  # pointer1 -> next = pointer2 -> next
		sw $t4, 4($t6)
		
		sw $zero, 0($t7) # cleaning the test node . 
		sw $zero, 4($t7)
		sw $zero, 8($t7)
		sw $zero, 12($t7)
		sw $zero, 16($t7)
		
		la $a0, successful_deletion  # prompting the user that the test was deleted successfully .
		li $v0, 4
		syscall 
		
		lw $t1, 0($t0)
		addi $t1, $t1, -1
		sw $t1, 0($t0)
		
		jr $ra
	
	InvalidIndex:
		la $a0,	invalid_index  # prompting the user that the index is invalid . 
		li $v0, 4
		syscall 
		
		jr $ra
		
	EmptyList1:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		jr $ra
		
	NullPointer:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		jr $ra
	
	
UpdateTest:
	# pass the address of the list you want to update in $a0 .
	
	move $t0, $a0  # $t0 = address of the list head
	
	beq $a0, $zero, NullPointer  # checking if the passed list is null . 	
	
	lw $t8, 0($t0)  # $t8 = size of the list . 
	beq $t8, $zero, EmptyList1
	
	addi $sp, $sp, -12  # saving the return address before calling a nested function .
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t8, 8($sp)
	
	jal DisplayListOfTests
	
	lw $ra, 0($sp)  # loading saved register frem stack segment .
	lw $t0, 4($sp)
	lw $t8, 8($sp)
	addi $sp, $sp, 12
	
	la $a0, update_input_message  # rompting the user to enter the index of the test he want to update .
	li $v0, 4
	syscall
	
	li $v0, 5  # reading integer from the user . 
	syscall
	
	move $t9, $v0
	
	blt $t9, 0, InvalidIndex  # checking if the index passed by user is valid . 
	bgt $t9, $t8, InvalidIndex
	
	li $t5, 1  # initializing the counter to zero . 
	lw $t7, 4($t0)  # pointer = first node of the list 
	
	Loop7:
		beq $t5, $t9, Update  # checking if the index equal the counter .
		
		addiu $t5, $t5, 1  # incrementing counter .
		
		lw $t7, 16($t7)  # pointer = pointer -> next .
		
		j Loop7
	
	Update:
		addi $sp, $sp, -16  # saving register in memeory .
		sw $t9, 0($sp)
		sw $t8, 4($sp)
		sw $ra, 8($sp)
		sw $t7, 12($sp)
	
		move $a0, $t7  # displaying test .
		jal DisplayTest
		
		lw $t9, 0($sp)  # loading registers from memeory .
		lw $t8, 4($sp)
		lw $ra, 8($sp)
		lw $t7, 12($sp)
		addi $sp, $sp, 16
	
		la $a0, update_menu  # displaying the update menu for the user .
		li $v0, 4
		syscall
		
		li $v0, 5  # read the user choice .
		syscall
		
		move $t9, $v0  # ($t9) = user choice . 
		
		bgt $t9, 5, InvalidUpdateChoice
		ble $t9, 0, InvalidUpdateChoice
		
		beq $t9, 1, UpdatePatientId
		beq $t9, 2, UpdateTestName
		beq $t9, 3, UpdateDate
		beq $t9, 4, UpdateResult	
		beq $t9, 5, ExitUpdate
		j InvalidUpdateChoice
		
		UpdatePatientId:
			li $v0, 9  # dynmically allocate a memory to store the test created by the user .
			li $a0, 20 
			syscall
			
			move $t6, $v0  # $t6 = address of the dynamically allocated memeory . 
			
			la $a0, reading_patient_id_message  # displaying a message to user (reading patient_id)						
			li $v0, 4
			syscall	
																																																																												
			move $a0, $t6  # reading patient id from the user, $t8 = input(str) . 
			li $a1, 10																																														
			li $v0, 8
			syscall
	
			addi $sp, $sp, -20  # saving register in memeory .
			sw $t9, 0($sp)
			sw $t8, 4($sp)
			sw $ra, 8($sp)
			sw $t7, 12($sp)
			sw $t6, 16($sp)

			move $a0, $t6  # checking if the user input is valid or not
			jal IsValidPatientId
	
			lw $t9, 0($sp)  # loading registers from memory . 
			lw $t8, 4($sp)
			lw $ra, 8($sp)
			lw $t7, 12($sp)
			lw $t6, 16($sp)
			addi $sp, $sp, 20
			
			beq $v0, $zero, InvalidUpdateAttempt  # checking if the patienr id entered by the user is valid or not . 
			
			addi $sp, $sp, -20  # saving register in memeory .
			sw $t9, 0($sp)
			sw $t8, 4($sp)
			sw $ra, 8($sp)
			sw $t7, 12($sp)
			sw $t6, 16($sp)
			
			move $a0, $t6  # converting input string into an integer .
			jal StringToInt
			
			lw $t9, 0($sp)  # loading registers from memory . 
			lw $t8, 4($sp)
			lw $ra, 8($sp)
			lw $t7, 12($sp)
			lw $t6, 16($sp)
			addi $sp, $sp, 20  
			
			sw $v0, 0($t7)  # storing the user
			
			j Update
			
		UpdateTestName:
			li $v0, 9  # dynmically allocate a memory to store the test created by the user .
			li $a0, 20 
			syscall
			
			lw $t0, 4($t7)  # loading test name and BPT 
			la $t1, BPT_comparison
			lw $t1, 0($t1)
		
			seq $s5, $t0, $t1  # checking if were changing from Bpt to something else
			
			move $t6, $v0  # $t6 = address of the dynamically allocated memeory . 
		
			la $a0, reading_test_name  # propmting message for the user to enter the test name
			li $v0, 4
			syscall
	
			move $a0, $t6  # reading test name from user and storing it in address $t8 . 
			li $a1, 10
			li $v0, 8
			syscall
	
			addi $sp, $sp, -20  # saving register in memeory .
			sw $t9, 0($sp)
			sw $t8, 4($sp)
			sw $ra, 8($sp)
			sw $t7, 12($sp)
			sw $t6, 16($sp)
	
			move $a0, $t6  # calling function to validate and return the input name
			jal ValidateAndReturnTestName
	
			lw $t9, 0($sp)  # loading registers from memory . 
			lw $t8, 4($sp)
			lw $ra, 8($sp)
			lw $t7, 12($sp)
			lw $t6, 16($sp)
			addi $sp, $sp, 20  
	
			beq $v0, $zero, InvalidUpdateAttempt  # Check if the test name is not valid .
	
			sb $zero, 3($t6)  # inserting null on the end of the input string for comparison . 
	
			lw $t0, 0($t6)  # loading test name and BPT 
			la $t1, BPT_comparison
			lw $t1, 0($t1)
	
			seq $s7, $t1, $t0  # the value of $t0 indicates if the test is BPt
	
			lw $t4, 0($v1)  # Storing the test name in the memory allocated for the test .
			sw $t4, 4($t7)
			
			
			beq $s7, 1, UpdateResult
			beq $s5, 1, UpdateResult
			
			j Update
			
		UpdateDate:
			li $v0, 9  # dynmically allocate a memory to store the test created by the user .
			li $a0, 20 
			syscall
			
			move $t6, $v0  # $t6 = address of the dynamically allocated memeory . 
			
			la $a0, reading_test_date  # prompting the user to enter the test date in the appropriate format . 
			li $v0, 4
			syscall
	
			move $a0, $t6  # reading the test date from the user as a string .
			li $a1, 10
			li $v0, 8
			syscall
	
			addi $sp, $sp, -20  # saving register in memeory .
			sw $t9, 0($sp)
			sw $t8, 4($sp)
			sw $ra, 8($sp)
			sw $t7, 12($sp)
			sw $t6, 16($sp)
	
			move $a0, $t6  # validating and encrypting test date as an integer . 
			jal ValidateAndReturnTestDATE
	
			lw $t9, 0($sp)  # loading registers from memory . 
			lw $t8, 4($sp)
			lw $ra, 8($sp)
			lw $t7, 12($sp)
			lw $t6, 16($sp)
			addi $sp, $sp, 20 
	
			beq $v0, $zero, InvalidUpdateAttempt  # Check if the test name is not valid .
	
			sw $v1, 8($t7)  # stroing date in the memory allocated for test .
			
			j Update
			
		UpdateResult:
			li $v0, 9  # dynmically allocate a memory to store the test created by the user .
			li $a0, 20 
			syscall
			
			move $s6, $v0  # $t6 = address of the dynamically allocated memeory . 
		
			la $a0, reading_test_result  # prompting the user to enter the test result input .
 			li $v0, 4
			syscall 
	
			move $a0, $s6  # reading the test result input from the user .
			li $a1, 10
			li $v0, 8
			syscall
	
			addi $sp, $sp, -28  # saving registers in stack segment .
			sw $t8, 0($sp)
			sw $t9, 4($sp)
			sw $ra, 8($sp)
			sw $t2, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $s6, 24($sp)
	
			move $a0, $s6  # calling function to validate test result and convert it to floating point number .
			jal ValidateAndReturnTestResult
	
			lw $t8, 0($sp)  # loading registers from stack segment . 
			lw $t9, 4($sp)
			lw $ra, 8($sp)
			lw $t2, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $s6, 24($sp)
			addi $sp, $sp, 28
			
			lw $t0, 4($t7)  # loading test name and BPT 
			la $t1, BPT_comparison
			lw $t1, 0($t1)
		
			seq $s5, $t0, $t1  # checking if were changing from Bpt to something else
			
			beq $v0, $zero, InvalidUpdateAttempt
			bnez $s7, TwoResultsHandler2
			bnez $s5, TwoResultsHandler2
	
			s.s $f0, 12($t7)  # storing result in memory allocated for the test .
			move $s5, $zero
			
			j Update
			
	
			TwoResultsHandler2:
				la $a0, reading_test_result  # prompting the user to enter the second test result . 
				li $v0, 4
				syscall
		
				move $a0, $s6  # reading second result from the user .
				li $a1, 10
				li $v0, 8
				syscall
		
				mov.s $f1, $f0
		
				addi $sp, $sp, -20  # saving registers in stack segment .
				sw $t8, 0($sp)
				sw $t9, 4($sp)
				sw $ra, 8($sp)
				sw $t2, 12($sp)
				s.s $f1, 16($sp)
		
				move $a0, $s6
				jal ValidateAndReturnTestResult
		
				lw $t8, 0($sp)  # loading registers from stack segment . 
				lw $t9, 4($sp)
				lw $ra, 8($sp)
				lw $t2, 12($sp)
				l.s $f1, 16($sp)
				addi $sp, $sp, 20
		
				beq $v0, $zero, InvalidUpdateAttempt  # checking if the test result is valid or not .
				c.lt.s $f1, $f0
		
				bc1t InvalidBptResult2
		
				li $a0, 8  # dynamically allocating memory to store the two results of the Bpt test . 
				li $v0, 9
				syscall
		
				move $t3, $v0  # address of the allocated memory = $t7
		
				s.s $f1, 0($t3)  # storing the two result in the created memory . 
				s.s $f0, 4($t3)
		
				sw $t3, 12($t7)
				move $s7, $zero
				
				j Update 
		
				InvalidBptResult2:
					la $a0, invalid_Bpt_test_result  # propmting the user that the entered test result is invalid . 
					li $v0, 4
					syscall
		
					j InvalidUpdateAttempt
			
			
		ExitUpdate:
			jr $ra
	
	InvalidUpdateAttempt:
		la $a0, invalid_update_attempt
		li $v0, 4
		syscall
		
		jr $ra	
				
	InvalidUpdateChoice:
		la $a0, invalid_update_choice
		li $v0, 4
		syscall										
		
		jr $ra
																																																																																																																		
	InvalidIndex1:
		la $a0,	invalid_index  # prompting the user that the index is invalid . 
		li $v0, 4
		syscall 
		
		jr $ra
		
	EmptyList2:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		jr $ra
		
	NullPointer1:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		jr $ra
		
		
RetrivePatientTests:
	# pass the address of the address of the original list in $a0 .
	# pass the patient id in $a1 .
	# returns $v0 equal to zero when the list is empty . 
	# returns the address of patient tests list in $v1 .  
	
	move $s0, $s1  # move the list to create a new list . 
	move $s1, $zero  # making sure the register value is null .
	
	beq $a0, $zero, NullPointer2  # checking if the passed list head is null . 
	
	lw $t0, 0($a0)  # checking if the list is empty .
	beq $t0, $zero, EmptyList3
	
	move $t6, $a0  # $t6 = head of the list of test . 
	move $t7, $a1  # $t7 = passed patient id .
	
	addi $sp, $sp, -16  # saving the registers in memory . 
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	sw $t7, 8($sp)
	sw $t0, 12($sp)  
	
	jal CreateTestsList  # creating a list, $s1 = head of the list . 
	
	lw $ra, 0($sp)  # loading saved registers from memory . 
	lw $t6, 4($sp)
	lw $t7, 8($sp)    
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	
	move $t5, $s1  # $t5: address of the head of the newly created list . 
	move $s1, $s0 
	
	lw $t9, 4($s1)  # $t9 = pointer to the first of the list . 
	
	li $t8, 1  # initializing counter to zero
	
	Loop8:
		lw $t4, 0($t9)  # loading the patient id of the test and checking if it equals the passed one . 
		beq $t4, $t7, AddTestToList
		
		beq $t8, $t0, ExitLoop8  # checking if the size is equal to the counter . 
		
		addiu $t8, $t8, 1  # incrementing the oounter .
		    
		lw $t9, 16($t9)  # pointer = pointer -> next . 
		
		j Loop8
		
		AddTestToList:
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $t9  # inserting test into the new list . 
			jal CopyTest
			
			move $s7, $v0
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
		
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $s7  # inserting test into the new list . 
			move $a1, $t5
			jal InsertTestIntoList
			
			move $s7, $zero 
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
			
			beq $t8, $t0, ExitLoop8  # checking if the size is equal to the counter . 
		
			addiu $t8, $t8, 1  # incrementing the oounter .
		    
			lw $t9, 16($t9)  # pointer = pointer -> next . 
		
			j Loop8
			
	ExitLoop8:
		li $v0, 1
		move $v1, $t5
		
		jr $ra
		
	EmptyList3:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		move $v0, $zero
		
		jr $ra
		
		
	NullPointer2:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		jr $ra

	
IsNormalHgb:
	# pass the address of the address of the node in $a0
	# returns if valid or not in $v0 
	
	l.s $f1, 12($a0)  # $t9 = result of the test . 
	
	l.s $f3, hgb_upper_bound # checking if the result is less than 13.8 and updating the flag. 
	c.lt.s $f3, $f1
	
	bc1t UnNormalResult
	
	l.s $f3, hgb_lower_bound  # checking if the result is greater than 17.2 and updating the flag . 
	c.lt.s $f1, $f3
	
	bc1t UnNormalResult
	
	li $v0, 1  # result is normal return 1 . 
	jr $ra
	
	UnNormalResult:
		li $v0, 0  # result is not normal return 0 . 
		jr $ra


IsNormalBGT:
	# pass the address of the address of the node in $a0
	# returns if valid or not in $v0 
	
	l.s $f1, 12($a0)  # $t9 = result of the test . 
	
	l.s $f3, BGT_upper_bound # checking if the result is less than 13.8 and updating the flag. 
	c.lt.s $f3, $f1
	
	bc1t UnNormalResult
	
	l.s $f3, BGT_lower_bound  # checking if the result is greater than 17.2 and updating the flag . 
	c.lt.s $f1, $f3
	
	bc1t UnNormalResult1
	
	li $v0, 1  # result is normal return 1 . 
	jr $ra
	
	UnNormalResult1:
		li $v0, 0  # result is not normal return 0 . 
		jr $ra


IsNormalLDL:
	# pass the address of the address of the node in $a0
	# returns if valid or not in $v0 
	
	l.s $f1, 12($a0)  # $t9 = result of the test . 
	
	l.s $f3, LDL_upper_bound # checking if the result is less than 13.8 and updating the flag. 
	c.lt.s $f3, $f1 
	
	bc1t UnNormalResult2
	
	li $v0, 1  # result is normal return 1 . 
	jr $ra
	
	UnNormalResult2:
		li $v0, 0  # result is not normal return 0 . 
		jr $ra	
		

IsNormalBPT:
	# pass the address of the node in $a0
	# returns if the result is valid or not in $v0
	
	lw $t9, 12($a0)  # $t9 = address of the result ,
	
	l.s $f1, 0($t9)  # $t9 = result of the test . 
	
	l.s $f3, Bpt_systolic_upper_bound # checking if the result is less than 13.8 and updating the flag. 
	c.lt.s $f3, $f1
	
	bc1t UnNormalResult3
	
	l.s $f1, 4($t9)  # $t9 = result of the test . 
	
	l.s $f3, Bpt_Diastolic_upper_bound # checking if the result is less than 13.8 and updating the flag. 
	c.lt.s $f3, $f1
	
	bc1t UnNormalResult3
	
	li $v0, 1  # result is normal return 1 . 
	jr $ra 
	
	UnNormalResult3:
		li $v0, 0  # result is not normal return 0 . 
		jr $ra
		
		
IsNormalTest:
	# pass the address of the test node in $a0
	# returns if the test is valid or not in $v0
	
	lw $t9, 4($a0)  # $t9 = name of the test .
	
	la $t7, Hgb_comparison  # checking if the test is hgb
	lw $t8, 0($t7)
	beq $t8, $t9, IsNormalHgbTest
	
	la $t7, BGT_comparison  # checking if the test is hgb
	lw $t8, 0($t7)
	beq $t8, $t9, IsNormalBGTTest
	
	la $t7, LDL_comparison  # checking if the test is hgb
	lw $t8, 0($t7)
	beq $t8, $t9, IsNormalLDLTest
	
	la $t7, BPT_comparison  # checking if the test is hgb
	lw $t8, 0($t7)
	beq $t8, $t9, IsNormalBPTTest
	
	jr $ra
	
	IsNormalHgbTest:
		addi $sp, $sp, -4  # saving return address in stack segment . 
		sw $ra, 0($sp)

		jal IsNormalHgb 
		
		lw $ra, 0($sp)  # loading return address in memory . 
		addi $sp, $sp, 4	
		
		jr $ra
		
		
	IsNormalBGTTest:
		addi $sp, $sp, -4   # saving return address in stack segment . 
		sw $ra, 0($sp)
		
		jal IsNormalBGT
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4  # loading return address in memory . 	
		
		jr $ra
	
	
	IsNormalLDLTest:
		addi $sp, $sp, -4   # saving return address in stack segment . 
		sw $ra, 0($sp)
		
		jal IsNormalLDL
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4  # loading return address in memory . 		
		
		jr $ra
	
	IsNormalBPTTest:
		addi $sp, $sp, -4   # saving return address in stack segment . 
		sw $ra, 0($sp)

		jal IsNormalBPT
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4  # loading return address in memory . 		
		
		jr $ra
		
	
RetriveTestsByMedicalTest:
	# pass the address of the address of the original list in $a0 .
	# pass the medical test name in $a1 .
	# returns the address of patient tests list in $v1 .  
	
	move $s0, $s1  # move the list to create a new list . 
	move $s1, $zero  # making sure the register value is null .
	
	beq $a0, $zero, NullPointer3  # checking if the passed list head is null . 
	
	lw $t0, 0($a0)  # checking if the list is empty .
	beq $t0, $zero, EmptyList4
	
	move $t6, $a0  # $t6 = head of the list of test . 
	move $t7, $a1  # $t7 = passed test name .
	
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t4, 8($sp)
	sw $t5, 12($sp)
	sw $t6, 16($sp)
	sw $t7, 20($sp)
	sw $t8, 24($sp)
	sw $t9, 28($sp) 
	
	jal CreateTestsList  # creating a list, $s1 = head of the list . 
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t4, 8($sp)
	lw $t5, 12($sp)
	lw $t6, 16($sp)
	lw $t7, 20($sp)
	lw $t8, 24($sp)
	lw $t9, 28($sp)
	addi $sp, $sp, 32
	
	move $t5, $s1  # $t5: address of the head of the newly created list . 
	move $s1, $s0 
	
	lw $t9, 4($s0)  # $t9 = pointer to the first of the list . 
	
	li $t8, 1  # initializing counter to zero
	
	Loop9:
		lw $t4, 4($t9)  # loading the test name of the test and checking if it equals the passed one . 
		beq $t4, $t7, AddTestToList1
		
		beq $t8, $t0, ExitLoop9  # checking if the size is equal to the counter . 
		
		addiu $t8, $t8, 1  # incrementing the oounter .
		    
		lw $t9, 16($t9)  # pointer = pointer -> next . 
		
		j Loop9
		
		AddTestToList1:
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $t9  # inserting test into the new list . 
			jal CopyTest
			
			move $s7, $v0
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
		
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $s7  # inserting test into the new list . 
			move $a1, $t5
			jal InsertTestIntoList
			
			move $s7, $zero 
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
			
			beq $t8, $t0, ExitLoop9  # checking if the size is equal to the counter . 
		
			addiu $t8, $t8, 1  # incrementing the oounter .
		    
			lw $t9, 16($t9)  # pointer = pointer -> next . 
		
			j Loop9
			
	ExitLoop9:
		li $v0, 1
		move $v1, $t5
		
		jr $ra
		
	EmptyList4:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		move $v0, $zero
		
		jr $ra
		
		
	NullPointer3:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		jr $ra
		
		
RetriveUpNormalTests:
	# pass the address of the list in $a0 .
	# returns the address of the list of upnormal test in $v0
	move $s0, $s1  # move the list to create a new list . 
	move $s1, $zero  # making sure the register value is null .
	
	beq $a0, $zero, NullPointer4  # checking if the passed list head is null . 
	
	lw $t0, 0($a0)  # checking if the list is empty .
	beq $t0, $zero, EmptyList5
	
	move $t6, $a0  # $t6 = head of the list of test . 
	
	addi $sp, $sp, -16  # saving the registers in memory . 
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	sw $t7, 8($sp)
	sw $t0, 12($sp)  
	
	jal CreateTestsList  # creating a list, $s1 = head of the list . 
	
	lw $ra, 0($sp)  # loading saved registers from memory . 
	lw $t6, 4($sp)
	lw $t7, 8($sp)    
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	
	move $t5, $s1  # $t5: address of the head of the newly created list . 
	move $s1, $s0 
	
	lw $t9, 4($s7)  # $t9 = pointer to the first of the list . 
	
	li $t8, 1  # initializing counter to zero
	
	Loop10:
		addi $sp, $sp, -32  # saving register in stack segment before function call
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		sw $t4, 8($sp)
		sw $t5, 12($sp)
		sw $t6, 16($sp)
		sw $t7, 20($sp)
		sw $t8, 24($sp)
		sw $t9, 28($sp)
		
		move $a0, $t9  # calling the function to check if the test is upnormal or not . 
		jal IsNormalTest
		
		lw $ra, 0($sp)  # loading the registers save in memory before function call . 
		lw $t0, 4($sp)
		lw $t4, 8($sp)
		lw $t5, 12($sp)
		lw $t6, 16($sp)
		lw $t7, 20($sp)
		lw $t8, 24($sp)
		lw $t9, 28($sp)
		addi $sp, $sp, 32
		
		beq $v0, $zero, AddTestToList2  # checking if the test is normal or not based on the exit code . 
		
		beq $t8, $t0, ExitLoop10  # checking if the size is equal to the counter . 
		
		addiu $t8, $t8, 1  # incrementing the oounter .
		    
		lw $t9, 16($t9)  # pointer = pointer -> next . 
		
		j Loop10
		
		AddTestToList2:
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $t9  # inserting test into the new list . 
			jal CopyTest
			
			move $s7, $v0
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
		
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $s7  # inserting test into the new list . 
			move $a1, $t5
			jal InsertTestIntoList
			
			move $s7, $zero 
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
			
			beq $t8, $t0, ExitLoop10  # checking if the size is equal to the counter . 
		
			addiu $t8, $t8, 1  # incrementing the oounter .
		    
			lw $t9, 16($t9)  # pointer = pointer -> next . 
		
			j Loop10
			
			
	ExitLoop10:
		li $v0, 1
		move $v1, $t5
		
		jr $ra
		
	EmptyList5:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		move $v0, $zero
		
		jr $ra
		
		
	NullPointer4:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		jr $ra


GetAverageTestResult:
	# pass the address of the list in $a0
	# pass 1 in $a1 if the passed list is bpt list 
	# return the average in $f0 if bpt (systolic average)
	# return the average of the seconde part of the result in $f1 if their is a second part . 
	# returns zero in $v0 there was an error . 
	
	move $t4, $a1  # indicated if the list is bpt list . 
	
	move $s5, $s1  # move the list to create a new list . 
	move $s1, $zero  # making sure the register value is null .
	
	beq $a0, $zero, NullPointer5  # checking if the passed list head is null . 
	
	lw $t0, 0($a0)  # checking if the list is empty .
	beq $t0, $zero, EmptyList6
	
	move $t6, $a0  # $t6 = head of the list of test . 
	
	addi $sp, $sp, -16  # saving the registers in memory . 
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	sw $t7, 8($sp)
	sw $t0, 12($sp)  
	
	jal CreateTestsList  # creating a list, $s1 = head of the list . 
	
	lw $ra, 0($sp)  # loading saved registers from memory . 
	lw $t6, 4($sp)
	lw $t7, 8($sp)    
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	
	move $t5, $s1  # $t5: address of the head of the newly created list . 
	move $s1, $s5 
	
	lw $t9, 4($s0)  # $t9 = pointer to the first of the list . 
	
	li $t8, 1  # initializing counter to zero . 
	
	li $t3, 0  #  $f4 = 0 . 
	mtc1 $t3, $f4
	cvt.s.w $f4, $f4 
	
	li $t3, 1  #  $f5 = 1.0 . 
	mtc1 $t3, $f5
	cvt.s.w $f5, $f5 
	
	move $t3, $t0  # $f6 = size of the list . 
	mtc1 $t3, $f6
	cvt.s.w $f6, $f6 
	
	div.s $f5, $f5, $f6  # $f5 = $f5 / size . 
	
	li $t3, 0  #  $f1 = 0 . 
	mtc1 $t3, $f1
	cvt.s.w $f1, $f1 
	
	li $t3, 0  #  $f0 = 0 . 
	mtc1 $t3, $f0
	cvt.s.w $f0, $f0
	
	Loop11:
		beq $t4, 1, BptAverageHandler  # checking if the test is bpt or not . 
		
		l.s $f4, 12($t9)  # $f0 += result of the test * ( test share in the average) . 
		mul.s $f4, $f4, $f5
		add.s $f0, $f0, $f4
		
		j Skip1
		
		BptAverageHandler:
			lw $s6, 12($t9)  # $t2 = address of the result . 
			
			l.s $f4, 0($s6)  # $f0 += result of the test * ( test share in the average) . 
			mul.s $f4, $f4, $f5
			add.s $f0, $f0, $f4
			
			l.s $f4, 4($s6)  # $f1 += result of the test * ( test share in the average) . 
			mul.s $f4, $f4, $f5
			add.s $f1, $f1, $f4
			
			move $s6, $zero
		Skip1:
		
		beq $t8, $t0, ExitLoop11  # checking if the size is equal to the counter . 
		
		addiu $t8, $t8, 1  # incrementing the oounter .
		    
		lw $t9, 16($t9)  # pointer = pointer -> next . 
		
		j Loop11
			
	ExitLoop11:
		li $v0, 1
		move $v1, $t5
		
		move $v0, $zero 
		
		jr $ra
		
	EmptyList6:
		la $a0, empty_list1  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		move $v0, $zero
		
		jr $ra
		
		
	NullPointer5:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		move $v0, $zero
		
		jr $ra


AverageTestValueForMedicalTests:
	# pass the address of the list in $a0
	# the average value for each test will be printed on the screen .
	
	move $t9, $a0  # $t9 = address of the test lists .
	
	la $a0, Hgb_average  # printing the message of the average .
	li $v0, 4
	syscall
	
	la $a1, Hgb_comparison  # adjusting function arguments . 
	lw $a1, 0($a1)
	move $a0, $t9
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal RetriveTestsByMedicalTest  # getting the list of the specific medical test type .
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	
	lw $t0, 0($v1)
	beq $t0, $zero, SkipAverage1
	
	move $a0, $v1  # $a0 = address of hgb tests list 
	move $a1, $zero  	  	
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal GetAverageTestResult  # calling the function to determing the average of the list
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	  	  	  	
	mov.s $f12, $f0  # printing the average . 
	li $v0, 2
	syscall
	
	la $a0, Hgb_unit
	li $v0, 4
	syscall
	
	SkipAverage1:  	  	  	
	
	la $a0, BGT_average  # printing the message of the average .
	li $v0, 4
	syscall
	
	la $a1, BGT_comparison  # adjusting function arguments . 
	lw $a1, 0($a1)
	move $a0, $t9
	
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal RetriveTestsByMedicalTest  # getting the list of the specific medical test type .
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	
	lw $t0, 0($v1)
	beq $t0, $zero, SkipAverage2
	
	move $a0, $v1  # $a0 = address of bgt tests list 
	move $a1, $zero  	  	
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal GetAverageTestResult  # calling the function to determing the average of the list
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	  	  	
	mov.s $f12, $f0  # printing the average . 
	li $v0, 2
	syscall
	
	la $a0, BGT_unit
	li $v0, 4
	syscall
	
	SkipAverage2:
	
	la $a0, LDL_average  # printing the message of the average .
	li $v0, 4
	syscall
	
	la $a1, LDL_comparison  # adjusting function arguments . 
	lw $a1, 0($a1)
	move $a0, $t9
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal RetriveTestsByMedicalTest  # getting the list of the specific medical test type .
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	
	lw $t0, 0($v1)
	beq $t0, $zero, SkipAverage3
	
	move $a0, $v1  # $a0 = address of ldl tests list 
	move $a1, $zero  	  	
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal GetAverageTestResult  # calling the function to determing the average of the list
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	  	  	
	mov.s $f12, $f0  # printing the average . 
	li $v0, 2
	syscall
	
	la $a0, LDL_unit
	li $v0, 4
	syscall
	
	SkipAverage3:
	
	la $a0, BPT_average  # printing the message of the average .
	li $v0, 4
	syscall
	
	la $a1, BPT_comparison  # adjusting function arguments . 
	lw $a1, 0($a1)
	move $a0, $t9
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal RetriveTestsByMedicalTest  # getting the list of the specific medical test type .
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	
	lw $t0, 0($v1)
	beq $t0, $zero, SkipAverage4
	
	move $a0, $v1  # $a0 = address of bpt tests list 
	li $a1, 1  	  	
	
	addi $sp, $sp, -8  # storing registers in stack segment befote function call . 
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	jal GetAverageTestResult  # calling the function to determing the average of the list
	
	lw $ra, 0($sp)  # loading registers from stsack segment . 
	lw $t9, 4($sp)
	addi $sp, $sp, 8
	  	  	
	mov.s $f12, $f0  # printing the average . 
	li $v0, 2
	syscall
	
	la $a0, slash  # printing "/"
	li $v0, 4
	syscall
	
	mov.s $f12, $f1  # printing second result .
	li $v0, 2
	syscall
	
	la $a0, BPT_unit  # printing the unit of the test result .
	li $v0, 4
	syscall  	 	  	  	  	  	 	  	  	  	
		
	SkipAverage4:
	
	jr $ra
	
	
CopyTest:
	# pass the address of the test node you want to copy in $a0 .
	
	move $t0, $a0  # $t0 = address of the node we want to copy . 
	
	li $a0, 20  # dynamically allocate memory for the copy node . 
	li $v0, 9
	syscall
	
	move $t2, $v0  # $t2 = address of the new node . 
	
	lw $t1, 0($t0)  # copying data of the test .
	sw $t1, 0($t2)
	
	lw $t1, 4($t0)
	sw $t1, 4($t2)
	
	lw $t1, 8($t0)
	sw $t1, 8($t2)
	
	la $t4, BPT_comparison
	lw $t4, 0($t4) 
	
	lw $t3, 4($t0)
	
	beq $t4, $t3, BptCopyHandler
	
	l.s $f9, 12($t0)
	s.s $f9, 12($t2)
	
	j SkipBptCopyHandler
	
	BptCopyHandler:
		lw $t1, 12($t0)
		sw $t1, 12($t2)
	
	SkipBptCopyHandler:		
		move $v0, $t2
		jr $ra
		
	
SearchForUnnormalTest:
	# pass the address the address of the tests list in $a0
	# it will print unormla list passed on the user input medical test . 
	
	move $t7, $a0  # $t7 = address of the passed list of tests . 	
				
	li $v0, 9  # dynmically allocate memory to read strings . 
	li $a0, 10
	syscall
	
	move $t8, $v0  # address of the read string = $t8 . 
	
	la $a0, reading_test_name  # propmting message for the user to enter the test name
	li $v0, 4
	syscall
	
	move $a0, $t8  # reading test name from user and storing it in address $t8 . 
	li $a1, 10
	li $v0, 8
	syscall
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t8  # calling function to validate and return the input name
	jal ValidateAndReturnTestName
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 
	
	beq $v0, $zero, InvalidInput1  # Check if the test name is not valid .
	
	sb $zero, 3($t8)  # inserting null on the end of the input string for comparison . 
	
	lw $t0, 0($t8)  # loading test name and BPT 
	la $t1, BPT_comparison
	lw $t1, 0($t1)
	
	move $t2, $zero
	seq $t2, $t1, $t0  # the value of $t0 indicates if the test is BPt
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t7  # adjusting the arguments of the function . 
	move $a1, $v1
	lw $a1, 0($a1)
	
	move $v1, $zero
	jal RetriveTestsByMedicalTest
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	beq $v1, $zero, ThereIsNoList  # checking if there is not test of the same type passed by user . 
	
	move $t6, $v1  # $t1 = address of the list of test of the passed type . 
	
	addi $sp, $sp, -16  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	sw $t6, 12($sp)
	
	move $a0, $t6
	jal RetriveUpNormalTests
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	lw $t6, 12($sp)
	addi $sp, $sp, 12
	
	addi $sp, $sp, -16  # saving registers in stack segment .
	sw $t8, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	sw $t6, 12($sp)
	
	move $a0, $v1
	jal DisplayListOfTests
	
	lw $t8, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	lw $t6, 12($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
	InvalidInput1:
		jr $ra
		
		
	ThereIsNoList:
		la $a0, no_test_type
		li $v0, 4
		syscall
		
		jr $ra

			  	 
SearchTestsByPatientId:
	# pass the address of the main list in $a0 . 				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  	 		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  				  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  			  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	 	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  		  	  	  	
	
	move $t0, $a0  # address of the list = $t0 . 
	
	li $v0, 9  # dynmically allocate memory to read strings . 
	li $a0, 10
	syscall
	
	move $t9, $v0  # address of the read string = $t8 . 
	
	la $a0, read_patient_id_search  # prompt the user to enter the patient id . 
	li $v0, 4
	syscall
																																																																												
	move $a0, $t9  # reading patient id from the user, $t8 = input(str) . 
	li $a1, 10																																														
	li $v0, 8
	syscall
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t0, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)

	move $a0, $t9  # checking if the user input is valid or not
	jal IsValidPatientId
	
	lw $t0, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	beq $v0, $zero, InvalidTestCreation
	
	addi $sp, $sp, -12  # saving registers in stack segment .
	sw $t0, 0($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	
	move $a0, $t9  # converting input string into an integer .
	jal StringToInt 
	
	lw $t0, 0($sp)  # loading registers from stack segment . 
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 

	move $t1, $v0  # patient id = $t1 . 

	SearchLoop:
		la $a0, Search_by_patient_id_menu
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		move $t3, $v0
		
		beq $t3, 1, RetrieveAllPatientTests
		beq $t3, 2, RetrieveAllUpNormalPatientTests
		beq $t3, 3, RetrieveAllPatientTestsInAGivenSpecificPeriod
		beq $t3, 4, ExitSearch
		
		j InvalidChoiceSearch

	RetrieveAllPatientTests:
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
	
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t0
		move $a1, $t1
		jal RetrivePatientTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		beq $v0, $zero, EmptyPatientList
		move $t2, $v1  # address of the patient list = $t2 . 

		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t2
		jal DisplayListOfTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		j SearchLoop
		
	RetrieveAllUpNormalPatientTests:
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
	
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t0
		move $a1, $t1
		jal RetrivePatientTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		beq $v0, $zero, EmptyPatientList
		move $t2, $v1  # address of the patient list = $t2 . 
		
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t2
		jal RetriveUpNormalTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		move $t2, $v1  # address of the upnormal patient list = $t2 . 
		
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t2
		jal DisplayListOfTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		j SearchLoop

	RetrieveAllPatientTestsInAGivenSpecificPeriod:
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
	
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t0
		move $a1, $t1
		jal RetrivePatientTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		beq $v0, $zero, EmptyPatientList
		move $t2, $v1  # address of the patient list = $t2 . 
		
		la $a0, reading_test_date  # prompting the user to enter the test date in the appropriate format . 
		li $v0, 4
		syscall
	
		move $a0, $t9  # reading the test date from the user as a string .
		li $a1, 10
		li $v0, 8
		syscall
	
		addi $sp, $sp, -20  # saving registers in stack segment .
		sw $t8, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t2, 12($sp)
		sw $t6, 16($sp)
		
		move $a0, $t9  # validating and encrypting test date as an integer . 
		jal ValidateAndReturnTestDATE
	
		lw $t8, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t2, 12($sp)
		lw $t6, 16($sp)
		addi $sp, $sp, 20
	
		beq $v0, $zero, InvalidSearch  # Check if the test name is not valid .
		move $t4, $v1   ## first date input (date lower bound) . 
		
		la $a0, reading_test_date  # prompting the user to enter the test date in the appropriate format . 
		li $v0, 4
		syscall
	
		move $a0, $t9  # reading the test date from the user as a string .
		li $a1, 10
		li $v0, 8
		syscall
	
		addi $sp, $sp, -24  # saving registers in stack segment .
		sw $t8, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t2, 12($sp)
		sw $t6, 16($sp)
		sw $t4, 20($sp)
		
		move $a0, $t9  # validating and encrypting test date as an integer . 
		jal ValidateAndReturnTestDATE
	
		lw $t8, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t2, 12($sp)
		lw $t6, 16($sp)
		lw $t4, 20($sp)
		addi $sp, $sp, 20
	
		beq $v0, $zero, InvalidSearch  # Check if the test name is not valid .
		move $t5, $v1   ## second date input (date upper bound) . 
		
		addi $sp, $sp, -20  # saving registers in stack segment .
		sw $t8, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t2, 12($sp)
		sw $t6, 16($sp)
		
		move $a0, $t2  # validating and encrypting test date as an integer . 
		move $a1, $t4
		move $a2, $t5
		jal RetriveTestsInPeriod
	
		lw $t8, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t2, 12($sp)
		lw $t6, 16($sp)
		addi $sp, $sp, 20
		
		move $t2, $v1  # address of the upnormal patient list = $t2 . 
		
		addi $sp, $sp, -16  # saving registers in stack segment .
		sw $t0, 0($sp)
		sw $t9, 4($sp)
		sw $ra, 8($sp)
		sw $t1, 12($sp)
		
		move $a0, $t2
		jal DisplayListOfTests
	
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		lw $t0, 0($sp)  # loading registers from stack segment . 
		lw $t9, 4($sp)
		lw $ra, 8($sp)
		lw $t1, 12($sp)
		addi $sp, $sp, 16 
		
		InvalidSearch:
		
	
		j SearchLoop
		
		
	EmptyPatientList:
		la $a0, empty_patient_list
		li $v0, 4
		syscall
	
		j SearchLoop
	
	
	InvalidChoiceSearch:
		la $a0, invalid_choice_message
		li $v0, 4
		syscall
		
		j SearchLoop

	ExitSearch:
		jr $ra
	
	
RetriveTestsInPeriod:
	# pass the address of the list in $a0 .
	# pass the lower bound of the period in $a1
	# pass the upper bound of the period in $a2
	# returns the address of the list of upnormal test in $v0
	
	move $s6, $a1
	move $s7, $a2
	move $s4, $a0
	
	move $s0, $s1  # move the list to create a new list . 
	move $s1, $zero  # making sure the register value is null .
	
	beq $a0, $zero, NullPointer6  # checking if the passed list head is null . 
	
	lw $t0, 0($a0)  # checking if the list is empty .
	beq $t0, $zero, EmptyList7
	
	move $t6, $a0  # $t6 = head of the list of test . 
	
	addi $sp, $sp, -16  # saving the registers in memory . 
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	sw $t7, 8($sp)
	sw $t0, 12($sp)  
	
	jal CreateTestsList  # creating a list, $s1 = head of the list . 
	
	lw $ra, 0($sp)  # loading saved registers from memory . 
	lw $t6, 4($sp)
	lw $t7, 8($sp)    
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	
	move $t5, $s1  # $t5: address of the head of the newly created list . 
	move $s1, $s0 
	
	lw $t9, 4($s4)  # $t9 = pointer to the first of the list . 
	
	li $t8, 1  # initializing counter to zero
	
	Loop12:
		addi $sp, $sp, -32  # saving register in stack segment before function call
		sw $ra, 0($sp)
		sw $t0, 4($sp)
		sw $t4, 8($sp)
		sw $t5, 12($sp)
		sw $t6, 16($sp)
		sw $t7, 20($sp)
		sw $t8, 24($sp)
		sw $t9, 28($sp)
		
		lw $t3, 8($t9)
		
		move $v0, $zero
		blt $t3, $s6, SkipBranch 
		bgt $t3, $s7, SkipBranch
		
		j AddTestToList3
					
		SkipBranch:
		lw $ra, 0($sp)  # loading the registers save in memory before function call . 
		lw $t0, 4($sp)
		lw $t4, 8($sp)
		lw $t5, 12($sp)
		lw $t6, 16($sp)
		lw $t7, 20($sp)
		lw $t8, 24($sp)
		lw $t9, 28($sp)
		addi $sp, $sp, 32
	
		beq $t8, $t0, ExitLoop12  # checking if the size is equal to the counter . 
		
		addiu $t8, $t8, 1  # incrementing the oounter .
		    
		lw $t9, 16($t9)  # pointer = pointer -> next . 
		
		j Loop12
		
		AddTestToList3:
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
		
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $t9  # inserting test into the new list . 
			jal CopyTest
			
			move $s7, $v0
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
		
			addi $sp, $sp, -32  # saving register in stack segment before function call
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $t4, 8($sp)
			sw $t5, 12($sp)
			sw $t6, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
			sw $t9, 28($sp)
			
			move $a0, $s7  # inserting test into the new list . 
			move $a1, $t5
			jal InsertTestIntoList
			
			move $s7, $zero 
			
			lw $ra, 0($sp)  # loading the registers save in memory before function call . 
			lw $t0, 4($sp)
			lw $t4, 8($sp)
			lw $t5, 12($sp)
			lw $t6, 16($sp)
			lw $t7, 20($sp)
			lw $t8, 24($sp)
			lw $t9, 28($sp)
			addi $sp, $sp, 32
			
			beq $t8, $t0, ExitLoop11  # checking if the size is equal to the counter . 
		
			addiu $t8, $t8, 1  # incrementing the oounter .
		    
			lw $t9, 16($t9)  # pointer = pointer -> next . 
		
			j Loop12
			
			
	ExitLoop12:
		li $v0, 1
		move $v1, $t5
		
		jr $ra
		
	EmptyList7:
		la $a0, empty_list  # prompting to user that the list is empty . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		move $v0, $zero
		
		jr $ra
		
		
	NullPointer6:
		la $a0, null_list  # prompting the user that the passed list is null . 
		li $v0, 4
		syscall
		
		move $s1, $s0 
		
		jr $ra
