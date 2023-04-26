TITLE Project 5

; Author: Grant Kopczenski
; Last Modified: 5/22/2022
; OSU email address: kopczeng@oregonstate.edu
; Course number/section:   CS271 Section 001
; Project Number:  5               Due Date: 5/22/2022
; Description: This program will generate 200 random numbers in the range (15-50), displays the original list, sorts and redisplays the list, and displays the amount of each value starting with 15

INCLUDE Irvine32.inc

  ARRAYSIZE			EQU 200
  LO				EQU 15
  HI				EQU 35

.data

  ; Title messages and description
  titleMessage		BYTE 0ah, 0ah, "Project 5 by Grant Kopczenski",0
  description		BYTE 0ah, "This program will generate 200 random numbers in the range (15-50), displays the original list, sorts and redisplays the list, and displays the amount of each value starting with 15",0

  ; Program messages
  preSortMessage	BYTE 0ah, 0ah, "Your unsorted random numbers: ",0
  medianMessage		BYTE 0ah, "The median value of the array is: ",0
  postSortMessage	BYTE 0ah, 0ah, "Your sorted random numbers: ",0
  instanceList		BYTE 0ah, "Your list of instances of each generated number, starting with the number of 15s: ",0

  ; Program integers and arrays
  randArr			DWORD ARRAYSIZE DUP(?)
  counts			DWORD ARRAYSIZE DUP(?)
  currentAmount		DWORD ?
  medianValue		DWORD ?
  holder			DWORD 0

  ; Program utility
  space				BYTE " ",0
  breakLine			BYTE 0ah,0


  ; Goodbye message
  goodbye			BYTE 0ah, "Thats all! Goodbye!", 0ah,0



.code
main PROC

  CALL				Randomize
  
  ; Push strings onto the stack and call Introduction
  PUSH				OFFSET titleMessage
  PUSH				OFFSET description
  CALL				Introduction

  ; Sets some registers that will be used through out the program
  MOV				ECX, ARRAYSIZE
  MOV				ESI, 0

  ; Push the array onto the stack and call RandomFill
  PUSH				OFFSET randArr
  CALL				RandomFill
  MOV				ESI, 0

  ;	Pushes the title and random array onto the stack and calls DisplayList
  PUSH				OFFSET preSortMessage
  PUSH				OFFSET randArr																	
  CALL				DisplayList
  MOV				ESI, 0

  ; Pushes the array on the stack twice to sort the array and find the median
  PUSH				OFFSET randArr
  CALL				SortList
  MOV				ESI, 0
  PUSH				OFFSET randArr
  PUSH				OFFSET medianMessage
  CALL				DisplayMedian
  MOV				ESI, 0

  ;	Pushes the title and random array onto the stack and calls DisplayList
  PUSH				OFFSET postSortMessage
  PUSH				OFFSET randArr
  CALL				DisplayList
  MOV				ESI, 0

  ; Pushes both arrays onto the stack and calls CountList to count the number of times each value shows up
  PUSH				OFFSET counts
  PUSH				OFFSET randArr
  CALL				CountList
  MOV				ESI, 0

  ;	Pushes the title and counts array onto the stack and calls DisplayList
  PUSH				OFFSET instanceList
  PUSH				OFFSET counts
  CALL				DisplayList
  MOV				ESI, 0


  MOV				EDX, OFFSET goodbye
  CALL				writeString


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; Prints the greeting, title and description
Introduction PROC

  PUSH				EBP
  MOV				EBP, ESP
 
  MOV				EDI, [EBP + 12]
  

  MOV				EDX, EDI
  CALL				writeString

  MOV				EDI, [EBP + 8]

  MOV				EDX, EDI
  CALL				writeString

  POP				EBP

  ret				8
Introduction ENDP

; Will fill an array with random numbers between two set numbers
RandomFill PROC
  
  PUSH				EBP
  MOV				EBP, ESP
 
  PUSH				EDI
  MOV				EDI, [EBP + 8]
_FillArray:

  MOV				EAX, HI
  CALL				RandomRange
  ADD				EAX, LO
  

  MOV				[EDI + [ESI * 4]], EAX
  INC				ESI
 
  LOOP				_FillArray

  POP				EDI
  POP				EBP
  ret				4
