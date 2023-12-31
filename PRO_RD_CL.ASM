; PROGRAMACION DEL PARAMETRO PARA EL APOYO DE REDOX Y CLORO




; GRABA Y RETORNA A PROGRANACION DE REDOX O CLORO
TECLA6T:
	STS			RAM_RD_CL, R31		; ACTUALIZA EN RAM EL NUEVO VALOR PROGRAMADO DE LA PRODUCION
	LDI			R17, APOYO_RD_CL	; POSICION $060 EN EEPROM
	MOV			R18, R31			; GRABA EL VALOR DEL REDOX EN EEPROM POSICION 241
	CALL		EEPROM_ES
	CALL		NO_TECLA
	RET



TECLA6U:  ; GRABA Y RETORNA A PROGRAMACION DE REOX O CLORO
	STS			RAM_RD_CL, R31		; ACTUALIZA EN RAM EL NUEVO VALOR PROGRAMADO DE LA PRODUCION
	LDI			R17, APOYO_RD_CL
	MOV			R18, R31			; GRABA EL VALOR DEL REDOX EN EEPROM POSICION 241
	CALL		EEPROM_ES
	LDI			R16, 00				; PONE EL RETARDO DEL TECLADO A 0
	MOV			TEMP_TEC, R16
	CALL		NO_TECLA
	RET

TECLA6V:	; 	si no tiene redox nI sonda de cloro va a PROGRAMAR EL PH
;	LDI			R17, APOYO_RD_CL
;	CALL		EEPROM_RW
	LDS			R31,RAM_RD_CL

TECLA6:								; AJUSTAR EL VALOR DEL APOYO DE REDOX Y CLORO EN R31
	WDR
	MOV			R24, TEMP_TEC
	CPI			R24, retardo_programacion	; PARA COMPARARLO CON EL RETARDO 20 SEGUNDOS SIN PULSAR TECLA
	BRPL		TECLA6T						; Y SALIR DE PROGRAMACION DE PARAMETROS					
	CALL		LEC_TEC
	CPI			R17, 0B11111111		; COMPRUEBA SI SE A PULSADO ALGUNA TECLA
	BREQ		TECLA6A				; SI SE HA PULSADO SALTA A TECLA2A
	LDI			R16, 00				; SI ES ASI....
	MOV			TEMP_TEC, R16		; PONE EL CONTADOR DE RETARDO A CERO
TECLA6A:

			; OPCION SALTAR PARA AJUSTE DE PH
	CPI			R17, 0B11111011		; TECLA 2
	BREQ		TECLA6U				; SALTA PARA AJUSTAR EL PH
			; OPCION SALIR DE LECTURA DE TECLADO 
	CPI			R17, 0B01111111		;TECLA 5
	BRNE		TECLA6B				; SI NO ES 80 SALTA A TECLA1D
	RJMP		TECLA6T				; TERMINA Y SALE PARA GRABAR
TECLA6B:	; OPCION AUMENTAR
	CPI			R17, 0B11101111		; IDEM
	BRNE		TECLA6C				; SI NO ESTA PULSADA SALTA PARA VERIFICAR OTRA TECLA
	LDI			R16, 00				; PONE EL RETARDO DEL TECLADO A 0
	MOV			TEMP_TEC, R16
	INC			R31					; INCREMENTA EL VALOR
	LDI			R22, 0				; CARGA EL RETARDO DE LECTURA DELTECLADO
	CPI			R31, 8				; VERIFICA SI ESTA EN EL VALOR MAXIMO
	BRLT		TECLA6C				; SI NO SUPERA EL VALOR MAXIMO SALTA
	LDI			R31, 8				; SI SUPERA EL MAXIMO LO PONE AL MAXIMO
TECLA6C:	; OPCION DISMINUIR 
	CPI			R17, 0B11111101		; IDEM
	BRNE		TECLA6E				; SI NO ESTA PULSADA SALTA
	LDI			R16, 00				; PONE EL RETARDO DEL TECLADO A 0
	MOV			TEMP_TEC, R16
	DEC			R31					; DISMINUYE EL VALOR
	LDI			R22, 1				; CARGA EL RETARDO DE LECTURA DEL TECLADO
	CPI			R31, 2				; COMPRUEBA SI SE ELCANZA EL VALOR MINIMO
	BRBC 		0, TECLA6E			; SI NO SE ALCANZA SALTA
	LDI			R31, 2				; SI SE ALCANZA PONE EL VALOR MINIMO

TECLA6E:
	CPI			R22, RETARDO2		; VALOR DEL TIEMPO DE RATARDO LECTURA DEL TECLADO
	BRLO		TECLA6E				; COMPRUEBA EL TIEMPO DE RETARDO 
	RCALL		TECLA6D
	RJMP		TECLA6	

