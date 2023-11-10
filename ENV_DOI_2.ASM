;************************************** 
; envio de 1 byte EN DATOS O INSTRUCION Y LECTURA DEL BUSY
ENVIARBYTE_2:
	RCALL 		R_BUSY
	SBI   		PORTC, lcd_rs		; en datos a 1 
	RJMP  		ENV1_2
ENVINT_2:
	RCALL 		R_BUSY
	CBI   		PORTC, lcd_rs		; en instruccion a 0

ENV1_2:   
	SBI   		PORTC, LCD_E2		; activa enable
	OUT   		PORTA,R16   		; ponemos el byte de TEXTO 
	LDI   		R25,80      		; retardo total 230 us
	CALL 		RETARDO   			; 
	CBI   		PORTC,LCD_E2   		; STROBE=0 dato valido
	RET
; RUTINA VERIFICACION DEL BUSY
BUSY_2:
	PUSH  		R17
	SBI   		PORTC, LCD_RW
	CBI	  		PORTC, LCD_RS
	CLR   		R17
	OUT   		DDRA, R17			; PUERTO A COMO SALIDA
	OUT   		PORTA, R17			; CON VALOR 1 EN TODAS LAS SALIDAS
BUSY1_2:
	SBI	  		PORTC, LCD_E2		; activar la lectura
	NOP
	IN    		R17, PINA			; lee el valor del puerto a y lo almacena en r17
	ANDI  		R17, 0b10000000		; poner todos a cero menos el bit 7
	CBI	  		PORTC, LCD_E2		
	CPI	  		R17, 0B00000000		; VERIFICA SI ESTA OCUPADO EL DISPLAY
	BRNE  		BUSY1_2				; SI ESTA OCUPADO SIGUE ESPERANDO
	SER   		R17					; PONE R16 TODO A 1
	OUT   		DDRA, R17			; PUERTO A COMO SALIDA
	OUT   		PORTA, R17			; CON VALOR 1 EN TODAS LAS SALIDAS
	SBI   		PORTC, LCD_RS
	CBI   		PORTC, LCD_RW	
	POP   		R17
	RET
