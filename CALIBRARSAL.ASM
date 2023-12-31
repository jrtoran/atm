;  RUTINA CALIBRAR PARAMETROS PRODUCCION PH REDOX Y CLORO LIBRE
; EN ESTA RUTINA ESTA EL CONTROL DE LA PANTALLA

PRO6:	; PARA AJUSTAR LA SAL DEL AGUA
;CALL CONTROL_POL		; PONE LA POLARIDAD BUENA EN EL CASO DE ESTAR EN LA MALA
	RCALL			CAL_TECLA			; PROGRAMA PANTALLA CALIBRACCION
	LDS				R30, RAMC_SAL		; VALOR PARA EL CALIBRADO DE LA CONCENTRACION DE SAL
	LDI				R22, 00
	CLR				R7					; PONE A CERO EL RETARDO SALIDA TECLADO
PRO6A:
	LDI				R18,32				; APAGA EL DIGITO SAL
	STS				$905,R18			; PONE EN PANTALLA EL VALOR CALIBRADO DE LA SAL UNIDADES
	STS				$907,R18			; PONE EN PANTALLA EL VALOR CALIBRADO DE LA SAL DECIMAS
	RCALL			CAL_TECLA
PRO6B:			; TIEMPO DIGITO APAGADO
	CPI				R22,RETARDO3		; VALOR DEL TIEMPO DE RATARDO LECTURA DEL TECLADO DIGITO APAGADO
	BRLO			PRO6B				; COMPRUEBA EL TIEMPO DE RETARDO 

	CALL			ENCENDER_FUENTE
	CALL			LEDPANT
	WDR
	; VALOR DE MEDICION TOTAL SAL	********************* PONER UN VALOR FIJO

	LDI				R16,0x40			; SE PONE UN VALOR FIJO PARA MEDIR LA SAL
	STS				OCR3AH,R16
	LDI				R16,0x40
	STS				OCR3AL,R16	

	LDI				R18, P_SAL			; LINEA DE ENTRADA EN EL CONVERTIDOR PCF8591
	MOV				R26, R30			; NUMERO DE LECTURAS � CALIBRACION
;SUBI			R26,6					; PARA AJUSTAR CON LA RUTINA MEDICION DE SAL

	CALL			ADC_P
;	LDS				R18,RAM_MED_INI_SAL	; CARGA EL ERROR INICIAL DEL TLC26 EN R18
;	SUB				R24,R18				; RESTA EL ERROR INICIAL DE LA MEDICION
	CALL			RADC
	STS				RAM_SAL, R24		; ALMACENA LA MEDICION EN LA MEMORIA RAM
	STS				$905,R2				; PONE EN PANTALLA EL VALOR CALIBRADO DE LA SAL UNIDADES
	STS				$907,R3				; PONE EN PANTALLA EL VALOR CALIBRADO DE LA SAL DECIMAS
	RCALL			CAL_TECLA
PRO6C:
	CPI				R22,RETARDO2		; VALOR DEL TIEMPO DE RATARDO LECTURA DEL TECLADO DIGITO ENCENDIDO
	BRLO			PRO6B				; COMPRUEBA EL TIEMPO DE RETARDO 

	; VALOR DE MEDICION 	
	WDR
;	LDI				R18, P_SAL			; LINEA DE ENTRADA EN EL CONVERTIDOS PCF8591
;	LDI				R26, 231			; NUMERO DE LECTURAS � CALIBRACION
;	CALL			ADC_P

;	STS				RAM_SAL_C, R24
;	LDI				R16, 216			; PARA INVERTIR EL VALOR DEL PH
;	SUB				R16, R24			; Y RESTANDOLO DEL LEIDO			
;	LDS				R19, RAMC_PH		; LEE EL VALOR DE CALIBRACION Y
;	ADD				R16, R31			; EL VALOR DE CALIBRACION
;	STS				RAM_PH, R16			; GRABA EL VALOR EN RAN EN RAM
LDI R22,00						; reatardo lectura de las valores pues es muy rapido r22 = 20 linea 10  
	RCALL			LEC_TEC
	CPI				R17, 0B11111101		; TECLA - BAJA EL VALOR
	BREQ			BAJAR_SAL
	CPI				R17, 0B11101111		; TECLA + INCREMENTA EL VALOR
	BREQ			SUBIR_SAL
	CPI				R17, 0B01111111		; TECLA 7 SALIR GRABA LOS VALORES Y TERMINA
	BREQ			SALIR_SAL

	CPI				R17, 0B11111011		; TECLA FLECHA GRABA Y VA A CALIBRACION DE PH
	BREQ			SALIR_SAL1
	MOV				R24, TEMP_TEC
	CPI				R24, 50				; PARA COMPARARLO CON EL RETARDO SIN PULSAR TECLA
	BRPL			SALIR_SAL			; Y SALIR DE PROGRAMACION DE PARAMETROS
	RJMP			PRO6A

