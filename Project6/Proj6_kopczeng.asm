TITLE Program 6 Grant Kopczenski

; Author: Grant Kopczenski
; Last Modified: 6/5/2022
; OSU email address: kopczeng@oregonstate.edu
; Course number/section:   CS271 Section 001
; Project Number: 6                Due Date: 6/5/2022
; Description: This program is for demonstrating low level I/O procedures and macros

INCLUDE Irvine32.inc

; mGetString macro: prompts the user for a string input and takes the input
mGetString			MACRO userInput, userPrompt
  
  PUSH				ECX
  PUSH				EDX
  MOV				EDX, userPrompt
  CALL				writeString

  MOV				EDX, userInput
  MOV				ECX, MAX
  CALL				readString

  POP				EDX
  POP				ECX

ENDM

; mDisplayString macro:
mDisplayString		MACRO value

  PUSH				EDX

  MOV				EDX, value
  CALL				writeInt

  POP				EDX

ENDM


  MAX				EQU 15

.data

  ; Title and description strings
  titleMessage		BYTE 0ah, 0ah, "Program 6 by Grant Kopczenski",0
  description		BYTE 0ah, "This program is for demonstrating low level I/O procedures and macros", 0ah,0

  ; Instruction and prompt strings
  instruction1		BYTE 0ah, "Please enter 10 signed decimal integers.",0
  instruction2		BYTE 0ah, "Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the integers with their sum and average value.", 0ah,0
  
  prompt			BYTE 0ah, "Enter a signed number: ",0
  error				BYTE "ERROR: That was not a signed number or it was too big.", 0ah,0

  listMessage		BYTE 0ah, "You entered the following numbers: ", 0ah,0
  sumMessage		BYTE 0ah, "The sum of all your numbers is: ",0
  averageMessage	BYTE 0ah, "The average of all your numbers is: ",0
  comma				BYTE ", ",0

  ; String variables
  input				BYTE MAX+1 DUP (?)

  ; Array and integer variables
  array				DWORD 10 DUP (?)
  sum				DWORD 0
  holder			DWORD 0
  negative			DWORD 0
  element			DWORD 0
  temp				DWORD 0

  ; Exit message
  goodbye			Byte 0ah, 0ah, "That's all, goodbye!", 0ah,0




.code
main PROC
 

  ; Displays the title message and description of the program
  MOV				EDX, OFFSET titleMessage
  CALL				writeString
  MOV				EDX, OFFSET description
  CALL				writeString

  ; Displays the instructions for the program
  MOV				EDX, OFFSET instruction1
  CALL				writeString
  MOV				EDX, OFFSET instruction2
  CALL				writeString	

  ; Sets ECX for the loop below
  MOV				ECX, 10

_InputLoop:

  ; pushes all the variables needed onto the stack and calls ReadVal, which will take the inputs as a string and convert them to integers
  PUSH				OFFSET element
  PUSH				OFFSET prompt
  PUSH				OFFSET input
  PUSH				OFFSET array
  PUSH				OFFSET error
  PUSH				OFFSET sum
  CALL				ReadVal
  LOOP				_InputLoop

  MOV				element, 0
  MOV				ECX, 10

  ; pushes all the variables needed onto the stack and calls WriteVal, which will display the stats
  PUSH				OFFSET comma
  PUSH				OFFSET input
  PUSH				OFFSET element
  PUSH				OFFSET listMessage
  PUSH				OFFSET averageMessage
  PUSH				OFFSET sumMessage
  PUSH				OFFSET array
  PUSH				sum
  CALL				WriteVal



  ; Displays the goodbye message
  MOV				EDX, OFFSET goodbye
  CALL				writeString

	Invoke ExitProcess,0	; exit to operating system
main ENDP


  ; ReadVal procedure: calls a macro to take an input from the user and error handles the input while converting the string to an int to be stored
ReadVal PROC

  PUSH				EBP
  MOV				EBP, ESP
  PUSH				EDX
  PUSH				EDI
  PUSH				EBX
  PUSH				ECX
  MOV				negative, 0
  CLD
  JMP				_FirstIt

  ; Prints error message and re-prompts the user for an input
_ErrorJump:

  MOV				EDI, [EBP+12]
  MOV				EDX, EDI
  CALL				writeString
  MOV				EAX, 0
  MOV				holder, 0

  
  ; Jumps here on the first iteration of the error handling loop
_FirstIt:

  MOV				EDI, [EBP+20]

  ; Calls the mGetString macro with parameters passed from the stack
  mGetString        EDI, [EBP+24]
  MOV				ECX, 11 
  MOV				ESI, EDI
  MOV				EAX, 0	
  JMP				_Convert

_Negative:
  MOV				negative, 1
  MOV				EAX, 0
 	
_Convert:
  ADD				holder, EAX
  MOV				EAX, 0

  LODSB											; LODSB
  CMP				EAX, 0
  JE				_Exit
  CMP				EAX, 45
  JE				_Negative
  MOV				temp, EAX
  SUB				EAX, 48
  CMP				EAX, 9
  JG				_ErrorJump
  MOV				EAX, holder
  IMUL				EAX, 10
  JO				_ErrorJump					; Checks if the overflow flag is set or not
  MOV				holder, EAX
  MOV				EAX, temp
  SUB				EAX, 48
  LOOP				_Convert

_Exit: 

  ; Adds the valid input to the sum variable and adds it into the number array
  MOV				EBX, holder
  MOV				ECX, negative
  CMP				ECX, 1
  JNE				_NotNegative
  IMUL				EBX, -1

_NotNegative:
  MOV				holder, 0
  MOV				EAX, [EBP+8]
  ADD				[EAX], EBX

  MOV				ESI, [EBP+28]
  MOV				EAX, [ESI]
  MOV				EDI, [EBP+16]
  MOV				[EDI+[EAX*4]], EBX

  INC				EAX
  MOV				[ESI], EAX

  POP				ECX
  POP				EBX
  POP				EDI
  POP				EDX
  POP				EBP
  ret				24
ReadVal ENDP



  ; This procedure will display the stats of the entered values 
WriteVal PROC
  PUSH				EBP
  MOV				EBP, ESP
  PUSH				EDI
  PUSH				ESI
  PUSH				ECX
  PUSH				EAX
  PUSH				EBX
  PUSH				EDX
  CLD
  MOV				ECX, 10

  MOV				EDX, [EBP+24]
  CALL				writeString


  ; This is the loop to output each individual entered number
_OutputLoop:
  
  MOV				EDI, [EBP+12]
  MOV				ESI, [EBP+28]
  MOV				EDX, [ESI]
  MOV				EAX, [EDI+[EDX*4]]
  INC				EDX
  MOV				[ESI], EDX

  mDisplayString    EAX

  CMP				ECX, 1
  JE				_Break
  MOV				EDX, [EBP+36]
  CALL				writeString

  LOOP				_OutputLoop

_Break:

  ; Displays the sum of all the entered numbers
  MOV				EDX, [EBP+16]
  CALL				writeString
  MOV				EAX, [EBP+8]
  mDisplayString	EAX


  ; Performs the calculations for the average and calls the macro to display it
  MOV				EBX, 10
  XOR				EDX, EDX
  DIV				EBX
  MOV				EDX, [EBP+20]
  CALL				writeString
  mDisplayString	EAX
  
  POP				EDX
  POP				EBX
  POP				EAX
  POP				ECX
  POP				ESI
  POP				EDI
  POP				EBP
  ret				28
WriteVal ENDP
  
END main
  