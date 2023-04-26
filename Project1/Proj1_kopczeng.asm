TITLE Project 1

; Author: Grant Kopczenski
; Last Modified: 4/17/2022
; OSU email address: kopczeng@oregonstate.edu
; Course number/section: CS271 Section 001
; Project Number: 1                Due Date: 4/17/2022
; Description: This program will take 3 inputs and will find the sums, differences and quotients with remainders of the inputs
; Extra Credit: 1) Repeat until the user chooses to quit 2) Check if numbers are not in strictly descending order 3) Calculate and display the quotients A/B, A/C, B/C, printing the quotient and remainder
;

INCLUDE Irvine32.inc

.DATA

  ; Strings for greetings, extra credit and description of the program
  greeting			BYTE 0ah, "Grant Kopczenski, Project 1",0
  extraCredit1		BYTE 0ah, "**EXTRA CREDIT**: The user can Loop through the program if desired",0
  extraCredit2      BYTE 0ah, "**EXTRA CREDIT**: If numbers are not in descending order, the program exits",0
  extraCredit3      BYTE 0ah, "**EXTRA CREDIT**: The Quotient and Remainder will be calculated and displayed for the 3 inputs",0
  description		BYTE 0ah, 0ah, "This program will take 3 inputs and will calculate the sums, differences and quotients with remainders of the inputs", 0ah, 0ah,0

  ; Strings for instructions for the user
  instructions1		BYTE "Enter the first number: ",0
  instructions2		BYTE "Enter the next number: ",0
  instructions3		BYTE "Enter the final number: ",0

  ; Strings for displaying mathmatical equations
  addition          BYTE " + ",0
  subtraction       BYTE " - ",0
  equals            BYTE " = ",0


  ; Variables for inputs and sums/difs
  input1			DWORD ?
  input2			DWORD ?
  input3			DWORD ?
  sum12				DWORD 0                             ; **NOTE** instead of using 'A, B, C' I used '1, 2, 3', which might make this look like "sum of 12" but its really just "sum of number 1 + number 2"
  dif12				DWORD 0
  sum13				DWORD 0
  dif13				DWORD 0
  sum23				DWORD 0
  dif23				DWORD 0
  sum123			DWORD 0

  ; Goodbye message
  goodBye			BYTE 0ah, "All done! Goodbye!", 0ah,0

  ; *** Extra Credit ***
  ; EC 1: Program Looping
  loopPrompt		BYTE 0ah, 0ah, "Would you like to run the program again? (0-No / 1-Yes)",0
  answerString		BYTE 0ah, "Answer: ",0
  answerInt			DWORD 0

  ; EC 2: Numbers in descending order
  error				BYTE 0ah, "ERROR: The entered values are not in descending order.", 0ah,0
  numbersDescending	DWORD 0

  ; EC 3: Quotients and Remainders
  division          BYTE " / ",0
  remainder         BYTE " with a remainder of: ",0

  quotient12        DWORD 0
  quotient13        DWORD 0
  quotient23        DWORD 0
  remainder12		DWORD 0
  remainder13		DWORD 0
  remainder23		DWORD 0



.CODE
main PROC

  ; Prints the greeting, extra credit done and description
  MOV		EDX, OFFSET greeting
  CALL		writeString
  MOV		EDX, OFFSET extraCredit1
  CALL		writeString
  MOV		EDX, OFFSET extraCredit2
  CALL		writeString
  MOV		EDX, OFFSET extraCredit3
  CALL		writeString
  MOV		EDX, OFFSET description
  CALL		writeString


