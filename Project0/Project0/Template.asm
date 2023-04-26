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