; AJUSTE CALIBRACION CONCENTRACION DE SAL
BAJAR_SAL:
	CLR				R7					; PONE A CERO EL RETARDO SALIDA TECLADO
	DEC				R30
	DEC				R30
	DEC				R30
	LDI				R22,00
	CPI				R30, 50
	BRBC			0, BAJAR_SAL1 
	LDI				R30, 50
BAJAR_SAL1:
	RJMP			PRO6A
SUBIR_SAL:
	CLR				R7					; PONE A CERO EL RETARDO SALIDA TECLADO
	INC				R30
	INC				R30
	INC				R30	
	LDI				R22,00
	CPI				R30, 210			; VALOR MAXIMO DE NUMERO DE VECES DE LECTURA.
	BRBS			0, SUBIR_SAL1		; SI MAYOR SALTA A SUBIR_PH1 Y PONE R31 CON EL VALOR MAZIMO
	LDI				R30,210
SUBIR_SAL1:
	RJMP			PRO6A
SALIR_SAL1:  ; GRABA LOS NUEVOS VALORES Y VA A CALIBRAR PH
	STS				RAMC_SAL, R30		; VALOR PARA EL CALIBRADO DE LA CONCENTRACION DE SAL
	LDI				R17, SAC_MEN		; POSICION DE MEMORIA A ESCRIBIR EN EEPROM $005
	MOV				R18, R30 
	RCALL			EEPROM_ES			; GRABA EN EEPROM EL VALOR DE LA NUEVA CALIBRACCION
	RCALL			LEDPANT				; ACTUALIZAR LOS LED DE LA PANTALLA	
;CALL GRABA_SAL

;STS	SAL_ELECTRODO,R30	
	RCALL			NO_TECLA			; PARA ESPERAR A QUE SE SUELTE LA TECLA SALIR
	JMP				PRO7
SALIR_SAL:  ; SALE Y GRABAR LOS VALORES
	STS				RAMC_SAL, R30		; VALOR PARA EL CALIBRADO DE LA CONCENTRACION DE SAL
	LDI				R17, SAC_MEN		; POSICION DE MEMORIA A ESCRIBIR EN EEPROM $005
	MOV				R18, R30 
	RCALL			EEPROM_ES			; GRABA EN EEPROM EL VALOR DE LA NUEVA CALIBRACCION
	MOV				R16, VAL_LED		;APAGA LUZ PANTALLA
	ANDI			R16, 0B10111111
	MOV				VAL_LED, R16
	RCALL			LEDPANT				; ACTUALIZAR LOS LED DE LA PANTALLA	
;CALL GRABA_SAL
;LDI	R30,00
;STS	SAL_ELECTRODO,R30	
	CALL			NO_TECLA
	RET

; linea 1-128
; linea 2-192
; linea 3-148
; linea 4-212


CAL_TECLA:		; PRESENTA LA PANTALLA DE CALIBRACCION DE VALOES

;***********************OJO PARA EVITAR QUE SALGA DE CALIBRACION***************
;LDI R16,00
;MOV TEMP_TEC,R16


					; CALIBRACION DE SAL
	LDI				R16, 128		; 11000000 escribir en linea 2 linea (192)
	RCALL			ENVINT
	LDI				YH,HIGH(CAL_SAL); POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW (CAL_SAL); direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,20 			; bytes a enviar 
	RCALL			ENVIARTEXTO		; RUTINA PARA ENVIAR TEXTO E PANTALLA
					; CALIBRACCION DE PH

	LDI				R16, 192		; 11000000 escribir en linea 2 linea (192)
	RCALL			ENVINT
	LDI				YH,HIGH (CAL_PH); POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW  (CAL_PH); direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,20 			; bytes a enviar 
	RCALL			ENVIARTEXTO		; RUTINA PARA ENVIAR TEXTO E PANTALLA
					;CALIBRACION  DE REDOX

	LDI				R16, 148		; ESCRIBIR LINEA 3
	RCALL			ENVINT
	LDI				YH,HIGH (CAL_RD); POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW  (CAL_RD); direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,20 			; bytes a enviar 
	RCALL			ENVIARTEXTO		; RUTINA PARA ENVIAR TEXTO E PANTALLA

					; CALIBRACION DE CLORO
	LDI				R16, 212		; 11000000 escribir en linea 2 linea (192)
	RCALL			ENVINT
	LDI				YH,HIGH (CAL_CL); POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW  (CAL_CL); direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,20 			; bytes a enviar 
	RCALL			ENVIARTEXTO		; RUTINA PARA ENVIAR TEXTO E PANTALLA
; AQUI ENVIA UN RETORNO DE CARRA ALA UART 0 Y 1



	RET