RandomFill ENDP

; Will find and display the median of an array passed into it
DisplayMedian PROC
  PUSH				EBP
  MOV				EBP, ESP

  MOV				EDI, [EBP + 8]
  MOV				EDX, EDI
  CALL				writeString
  MOV				EDI, [EBP + 12]

  MOV				EAX, ARRAYSIZE
  MOV				EBX, 2
  XOR				EDX, EDX
  DIV				EBX
  MOV				ESI, EAX
  
  MOV				EAX, [EDI + [ESI * 4]]

  CALL				writeDEC

  POP				EBP
  ret				4
DisplayMedian ENDP

; Will sort an array passed into it
SortList PROC

  PUSH				EBP
  MOV				EBP, ESP

  MOV				EBX, ARRAYSIZE-1

  MOV				EDI, [EBP + 8]

_SortLoop1:
  
  MOV				ESI, 0
  MOV				ECX, EBX

_SortLoop2:
  
  MOV				EAX, [EDI + [ESI * 4]]
  INC				ESI
  CMP				EAX, [EDI + [ESI * 4]]
  JLE				_LessThan

  PUSH				EDI
  CALL				ExchangeElements
  
_LessThan:

  DEC				ECX
  JNZ				_SortLoop2

  DEC				EBX
  JNZ  				_SortLoop1

  POP				EBP
  ret				4
SortList ENDP

; Will change 2 elements of an array
ExchangeElements PROC

  PUSH				EBP
  MOV				EBP, ESP
  PUSH				EDI
  MOV				EDI, [EBP + 8]

  MOV				EDX, [EDI + [ESI * 4]]
  DEC				ESI
  MOV				[EDI + [ESI * 4]], EDX
  INC				ESI
  MOV				[EDI + [ESI * 4]], EAX

  POP				EDI
  POP				EBP
  ret				4
ExchangeElements ENDP

; Will display an array passed into it breaking every 20 numbers onto a new line
DisplayList PROC

  PUSH				EBP
  MOV				EBP, ESP

  MOV				EDI, [EBP + 12]
  MOV				EDX, EDI
  CALL				writeString

  MOV				ECX, ARRAYSIZE
  MOV				EDX, OFFSET breakLine
  CALL				writeString

  MOV				EDI, [EBP + 8]
  
_PrintLoop:
  
  MOV				EAX, [EDI + [ESI * 4]]

  INC				ESI
  CMP				EAX, 0
  JE				_NotTwenty
  CALL				writeDEC
  MOV				EDX, OFFSET space
  CALL				writeString

  MOV				EAX, ESI
  MOV				EBX, 20
  XOR				EDX, EDX
  DIV				EBX
  CMP				EDX, 0
  JNE				_NotTwenty
  MOV				EDX, OFFSET breakLine
  CALL				writeString

_NotTwenty:

  LOOP				_PrintLoop

  POP				EBP
  ret				8
DisplayList ENDP

; Will count the amount of each element in the array
CountList PROC

  PUSH				EBP
  MOV				EBP, ESP
  
  MOV				EBX, ARRAYSIZE-1
  MOV				holder, 1
  MOV				ESI, 0

_CountLoop1:
  
  MOV				ECX, EBX
  MOV				EDI, [EBP + 8]
  MOV				currentAmount, 0

_CountLoop2:
  MOV				EAX, [EDI + [ESI * 4]]
  INC				ESI
  CMP				EAX, [EDI + [ESI * 4]]
  JNE				_NotEqual
  INC				currentAmount
  DEC				ECX
  CMP				ECX, 0
  JNE				_CountLoop2
  JMP				_ExitLoop

_NotEqual:
  
  PUSH				ESI
  INC				currentAmount
  MOV				EDI, [EBP + 12]
  MOV				EAX, currentAmount
  MOV				ESI, holder
  INC				holder
  MOV				[EDI + [ESI * 4]], EAX
  POP				ESI
  DEC				EBX
  JNZ  				_CountLoop1

_ExitLoop:
  POP				EBP
  ret				8
CountList ENDP


END main
