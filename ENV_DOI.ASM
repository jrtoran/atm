;************************************** 
; envio de 1 byte EN DATOS O INSTRUCION Y LECTURA DEL BUSY
; EN R16 VALOR A ENVIAR

ENVIARBYTE:
	RCALL 		R_BUSY
	SBI   		PORTC, lcd_rs		; en datos a 1 
	RJMP  		ENV1
ENVINT:
	RCALL 		R_BUSY
	CBI   		PORTC, lcd_rs		; en instruccion a 0
ENV1:   
	SBI   		PORTC, lcd_e		; activa enable
	OUT   		PORTA,R16   		; ponemos el byte de TEXTO 
	LDI   		R25,80      		; retardo total 230 us
	RCALL 		RETARDO   			; 
	CBI   		PORTC,lcd_e   		; STROBE=0 dato valido
;CALL		UART_TXC_1			; ENVIAR EL DATO A LA  UART0
;CALL		UART_TXC_3			; ENVIAR EL DATO A LA  UART1

	RET
; RUTINA VERIFICACION DEL BUSY
;BUSY:
	PUSH  		R17
	SBI   		PORTC, LCD_RW
	CBI	  		PORTC, LCD_RS
	CLR   		R17
	OUT   		DDRA, R17			; PUERTO A COMO SALIDA
	OUT   		PORTA, R17			; CON VALOR 1 EN TODAS LAS SALIDAS
BUSY1:
	SBI	  		PORTC, LCD_E		; activar la lectura
	NOP
	IN    		R17, PINA			; lee el valor del puerto a y lo almacena en r17
	ANDI  		R17, 0b10000000		; poner todos a cero menos el bit 7
	CBI	  		PORTC, LCD_E		
	CPI	  		R17, 0B00000000		; VERIFICA SI ESTA OCUPADO EL DISPLAY
	BRNE  		BUSY1				; SI ESTA OCUPADO SIGUE ESPERANDO
	SER   		R17					; PONE R16 TODO A 1
	OUT   		DDRA, R17			; PUERTO A COMO SALIDA
	OUT   		PORTA, R17			; CON VALOR 1 EN TODAS LAS SALIDAS
	SBI   		PORTC, LCD_RS
	CBI   		PORTC, LCD_RW	
	POP   		R17
	RET
R_BUSY:

LDI R24, 1
CALL RETARDO
RET
