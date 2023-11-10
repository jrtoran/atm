; RUTINA PARA LA TRANSMISION DE DATOS A TRAVES DE LA UART
; CONFIGURAR A 9600 EN UBRRH Y UBRRL VALORES 00 Y 33

;	fOSC
;UBRR= _________ - 1  EJEMPLO UBRR =(8.000.000 /16X 9600) -1  ESTO DA 51
;	16 BAUD
; TABLA DE VALORES Y ERRORES PAG 168 Y SIGUIENTES


UART_INI:  			;BAUDIOS A 9600
		LDI			R25, 00
		STS			UBRR0H, R25
		LDI			R25, 51
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

		LDI			R25,(1<<RXEN0)|(1<<TXEN0); ACTIVA TRANSMISION Y RECEPCION
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

RJMP	UART_TXC_RAM 
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
		RCALL		UART_TXC1
		LDI			R16,13			; AQUI ENVIA UN RETORNO DE CARRO NUEVA LINEA
		OUT			UDR0,R16
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO
		LDI			R16,20
		DEC   		R17      		; Hemos terminado..?? 
		BRNE  		UART_TXC_RAM_1A	; NO...seguimos cargando 
		RET
; ENVIAR SOLO UN DATO AL PUERTO UAR VALOR A ENVIAR EN R16
UART_TXC_1:
		OUT 		UDR0,R16		; pone el valor de dato en el registro de transmision
		RCALL		UART_TXC1		; RUTINA PARA VERIFICAR EL FIN DEL ENVIO DEL DATO	
		RET
