; *********INICIALIZAR PANTALLA DOS//////////////
.equ lcd_e2 = 02
INI_PANTALLA_2:
	LDI   R24, 100
TEM1_2:						; NECESITA 15mS DE RETRASO DESPUES DE CONECTAR
	LDI   R25, 250			; CICLO DE 250 us A 4Mhz x 100 = 0,025 seg
	RCALL RETARDO
	DEC   R24
	BRNE  TEM1_2
	LDI   R16, 48			; 00110000 se debe enviar tres veces (1)
	RCALL ENVINTR_2
	LDI   R24, 23			; retardo de 4,1 ms ( 23x250=5.750 ms )
TEM2_2:	
	LDI   R25, 250
	RCALL RETARDO
	DEC   R24
	BRNE  TEM2_2
	LDI   R16, 48			; 00110000 se debe enviar tres veces (1)
	RCALL ENVINTR_2
	LDI   R25, 120			; retardo 100us
	RCALL RETARDO
	LDI   R16, 48			; 00110000 se debe enviar tres veces (1)
	RCALL ENVINTR_2
	LDI   R25, 120
	RCALL RETARDO
	LDI   R16,56			; 00111000 8 BITS 2LINEAS, DIGITO DE 5X7
	RCALL ENVINTR_2	
	LDI   R25, 250
	RCALL RETARDO
	LDI   R16, 0b00001100	; ENCIENDE LA PANTALLA 1CDB
	RCALL ENVINTR_2			; C CURSOR ON/OFF
	LDI   R25, 250			; D PONE UNA MARCA DONDE ESTA EL CURSOR
	RCALL RETARDO			; B intermitente
	LDI   R16, 06			; MODO SET ,TRABAJO
	RCALL ENVINTR_2
	RET
INI_PANTALLA1_2:
	LDI   R16, 128			; escribir en linea uno
	RCALL ENVINTR_2
	LDI   YH, HIGH (LIN1P)
	LDI   YL, LOW  (LIN1P)
	LDI   R17,16
	RCALL ENVIARTEXTO
	LDI   R16, 192			; 11000000 escribir en linea 2 linea (192)
	RCALL ENVINTR_2
	LDI   YH, HIGH (LIN2P)	; POSICION ALTA DEL TAXTO EN RAM
	LDI   YL, LOW  (LIN2P)	; direccion BAJA DEL TEXTO EN RAM      		
	LDI   R17,16			; numero de digitos a enviar
	RCALL ENVIARTEXTO	
	RETI



ENVINTR_2:
	CBI   PORTC, lcd_rs		; en instruccion a 0
	LDI   R25,50			; retardo necesario aprox 42us
	RCALL RETARDO
	SBI   PORTC, LCD_E2		; activa enable
	OUT   PORTA,R16   		; ponemos el byte de TEXTO 
	LDI   R25,230      		; retardo total 230 us
	RCALL RETARDO   		; 
	CBI   PORTC,LCD_E2   	; STROBE=0 dato valido
	LDI   R25, 200			; 1retardo necesario 270us 
	RCALL RETARDO
	LDI   R25, 200			; 2retardo necesario 195us 
	RCALL RETARDO
	LDI   R25, 200			; 3retardo necesario 195us 
	RCALL RETARDO
	LDI   R25, 200			; 4retardo necesario 195us 
	RCALL RETARDO
	LDI   R25, 200			; 5retardo necesario 270us son 190 faltan 80
	RCALL RETARDO			; llamada a la rutina retardo   
	LDI   R25, 100			; 6retardo necesario 80us
	RCALL RETARDO			; llamada a la rutina retardo  
	RET
