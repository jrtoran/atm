; FUSES PARA CRISTAL DE CUARZO 2B BAJA Y D9 ALTA FF  FF
; EN RS232 PONER LA DIVISION EN 47 Y EL CONTEO DE SEGUNDOS EN 33 EN VEZ DE 36
INI_ATMEGA64:
; INICIALIZACION ATMEGA16
; SFIOR
;		ADTS2 ADTS1 ADTS0 – ACME PUD PSR2 PSR10
		
;		ADTS2		I
;		ADTS1		I SELECIONES EL PUNTO DE DISPARO VER PAG 221
;		ADTS0		I
;		ACME		COMPARADOR ANALOGICA PAG 201
;		PUD			CONTROL DE LA CARGA AL POSITIVO DE LOS PUERTOS VER PAG 52 0 CARGA ACTIVADA
;		PRS2		PREESCALA TIMER 2
;		PRS10		PREESCALA TIMER 0 Y 1 PAG 88

;  TCCR0: VER PAGINA 83

;		FOC0 WGM00 COM01 COM00 WGM01 CS02 CS01 CS00


;				0				 0 								Normal 0xFF Immediate MAX
;				1 				 0 								PWM, Phase Correct 0xFF TOP BOTTOM
;				0				 1 								CTC OCR0 Immediate MAX
;				1				 1 								Fast PWM 0xFF BOTTOM MAX

;					COM01 COM00 Description
;						0 	0 Normal port operation, OC0 disconnected.
;						0 	1 Reserved
;						1 	0 Clear OC0 on compare match when up-counting. Set OC0 on compare match when downcounting.
;						1 	1 Set OC0 on compare match when up-counting. Clear OC0 on compare match when downcounting.


;									 CS02 CS01 CS00 Description
;									 	0 	0 	0 	No clock source (Timer/Counter stopped).
;									 	0 	0 	1 	clkI/O/(No prescaling)
;									 	0 	1 	0 	clkI/O/8 (From prescaler)
;									 	0 	1 	1 	clkI/O/64 (From prescaler)
;									 	1 	0 	0 	clkI/O/256 (From prescaler)
;									 	1 	0 	1 	clkI/O/1024 (From prescaler)
;									 	1 	1 	0 	External clock source on T0 pin. Clock on falling edge.
;									 	1 	1 	1 	External clock source on T0 pin. Clock on rising edge

;  TIFR:

;		OCF2 TOV2 ICF1 OCF1A OCF1B TOV1 OCF0 TOV0
; OCR0  el valor introduciodo en este registr0 es comparado con el de TCNTO y se puede
;		producir un interrupcion el ser iguales
;TCNT0	REGISTRO DONDE SE CUENTAN LAS PASOS


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 31,250 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
	LDI				R16, 07			; CUANTO MAS BAJO MAS RAPIDO EL TECLADO
	OUT				TCCR0, R16
	LDI				R16, 00
	OUT				TCNT0, R16
	OUT				ASSR, R16
	LDI				R16, 0X00
	OUT				OCR0, R16

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: On
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
; inicializado a UN impulso por segundo y puesta a cero, cuenta en lec_rel y temp_tec
	LDI				R16,00
	OUT				TCNT1H, R16
	LDI				R16,00
	OUT				TCNT1L, R16
	LDI				R16,00
	OUT				ICR1H, R16
	LDI				R16,00
	OUT				ICR1L, R16
	LDI				R16,0x7A
	OUT				OCR1AH, R16
	LDI				R16, 0x12		; UNA HORA SON 100 MINUTOS HALA
	OUT				OCR1AL, R16
	LDI				R16,00
	OUT				OCR1BH, R16
	LDI				R16, 0xfa
	OUT				OCR1BL, R16
	LDI				R16,00
	OUT				TCCR1A, R16		; control y divisor timer A
	LDI				R16, 4
	OUT				TCCR1B, R16		; control y divisor timer B
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
	LDI				R16,00
	OUT				ASSR, R16
;	LDI				R16,00
	OUT				TCCR2, R16		; FRECUENCIA DEL RELOJ 2 SE UTILIZA EN LA RUTINA RADIO
;	LDI				R16,00
	OUT				TCNT2, R16
;	LDI				R16,00
	OUT				OCR2, R16
	OUT				TIFR, R16
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
	LDI				R16,00	
	OUT				MCUCR, R16
	LDI				R16,00	
	OUT				MCUCSR, R16

