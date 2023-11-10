;  RECIBE DATOS DE RS232 E INICIALIZA EL PUERTO SERIE
;  EN LA RUTINA P_NEXTION_RS0 ENVIA A PANTALLA NEXTION TODO

; RUTINA PARA LA TRANSMISION DE DATOS A TRAVES DE LA UART
; CONFIGURAR A 9600 EN UBRRH Y UBRRL VALORES 00 Y 51

;	fOSC
;UBRR= _________ - 1  EJEMPLO UBRR =(8.000.000 /16X 9600) -1  ESTO DA 51
;	16 BAUD
; TABLA DE VALORES Y ERRORES PAG 168 Y SIGUIENTES


UART_INI0:  			;BAUDIOS A 9600
		LDI			R25, 00
		STS			UBRR0H, R25
		LDI			R25, 52
		OUT			UBRR0L, R25


;						UCSRnA
;		Bit 7 	6 	5 		4 	3 	2 	1 	0
;			RXC	TXC	UDRE	FE	DOR PE 	U2X MPCM

; CONFIGURAR 8 BIT 1 STOP NO PARIDAD Y ASINCRONO EN UCSRB
;BIT 7 RXC: Recepción completa del USART.
;BIT 6 TXC: Transmisión completa del USART.
;BIT 5 UDRE: Registro de datos vacío del USART.
;BIT 4 FE: Error de frame.
;BIT 3 DOR: Datos sobre-escritos.
;BIT 2 PE: Error de paridad.
;BIT 1 U2X: Velocidad de transmisión doble.
;BIT 0 MPCM: Modo de comunicación multiprocesador.

		LDI			R25, 00
		OUT			UCSR0A, R25


;							UCSRnB:
;		Bit 	7 	6 	5 	4 	3 	2 	1 	0
;			RXCIE 	TXCIE 	UDRIE 	RXEN 	TXEN 	UCSZ2 	RXB8 	TXB8
;RXCIE: Habilitación de interrupción de RX Completa.
;TXCIE: Habilitación de interrupción de TX Completa.
;UDRIE: Habilitación de interrupción de Registro de Datos Vacío del USART.
;RXEN: Habilitación de Receptor.
;TXEN: Habilitación de Transmisor.
;UCSZ2: Tamaño del carácter. 0 8 BIT, 1 9 BIT
;RXB8: Bit 8 de datos de Recepción (En el caso que haya sido configurado a 8 bits).
;TXB8: Bit 8 de datos de Transmisión (En el caso que haya sido configurado a 8 bits).

		LDI			R25,(1<<RXEN0)|(1<<TXEN0)|(1<<RXCIE0); ACTIVAR TRANSMISION Y RECEPCION E INTERRUPCION
		OUT			UCSR0B, R25

;UCSRnC:
;		Bit 	7 	6 	5 	4 	3 	2 	1 	0
;			URSEL 	UMSEL 	UPM1 	UPM0 	USBS 	UCSZ1 	UCSZ0 	UCPOL

;URSEL: Registro de Selección. Con 1 se escribe en UCSRC y con 0 en UBRRH (UCSRC y UBRRH tienen la misma dirección).
;UMSEL: Selección del moodo USART, 1 síncrona y 0 asíncrona.
;UPM1:0. Modo de paridad.
;USBS: Selección del bit de Stop, 1 dos bits y 0 un bit.
;Seleccionando tamaño del carácter:
;UCPOL: Polaridad del reloj (Obviamente solo en modo síncrono), 1 flanco ascendente y 0 flanco descendente.

;		LDI			R25, 0b00000110		; modo asincrono sin bit de paridad y 1 bit de parada
		LDI			R25,(0<<USBS0)|(3<<UCSZ00)
		STS			UCSR0C, R25
		RCALL		UART_TXC1			; VERIFICA SI ESTA OCUPADO EL PUERTO UART
		RET

