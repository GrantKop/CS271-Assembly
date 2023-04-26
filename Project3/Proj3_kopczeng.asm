TITLE Project 3





INCLUDE Irvine32.inc

.DATA

  ; Strings for greetings and extra credit
  titleMessage		BYTE 0ah, "Grant Kopczenski, Project 3",0
  description		BYTE 0ah, "This program will take numbers from the user and will run a few calculations with the inputed numbers",0
  extraCredit		BYTE 0ah, 0ah, "**EXTRA CREDIT**: The lines are numbered during user input (for example: Input 1:, Input 2:, ...Input n: )", 0ah, "The value only increases if a valid input is received.",0

  ; Strings for instructions and user inputs
  greeting			BYTE 0ah, 0ah, "Welcome to the Integer Accumulator by Grant Kopczenski",0
  namePrompt		BYTE 0ah, "Please enter your name: ",0
  greetUser			BYTE 0ah, "Hello there, ",0
  numberPrompt		BYTE 0ah, "Please enter numbers between [-200, -100] or between [-50, -1]",0
  instruction		BYTE 0ah, "Enter a positive number to see the results", 0ah,0

  ; Strings for outputs
  output			BYTE 0ah, "Amount of valid numbers entered: ",0
  warning			BYTE "That isn't a valid number! (Must be between [-200, -100] or between [-50, -1])", 0ah,0
  maxOutput			BYTE 0ah, "The largest number entered was: ",0
  minOutput			BYTE 0ah, "The smallest number entered was: ",0
  sumOutput			BYTE 0ah, "The sum of all the entered numbers is: ",0
  avgOutput			BYTE 0ah, "The rounded average of all the numbers is: ",0

  ; Utility strings
  exclamationPoint	BYTE "!", 0ah,0
  colon				BYTE ": ",0

  ; Username input (max is 30 characters)
  MAX = 30
  usernameInput		BYTE MAX+1 DUP (?)


  ; Calculations variables
  minimum			DWORD 0
  maximum			DWORD 0
  sum				DWORD 0
  average			DWORD 0

  ; Constant variables for bounds
  bound1			EQU -200
  bound2			EQU -100
  bound3			EQU -50
  bound4			EQU -1

  ; Goodbye! message
  goodbye			BYTE 0ah, "All done! Goodbye ",0


  ; *** Extra Credit ***
  ; EC 1: Input Counter 
  inputTrackerStr	BYTE "Input ",0
  inputTrackerInt	DWORD 1




.CODE
main PROC

  ; Prints the greeting, title, description and extra credit done
  MOV				EDX, OFFSET titleMessage
  CALL				writeString
  MOV				EDX, OFFSET description
  CALL				writeString
  MOV				EDX, OFFSET extraCredit
  CALL				writeString

  MOV				EDX, OFFSET greeting
  CALL				writeString
  MOV				EDX, OFFSET namePrompt
  CALL				writeString

  ; Takes the user's input name
  MOV				EDX, OFFSET usernameInput
  MOV				ECX, MAX
  CALL				readString

  ; Greets the user with their name
  MOV				EDX, OFFSET greetUser
  CALL				writeString
  MOV				EDX, OFFSET usernameInput
  CALL				writeString
  MOV				EDX, OFFSET exclamationPoint
  CALL				writeString

  MOV				EDX, OFFSET numberPrompt
  CALL				writeString
  MOV				EDX, OFFSET instruction
  CALL				writeString

  ; Jumps over error handling messages to begin the do-while loop
  JMP				_NumInputLoop


_TestBound3:															; This is here to make sure the input is within the second range of values
  CMP				EAX, bound3
  JGE				_ValidInput


_InvalidInput:															; This is executed if the input is invalid (outside of the given ranges)
  MOV				EDX, OFFSET warning
  CALL				writeString


_NumInputLoop:

  MOV				EDX, OFFSET inputTrackerStr
  CALL				writeString
  MOV				EAX, inputTrackerInt
  CALL				writeDec
  MOV				EDX, OFFSET colon
  CALL				writeString
  CALL				readInt

  TEST				EAX, EAX
  JNS				_ExitLoop

  CMP				EAX, bound1
  JL				_InvalidInput
  CMP				EAX, bound4
  JG				_InvalidInput
  CMP				EAX, bound2
  JG				_TestBound3


_ValidInput:

  ADD				sum, EAX											; Keeps track of the sum

  CMP				inputTrackerInt, 1									; Checks if the input is the first input (if true, sets both min and max to the input)
  JE				_FirstNum

  ; Code to set the minimum if need be
  CMP				minimum, EAX
  JL				_NotLess
  MOV				minimum, EAX

  ; Code to set the maximim if need be
_NotLess:
  CMP				maximum, EAX
  JG				_NotGreator
  MOV				maximum, EAX

  JMP				_NotGreator

_FirstNum:
  MOV				minimum, EAX
  MOV				maximum, EAX

_NotGreator:

  INC				inputTrackerInt										; Keeps track of what number we are on

  JMP				_NumInputLoop										; Resets the loop, this is reached when the input is not signed (0+)

_ExitLoop:

  DEC				inputTrackerInt										; This sets the tracker variable to the true value

  ; Signed division code here
  MOV				EAX, sum
  CDQ
  MOV				EBX, inputTrackerInt
  IDIV				EBX
  MOV				average, EAX
  
  CMP				EDX, 0
  JE				_Rounded
  ADD				average, EDX

_Rounded:
  ; Prints all the outputs and values
  MOV				EDX, OFFSET output
  MOV				EAX, inputTrackerInt
  CALL				writeString
  CALL				writeDec
  MOV				EDX, OFFSET maxOutput
  MOV				EAX, maximum
  CALL				writeString
  CALL				writeInt
  MOV				EDX, OFFSET minOutput
  MOV				EAX, minimum
  CALL				writeString
  CALL				writeInt
  MOV				EDX, OFFSET sumOutput
  MOV				EAX, sum
  CALL				writeString
  CALL				writeInt
  MOV				EDX, OFFSET avgOutput
  MOV				EAX, average
  CALL				writeString
  CALL				writeInt

  ; Goodbye message printed with name
  MOV				EDX, OFFSET goodbye
  CALL				writeString
  MOV				EDX, OFFSET usernameInput
  CALL				writeString
  MOV				EDX, OFFSET exclamationPoint
  CALL				writeString


  Invoke ExitProcess,0
main ENDP

END main