; TIMSK		Ccontrol de interrupciones del timer    	
;		OCIE2 TOIE2 TICIE1 OCIE1A OCIE1B TOIE1 OCIE0 TOIE0
		; TOIE0					;  bit 0 timer 0 por desbordamiento
		; OCIE0					;  bit 1 timer 0 por comparacion con OCR0 						
								;  bit 2 timer 1 desbordamiento
								;  bit 3 timer 1 compara OCR1B
								;  bit 4 timer 1 compara OCR1A
								;  bit 5 timer 1 entrada actiba
								;  bit 6 timer 2 desbordamiento
								;  bit 7 tomer 2 compara  con OCR2


	LDI				R16,0B01010001	
	OUT				TIMSK, R16

;********************* ACTIVAR EL CONVERTIDOR ANALOGICO DIGITAL CON INTERRUPCION **********


// TWI initialization
// Bit Rate: 100,000 kHz
;TWBR=0x20; BIT RATE DE LA TRANSMISION
// Two Wire Bus Slave Address: 0x1A
// General Call Recognition: Off

// Generate Acknowledge Pulse: On
// TWI Interrupt: On
;	LDI				R16, 0x45
;	OUT				TWCR, R16		; REGISTRO DE CONTROL
;	LDI				R16, 0x00
;	OUT				TWSR, R16		; REGISTRO DE ESTADO
;	LDI				R16, 0x4F
;	OUT				TWAR, R16		; DIRECION DEL SLAVE

	SEI				; ACTIVA LAS INTERRUPCIONES

// USART initialization
// USART disabled
;	LDI				R16,00	
;	OUT				UCSRB, R16
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
	
;	ACSR=0x80;
	
;	SFIOR=0x00;
;LDI R16,0B01001011
;OUT ACSR,R16
// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
	
;	ADMUX=ADC_VREF_TYPE & 0xff;
	
;	ADCSRA=0x83;

// SPI initialization
// SPI disabled
;	SPCR=0x00;
; DDR 		SALIDA A UNO ENTRADA A CERO
; PORT		A UNO LA RESISTENCIA PUS-PULL ACTIVADA- EN OPCION SALIDA VALOR DE ESTA A CERO Ó A UNO
; PIN		LECTURA DEL VALOR DE ENTRADA
;cofiguramos los puertos A B C Y D  
;programar primero la salida C para evitar micro-corto circuito con la salida D
; ** PRECAUCION ** NO MODIFICAR EL ORDEN DE PROGRAMACION DE LOS PUERTOS C B D A



 	LDI				R16, 0B11111111	; PC1 COMO ENTRADA CONTROL PANTALLA GRAFICA CORTAR PISTA EN PLACA PANTALLA
	OUT   			DDRC,R16		; TODAS SALIDAS MENOS SDL Y CLK CONTROL I2C
	LDI   			R16, 0B00011111	; salida 4 a 1 por ser el teclado 0,1,y 2 son los led amarillos
	OUT   			PORTC,R16		; TODAS LAS SALIDA A CERO MENOS LA Pc3 LECTURA DE TACLADO A 1

	LDI				R16,0B00000111	;PUERTO 4 REMOTO Y 3 TIPO DE FUENTE COMO ENTRADA SEÑAL
	OUT   			DDRB, R16		; PUERTO 5 6 Y 7 ENTRADA DEL MESTRO
	LDI				R16,0B10011111	;PUERTO 4 Y 3 COMO ENTRADA SEÑAL PARA EL CONTROL REMOTO	PUERTO 1 APOYA DE RDOX	
	OUT   			PORTB, R16		; Y PUERTO 0 TIPO DE FUENTE
	CBI				PORTD, 4		; APAGA CONTROL REMOTO Y VENTILADOR

	LDI	  			R16, 0B11110011	; D2 y D3  ENTRADA SEÑAL RS232
	OUT   			DDRD,R16		
	LDI	  			R16, 0B00011111	; D2 Y D3 ACTIVADA RESISTENCIA A UNO	
	OUT   			PORTD, R16

    SER   			R16 			;pone a FF r16
    OUT   			DDRA,R16   		;todo salidas..DATOS a FF
    OUT   			PORTA,R16 

	LDI				R16,0B10110000	; TODO ENTRADAS A CERO  E7 ANALOGICO DIGITAL  E3 CONTROL MOS-FET  E4 CONTROL CAUDAL Y E5 CONTROL MOTOR PASO A PASO
	OUT				DDRE,R16
	LDI				R16,0B11111111	; ACTIVADA RESISTENCIA A UNO E0 Y E1 RS232 SALIDA E3 CONTROL MOS-FET SALIDA E4 PARA CONTROL DE CAUDAL E7 PARA SEÑAL COMPARADOR ANALOGICO
	OUT				PORTE,R16