TECLA6D:	; PONER EL VALOR EN PANTALLA
	MOV			R24, R31			; PONE EL VALOR EN R24 PARA CONVERTIRLO EN DECIMAL
	CALL		RADC   				; CONVERTIR UN NUMERO EN DIGITOS DATO EN R24
	STS			$01EB, R3			; PONE EL RESULTADO EN PANTALLA MILIVOLTIOS DE REDOX

; ESCRIBIR LINEA 1

;LINEAP5: ; RUTINA PARA ESCRIBIR LAS DOS LINEAS EN ESTADO DE PROGRAMACION
	LDI			R16, 192			; ESCRIBIR LINEA 2
	CALL		ENVINT				; En subrrutina Env_doi Envia instrucion para escribir en linea 1
	LDI			YH,HIGH (LIN_1P)	; POSICION BIT ALTO DEL TEXTO A ENVIAR ram en 070
	LDI			YL,LOW  (LIN_1P)	; POSICION BIT BAJO DEL TEXTO A ENVIAR
	LDI			R17,20				; NUMERO DE DIGITOS A ENVIAR A PANTALLA
	CALL		ENVIARTEXTO			; RUTINA EN ESTE FICHERO PRECISA SUBRRUTINA ENV_DOI
	SBRC		CONTROL, 7			; COMPRUEBA QUE TIENE SONDA DE CL
	RJMP		LINEA2_CL			; PROGRAMACION DE CLORO
LINEA2_RD:
	LDI				R16, 32
	STS				$1E0,R16
	STS				$1E1,R16
	STS				$1E2,R16
	STS				$1E3,R16
	STS				$1E7,R16
	STS				$1E8,R16
	STS				$1E9,R16
	STS				$1EF,R16
	STS				$1F0,R16
	STS				$1F1,R16
	STS				$1F2,R16
	STS				$1F3,R16


	LDI				R16, 82			; PONE UNA R
	STS				$01E4,R16		
	LDI				R16, 100		; PONE UNA d
	STS				$01E5, R16	
	LDI				R16, 120		; PONE UNA x 
	STS				$01E6, R16	
	LDI				R16, 45			; PONE UN -
	STS				$01EA, R16	
	LDI				R16, 48			; PONE UN 0
	STS				$1EC, R16
	LDI				R16, 109		; PONE UNA m
	STS				$1ED, R16
	LDI				R16, 86			; PONE UNA V
	STS				$1EE, R16
	RJMP			LINEA2_RD_CL
LINEA2_CL:

	LDI				R16, 32
	STS				$1E0,R16
	STS				$1E1,R16
	STS				$1E2,R16
	STS				$1E3,R16
	STS				$1E5,R16
	STS				$1E6,R16
STS $1E7,R16
STS	$1EA,R16
	STS				$1EE,R16
	STS				$1EF,R16
	STS				$1F0,R16
	STS				$1F1,R16
	STS				$1F2,R16
	STS				$1F3,R16
	LDI				R16, 67			; PONE UNA C
	STS				$1E4,R16		
	LDI				R16, 108		; PONE UNA l
	STS				$1E5, R16	
	LDI				R16, 45			; PONE UN -
	STS				$01E8, R16	
	LDI				R16, 48			; PONE UN 0
	STS				$1E9, R16
	LDI				R16, 44			; PONE UNA ,
	STS				$01EA, R16
	LDI				R16, 112		; PONE UNA p
	STS				$1EC, R16
	STS				$1ED, R16
	LDI				R16, 109		; PONE UNA m
	STS				$1EE, R16
	RJMP			LINEA2_RD_CL
LINEA2_RD_CL:
	LDI				R16, 148		; 11000000 escribir en linea 2 linea (192)
	CALL			ENVINT
	LDI				YH,HIGH (LIN_2P)	; POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW  (LIN_2P)	; direccion BAJA DEL TEXTO EN RAM      	
  	LDI				R17,20 			; bytes a enviar 
	CALL			ENVIARTEXTO		; RUTINA PARA ENVIAR TEXTO E PANRALLA
CALL BORRA_LINEA_4

; BORRA LINEA 1
	LDI				R16,128			; BORRAR LINEA 1
	CALL			ENVINT				; RUTINA PARA ENVIAR A LA PANTALLA UNA INSTRUCION, " ESCRIBIR LINEA 2"
	LDI				YH,HIGH(BORRAR_LINEA)	; POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW (BORRAR_LINEA)	; direccion BAJA DEL TEXTO EN RAM  "CONSULTAR MANUAL"    	
  	LDI				R17,20   			; bytes a enviar 
	CALL			ENVIARTEXTO	
	RET


