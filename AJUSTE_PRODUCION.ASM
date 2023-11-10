; AJUSTE DE PRODUCION CON CUBIERTA
AJUSTE_PRODUCION: ; PONE EN LINEA 1  "PRODUCION %" EN LINEA 2 PORCENTAJE
	LDI				R19, 100			; VALOR INICIAL DEL PORCENTAJE DE PRODUCION 100X100
	LDI				R18, 1
	MOV				R5, R18
    LDI   			YH,0x02        		; direcion alta donde se pone el texto en RAM
    LDI   			YL,0x60      		; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO1*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO1*2) 	; direccion baja del TEXTO en Flash 
    LDI   			R16,16      		; longitud de texto a copiar en RAM
CARGATEXTO_3P:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y, R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1				; incrementa en una unidad      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGATEXTO_3P  		; NO...seguimos cargando 
AJUSTE_PRODUCION_1:
	LDI				R22, 00
AJUSTE_PRODUCION_2:						; RETARDO TECLADO
	CPI				R22, 30
	BRLO			AJUSTE_PRODUCION_2	
	MOV				R24, R19
	CALL			RADC
	STS				$26D, R1
	STS				$26E, R2
	STS				$26F, R3	
	LDI				R16, 128			;  escribir en linea 1 
	CALL			ENVINT
	LDI				YH, HIGH(POR_PRO)	; POSICION ALTA DEL TAXTO EN RAM $0260
	LDI				YL, LOW (POR_PRO)	; direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,16 				; bytes a enviar 
	CALL			ENVIARTEXTO			; RUTINA PARA ENVIAR TEXTO A PANTALLA
;LEC_TECLADO1:  ; RESULTADO EN R17 RUTINA LECTURA TECLADO
	CALL			LEC_TEC
; PARAMETRO DE REDUCION DE LA PRODUCION CON CUBIERTA
	CPI				R17, 0B11101111		; IDEM
	BREQ			SUBE_R19
	CPI				R17, 0B11111101		; IDEM
	BREQ			BAJA_R19
	CPI				R17, 0B01111111		; IDEM
	BREQ			SALE_AJUSTE			; GRABA EN EEPROM LA POSICION DE LAS DOS LINEAS
	RJMP			AJUSTE_PRODUCION_1	
SUBE_R19:
	INC				R19
	INC				R19
	INC				R19
	INC				R19
	INC				R19
	RJMP			AJUSTE_PRODUCION_1
BAJA_R19:
	DEC				R19
	DEC				R19
	DEC				R19
	DEC				R19
	DEC				R19
	RJMP			AJUSTE_PRODUCION_1
SALE_AJUSTE:
	MOV				R18, R19
	LDI				R17, RE_PRO			; GRABACION EN EEPROM POR PRIMERA VEZ
	CALL			EEPROM_ES			; RUTINA DE GRABACION EN EEPROM
	RCALL			NO_TECLA			; ESPERA A QUE SE SUELTE LA TECLA
	RET