; CONFIGURAR PUERTO G LINEA0 COMO SALIDA PARA CONTROL EQUIPO REMOTO
	
	LDI				R16,0B00010001	; PUERTO 0 COMO SALIDA
	STS				DDRG,R16
	LDI				R16,0B00010000	; RESISTENCIA ACTIVADA SALIDA A 1
	STS				PORTG,R16

	CLR	  			R16				; LIMPIA EL REGISTRO 16
	MOV	  			VAL_LED, R16	; PASA EL VALOR DE R16 A LOS LED DE PANTALLA	
;	RCALL			LED_PANT

; CONTROL MODELO DE FUENTE
	SBIS			PINB, E_FUENTE	; SALTA LA SIGUIENTE INSTRUCION SI ES UNO
	CBI   			PORTB, 1		; SALIDA DEL PC817 A CERO APAGADA
	SBIS			PINB, E_FUENTE	; SALTA LA SIGUIENTE INSTRUCION SI ES UNO
	CBI   			DDRB, 1 		; SALIDA DEL PC817 A UNO APAGADA
	CBI				PORTD, 4		; APAGA CONTROL REMOTO Y VENTILADOR


;  TEXTO DE INICIO : SELECIONA LA 1ª VEZ MODELO Y CLIENTE
;  OPCION LEER EN EEPRON EL TEXTO DE PRESENTACION
	LDI				R17, texto_presentacion	; POSICION DE MEMORIA A LEER EN EEPROM $1DE
;	RCALL			I2CL_2404			; A LA RUTINA DE LECTURA DE LA EEPROM
	CALL			EEPROM_RW			; RUTINA LECTURA EEPROM DEVUELVE EL VALOR EN R18
	LDI				R25, 250
	CALL			COMP
	SBRC			CONTROL, 0			; VERIFICA SI ES CERO EL BIT 0 SI ES CIERTO SALTA LA SIG. INSTRUCION
	CALL			AJUSTE_PRESENTACION_INICIO ; LA MEMORIA NO ESTA PROGRAMADA Y SALTA A LA RUTINA DE PROGRAMACION
	SBI				PORTD,b_acido		; ENCIENDE BOMBA DE ACIDO
	LDI				R17, texto_presentacion	; POSICION DE MEMORIA A LEER EN EEPROM $1DE
	CALL			EEPROM_RW
	MOV				R4, R18
	LDI				R17, texto_presentacion + 1	; POSICION DE MEMORIA A LEER EN EEPROM $1DE
	CALL			EEPROM_RW
	MOV				R5, R18

;cargamos TEXTO PRESENTACION   
    LDI   			YH,0x02        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0x40      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,208      	; longitud de texto a copiar en RAM
;*** RURINA CARGAR TEXTO DE FLASH A RAM  
;EN Y (YH,YL) POSICION EN RAM
;EN Z (ZH,ZL) POSICION EN FLASH
;EN R16 NUMERO DE LETRAS (BYTS)

CARGATEXTO:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO   	; NO...seguimos cargando 
	NOP     						; SI...terminamos 
	CALL			TEXTO_ERRORES	; ESTA EN RUTINA CONTROL DE CAUDAL
; MODELO  
    LDI   			YH,HIGH (LIN1P)        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN1P)      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO3*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO3*2) ; direccion baja del TEXTO en Flash 
	LDI				R16, 16
	MUL				R16, R4			; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL, R0			; Y SUMA EL RESULTADO A ZL
    LDI   			R16,16      	; longitud de texto a copiar en RAM
CARGATEXTO_1:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_1  	; NO...seguimos cargando 
; FABRICANTE O VENDEDOR
    LDI   			YH,HIGH (LIN2P)        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN2P)      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO4*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO4*2) ; direccion baja del TEXTO en Flash 
	LDI				R16, 16
	LDI				R17, 1
	MUL				R16, R5			; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL, R0			; Y SUMA EL RESULTADO A ZL
    LDI   			R16,16      	; longitud de texto a copiar en RAM
CARGATEXTO_2:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2  	; NO...seguimos cargando 
	RET