_Loop:												    ; Loop jumps to here when user wants to run program again

  MOV		numbersDescending, 0                        ; Resets this variable to 0 before checking inputs, added this here mostly for if the user decides to run the program again the ERROR message will 
                                                        ; still show up when needed


  ; Code for the inputs                                 ; Prints a message, then takes a number value input
  ; Input 1
  MOV		EDX, OFFSET instructions1
  CALL		writeString
  CALL		readInt
  MOV		input1, EAX	

  ; Input 2
  MOV		EDX, OFFSET instructions2
  CALL		writeString
  CALL		readInt
  MOV		input2, EAX

  CMP		input1, EAX								    ; Compares if the 1st input is less than the 2nd input
  JL		_EndProg

  ; Input 3
  MOV		EDX, OFFSET instructions3
  CALL		writeString
  CALL		readInt
  MOV		input3, EAX

  CMP		input2, EAX								    ; Compares if the 2nd input is less than the 3rd input
  JL		_EndProg

  MOV		numbersDescending, 1					    ; If all of the numbers are in descending order, this value gets set to 1



  ; Calculations
  ; Calculation 1
  MOV		EAX, input1
  MOV		sum12, EAX
  MOV		EAX, input2
  ADD		sum12, EAX                                  ; Variable 'sum12' has the value stored

  ; Calculation 2
  MOV		EAX, input1
  MOV		dif12, EAX
  MOV		EAX, input2
  SUB		dif12, EAX                                  ; Variable 'dif12' has the value stored

  ; Calculation 3
  MOV		EAX, input1
  MOV		sum13, EAX
  MOV		EAX, input3
  ADD		sum13, EAX									; Variable 'sum13' has the value stored
  
  ; Calculation 4
  MOV		EAX, input1
  MOV		dif13, EAX
  MOV		EAX, input3
  SUB		dif13, EAX									; Variable 'dif13' has the value stored 

  ; Calculation 5
  MOV		EAX, input2
  MOV		sum23, EAX
  MOV		EAX, input3
  ADD		sum23, EAX									; Variable 'sum23' has the value stored

  ; Calculation 6
  MOV		EAX, input2
  MOV		dif23, EAX
  MOV		EAX, input3
  SUB		dif23, EAX									; Variable 'dif23' has the value stored

  ; Calculation 7
  MOV		EAX, input1
  MOV		sum123, EAX
  MOV		EAX, input2
  ADD		sum123, EAX
  MOV		EAX, input3
  ADD		sum123, EAX									; Variable 'sum123' has the value stored


  ; Calculation 8									    ; Division Calculations start here
  MOV       EAX, input1
  MOV       EBX, input2
  XOR       EDX, EDX
  DIV       EBX
  MOV       quotient12, EAX                             ; Collects the quotient value and stores it to a variable
  MOV       remainder12, EDX                            ; Collects the remainder value and stores it to a variable

  ; Calculation 9									    
  MOV       EAX, input1
  MOV       EBX, input3
  XOR       EDX, EDX
  DIV       EBX
  MOV       quotient13, EAX                             ; Collects the quotient value and stores it to a variable
  MOV       remainder13, EDX                            ; Collects the remainder value and stores it to a variable
  	
  ; Calculation 10									    
  MOV       EAX, input2
  MOV       EBX, input3
  XOR       EDX, EDX
  DIV       EBX
  MOV       quotient23, EAX                             ; Collects the quotient value and stores it to a variable
  MOV       remainder23, EDX                            ; Collects the remainder value and stores it to a variable



  ; Outputs
  ; Output 1
  CALL      CRLF
  MOV		EAX, input1
  MOV		EDX, OFFSET addition 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input2
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, sum12
  CALL      writeDec
  CALL      CRLF

  ; Output 2
  MOV		EAX, input1
  MOV		EDX, OFFSET subtraction 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input2
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, dif12
  CALL      writeDec
  CALL      CRLF

  ; Output 3
  MOV		EAX, input1
  MOV		EDX, OFFSET addition 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, sum13
  CALL      writeDec
  CALL      CRLF

  ; Output 4
  MOV		EAX, input1
  MOV		EDX, OFFSET subtraction 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, dif13
  CALL      writeDec
  CALL      CRLF

  ; Output 5
  MOV		EAX, input2
  MOV		EDX, OFFSET addition 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, sum23
  CALL      writeDec
  CALL      CRLF

  ; Output 6
  MOV		EAX, input2
  MOV		EDX, OFFSET subtraction 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, dif23
  CALL      writeDec
  CALL      CRLF

  ; Output 7
  MOV		EAX, input1
  MOV		EDX, OFFSET addition 
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input2
  MOV		EDX, OFFSET addition
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV		EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV       EAX, sum123
  CALL      writeDec
  CALL      CRLF
  CALL      CRLF


  ; Output 8                                            ; Division outputs start here
  MOV		EAX, input1
  MOV		EDX, OFFSET division
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input2
  MOV       EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV		EAX, quotient12
  CALL		writeDec
  MOV		EAX, remainder12
  MOV		EDX, OFFSET remainder
  CALL		writeString
  CALL		writeDec
  CALL      CRLF

  ; Output 9
  MOV		EAX, input1
  MOV		EDX, OFFSET division
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV       EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV		EAX, quotient13
  CALL		writeDec
  MOV		EAX, remainder13
  MOV		EDX, OFFSET remainder
  CALL		writeString
  CALL		writeDec
  CALL      CRLF
  
  ; Output 10
  MOV		EAX, input2
  MOV		EDX, OFFSET division
  CALL		writeDec
  CALL		writeString
  MOV       EAX, input3
  MOV       EDX, OFFSET equals
  CALL		writeDec
  CALL		writeString
  MOV		EAX, quotient23
  CALL		writeDec
  MOV		EAX, remainder23
  MOV		EDX, OFFSET remainder
  CALL		writeString
  CALL		writeDec
  CALL      CRLF



  ; Loop Prompt                                         ; Will ask user if they want to run the program again, then take a 1 or 0 answer
  MOV		EDX, OFFSET loopPrompt
  CALL		writeString
  MOV		EDX, OFFSET answerString
  CALL		writeString
  CALL		readInt
  MOV		answerInt, EAX
  CALL      CRLF

  CMP		answerInt, 1
  JE _Loop											    ; Jumps back to user inputs if the user answer yes to running the program again



_EndProg:
  CMP		numbersDescending, 1
  JE		_NoError								    ; Does not print an error if all numbers were in descending order, variable numbersDescending is set to 0 or 1 when the user is entering the inputs
  MOV		EDX, OFFSET error
  CALL		writeString

_NoError:
  ; Exit print
  MOV		EDX, OFFSET goodBye
  CALL		writeString

  Invoke ExitProcess,0
main ENDP

END main