DATOS_RS232_0:			; ALMCENA LOS DATOS VALIDOS EN RAM

		CPI			R18,113			; COMPRUEBA SI ES EL CARACTER 0x71 113 EN DECIMAL LO GRABA EN 0xC01
		BRNE		DATOS_RS232_0_A	; SI ES DISTINTO VA A DATOS_RS232_1_A
		LDI			YH,0x0C			; CARGA EL BIT ALTO
		LDI			YL,0x01			; CARGA EL BIT BAJO CON EL VALOR GRABADO EN RAM
		ST			Y,R18			; GRABA EN RAM EL VALOR DE R18
		INC			YL				; INCREMENTA EL VALOR CON LA NUEVA POSICION A GRABAR EN RAM
		STS			0xC00,YL
		RET

DATOS_RS232_0_A:		; COMPRUEBA SI ES FF CARACTER FINAL ENVIADO POR NEXTION
		CPI			R18,0xFF		; 
		BRNE		DATOS_RS232_0_B	; SI ES DISTINTO GRABA EL VALOR RECIBIDO
		CLR			YL				; PONE A CERO INICIO LA POSICION DE GRABADO EN RAM
		STS			0xC00,YL
		RET

DATOS_RS232_0_B:		; CARACTER VALIDO LO GRABA EN RAM		********* LO GRABA EN 0xC02 o 0XC03 ********
		LDI			YH,0x0C			; CARGA EL BIT ALTO
		LDS			YL,0xC00		; CARGA EL BIT BAJO CON EL VALOR GRABADO EN RAM
		ST			Y,R18			; GRABA EN RAM EL VALOR DE R18
		INC			YL				; INCREMENTAEL VALOR CON LA NUEVA POSICION A GRABAR EN RAM
		STS			0xC00,YL
		RET



BIT_REC_0:							; SALVA LOS REGISTROS
		NOP
		PUSH		R16
		PUSH		R17
		PUSH		R18
		PUSH		R19
		PUSH		R24
		IN			R16,SREG		; SALVA EL REGISTRO DE ESTADO
		PUSH		R16

;				***********************			ESPERA A RECIBIR EL  DATO	****************************
BIT_REC_01:
		SBIS		UCSR0A,RXC0
		RJMP		BIT_REC_01		; ESPERA A RECIBIR EL VALOR
		IN			R18,UDR0
		CALL		DATOS_RS232_0	; RUTINA CONTROL DE DATOS A GRABAR EN RAM 0xC01 0xC02 0xC03

		POP			R16
		OUT			SREG,R16
		POP			R24
		POP			R19
		POP			R18
		POP			R17
		POP			R16
		LDI			R25, 00
		STS			UCSR0A, R25
CALL DATO_ASCI
		RET

;******************************************  TERMINA RECEPCION DEL PUERTO SERIE POR INTERRUPCION  **********************


UART_TXC_FLASH:
; ENVIAR TEXTO DE FLASH
    	LDI   		ZH,high(TEXTO*5)	; direccion alta del TEXTO en Flash
		LDI   		ZL,low(TEXTO*5) 	; direccion baja del TEXTO en Flash 
		LDI   		R16,20     		; longitud de texto a TRANSMITIR
		LDI			R17, 1			; NUMERO DE LINEAS A ENVIAR
UART_TXC:
		LPM      				; leemos TEXTO de FLASH y lo almacena en R0
		ADIW  		ZL,1   			; apuntamos al siguiente elemento 
		OUT 		UDR0,R0			; pone el valor de dato en el registro de transmision
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO
		DEC   		R16      		; Hemos terminado..?? 
		BRNE  		UART_TXC  		; NO...seguimos cargando 
; ENVIAR RETARNO DE CARRO Y LINEA NUEVA
		LDI			R16, 10			; AQUI ENVIA UN RETARNO DE CARRO NUEVA LINEA
		OUT			UDR0, R16
		RCALL		UART_TXC1
		LDI			R16, 13			; AQUI ENVIA UN RETARNO DE CARRO NUEVA LINEA
		OUT			UDR0, R16
		RCALL		UART_TXC1
		LDI			R16,16
		DEC   		R17      		; Hemos terminado..?? 
		BRNE  		UART_TXC  		; NO...seguimos cargando 
		RET
        
