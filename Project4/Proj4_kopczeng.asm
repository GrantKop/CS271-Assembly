TITLE Project 4 Grant Kopczenski

INCLUDE Irvine32.inc

.DATA
  
  ; Title message
  titleMessage		BYTE 0ah, "Project 4 by Grant Kopczenski",0

  ; Program messages
  description		BYTE 0ah, 0ah, "This program will calculate any amount of prime numbers between 1-200",0
  prompt			BYTE 0ah, "Enter the amount of Prime numbers you would like to see (must be between 1-200): ",0
  warning			BYTE 0ah, "Invalid amount! Number must be between 1-200! Try again.",0
  space				BYTE "    ",0
  returnL			BYTE 0ah,0

  ; Program number variables
  holder			DWORD ?
  counter1			DWORD ?
  counter2			DWORD 2
  lineCounter		DWORD 0

  ; Program bound constants
  upper				EQU 200
  lower				EQU 1

  
  ; Goodbye message
  goodbye			BYTE 0ah, 0ah, "All done! Goodbye!", 0ah,0


.CODE
main PROC

; Prints the greeting, title, description and extra credit done
  MOV				EDX, OFFSET titleMessage
  CALL				writeString

  MOV				EDX, OFFSET description
  CALL				writeString

  JMP				_FirstTime

; This is the loop to error handle the user input
_InputLoop:
  MOV				EDX, OFFSET warning
  CALL				writeString

_FirstTime:												; This prevents the above message from being sent pre-maturely
  MOV				EDX, OFFSET prompt
  CALL				writeString
  CALL				readINT

  CMP				EAX, lower
  JL				_InputLoop
  CMP				EAX, upper
  JG				_InputLoop

  MOV				ECX, EAX							; Sets ECX to the user input, this is for the LOOP below
  MOV				counter1, 2

; Top of the LOOP
_ShowPrimeLoop:

  MOV				counter2, 2
  MOV				EAX, counter1
  MOV				EBX, 2
  XOR				EDX, EDX
  DIV				EBX
  MOV				holder, EAX							; holder holds the value of the current number being checked for prime divided by 2, this is used to help the program know when to stop testing a number

  CALL				isPrime								; Calls the isPrime procedure below

  CMP				EAX, 1
  JE				_PrintNumber						; Prints the number and continues the LOOP if the number is prime (returned 1)
  INC				counter1
  JMP				_ShowPrimeLoop						; Otherwise it will keep increasing the number to find the next highest prime number

_PrintNumber:											; Jump point to print a number if it is prime
  
  INC				lineCounter
  MOV				EAX, counter1
  CALL				writeDEC
  MOV				EdX, OFFSET space
  CALL				writeString
  INC				counter1							
  CALL				lineSkip							; Calls the lineSkip procedure below

  LOOP				_ShowPrimeLoop						; Loops back to the jump point, this line is only reached if a prime number is found (ECX was set above before the jump point was created)

; Goodbye message
  MOV				EDX, OFFSET goodbye
  CALL				writeString



  Invoke ExitProcess,0
main ENDP


; isPrime procedure, checks if the current number selected is a prime number and sets EAX to 1 or 0 respectively 
isPrime PROC
  
_PrimeLoop:
  
  MOV				EAX, counter2
  CMP				EAX, holder
  JG				_YesPrime
				
  MOV				EAX, counter1
  MOV				EBX, counter2
  XOR				EDX, EDX
  DIV				EBX

  CMP				EDX, 0
  JE				_NotPrime
  INC				counter2
  JMP				_PrimeLoop

_YesPrime:

  MOV				EAX, 1						
  JMP			    _ExitProc

_NotPrime:

  MOV				EAX, 0

_ExitProc:
  ret

isPrime ENDP

; lineSkip procedure, checks to see if there needs to be a break in the line while displaying results (Every 10 numbers a break happens)
lineSkip PROC

  MOV				EAX, lineCounter
  MOV				EBX, 10
  XOR				EDX, EDX
  DIV				EBX

  CMP				EDX, 0
  JNE				_NoSkip
  MOV				EDX, OFFSET returnL
  CALL				writeString

_NoSkip:
  ret
lineSkip ENDP

END main