UART_TXC1:  ; Rutina verificacion del termino en al envio de un bit BUFER VACIO
		SBIS		UCSR0A,UDRE0	; VERIFICA EL ENVIO DE LOS BITS BUFER VACIO
		RJMP		UART_TXC1		; EN CUYO CASO SALTA ESTA INSTRUCION
		RET

; ENVIAR TEXTO DE RAM: ANTES INDICAR DIRECION A LEER EN RAM (YH,high  E  YL,low)
UART_TXC_RAM:
		LDI   		R16,20     		; longitud de texto a TRANSMITIR
		RCALL		UART_TXC1		; VERIFICA SI ESTA OCUPADO EL PUERTO UART
		LDI			R17,1			; NUMERO DE LINEAS A ENVIAR
UART_TXC_RAM_1A:
    	LD			R0,Y+
		OUT 		UDR0,R0			; pone el valor de dato en el registro de transmision
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO
		DEC   		R16      		; Hemos terminado..?? 
		BRNE  		UART_TXC_RAM_1A	; NO...seguimos cargando 
; ENVIAR RETARNO DE CARRO Y LINEA NUEVA
		LDI			R16,10			; AQUI ENVIA UN SALTO DE LINEA NUEVA LINEA
		OUT			UDR0,R16
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO
		LDI			R16,13			; AQUI ENVIA UN RETORNO DE CARRO NUEVA LINEA
		OUT			UDR0,R16
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO
		LDI			R16,20
		DEC   		R17      		; Hemos terminado..?? 
		BRNE  		UART_TXC_RAM_1A	; NO...seguimos cargando 
		RET
; ENVIAR SOLO UN DATO AL PUERTO UAR VALOR A ENVIAR EN R16
;UART_TXC_1:
PUSH		R16
		OUT 		UDR0,R16		; pone el valor de dato en el registro de transmision
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO	
POP			R16
		RET


;ENVIAR UN BIT POR SEGUNDO
BIT_SEG:
		LDI			R19,47
BIT_SEG_A:
		INC			R19
		OUT			UDR0,R19
		RCALL		UART_TXC1

; MANDA SEÑAL CONTROL DE INSTRUCION ESCRIBIR LINEA1 CODIGO 128

	LDI				R16,128				; ESCRIBIR LINEA 1 MODELO DEL EQUIPO
;	CALL			ENVINT				; En subrrutina Env_doi Envia instrucion para escribir en linea 1
	CALL 			R_BUSY
	CBI   			PORTC, lcd_rs		; en instruccion a 0
	SBI   			PORTC, lcd_e		; activa enable
	OUT   			PORTA,R16   		; ponemos el byte de TEXTO 
	LDI   			R25,80      		; retardo total 230 us
	CALL 			RETARDO   			; 
	CBI   			PORTC,lcd_e   		; STROBE=0 dato valido


; MANDA EL CODIGO A PANTALLA ESCRIBIR TEXTO 
	CALL 			R_BUSY
	SBI  	 		PORTC, lcd_rs		; en datos a 1 
	MOV				R16,R19
	SBI  	 		PORTC, lcd_e		; activa enable
	OUT 	  		PORTA,R16   		; ponemos el byte de TEXTO 
	LDI  	 		R25,80      		; retardo total 230 us
	CALL 			RETARDO   			; 
	CBI  	 		PORTC,lcd_e   		; STROBE=0 dato valido


BIT_SEG_B:							; ESPERA UN SEGUNDO
		SBRS		CONTROL_1,0			; SALTA LA PROXIMA INSTRUCION SI ES UNO,
		RJMP		BIT_SEG_B
		CLT
		BLD			CONTROL_1, 0		; PASA EL REGISTRO T A CONTROL_1

		RJMP		BIT_SEG_A


