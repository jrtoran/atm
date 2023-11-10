; SELECION DE LINEA 1 Y 2 DE PRESENTACION




AJUSTE_PRESENTACION:
	RCALL 			INI_PANTALLA		; LLAMA A LA RUTINA PARA INICIAR LA PANTALLA
;BORRA LINEA 1
	LDI				R16,128			; BORRAR LINEA 1
	CALL			ENVINT				; RUTINA PARA ENVIAR A LA PANTALLA UNA INSTRUCION, " ESCRIBIR LINEA 2"
	LDI				YH,HIGH(BORRAR_LINEA)	; POSICION ALTA DEL TAXTO EN RAM 080
	LDI				YL,LOW (BORRAR_LINEA)	; direccion BAJA DEL TEXTO EN RAM  "CONSULTAR MANUAL"    	
  	LDI				R17,20   			; bytes a enviar 
	CALL			ENVIARTEXTO	
	CALL BORRA_LINEA_4
AJUSTE_PRESENTACION_INICIO:		; PARA QUE NO GUARREE LAS LINEAS 1 Y 4
	RCALL 			INI_PANTALLA		; LLAMA A LA RUTINA PARA INICIAR LA PANTALLA
	LDI				R16,00
	MOV				R4,R16				; VALOR TIPO
	MOV				R5,R16				; VALOR POTENCIA
	MOV				R6,R16				; VALOR DISTRIBUIDOR			
	SBIS			PINB,4				; PRINCIPAL O REMOTO salta la siguiente instrucion si es uno
	RJMP			SALIR_AJUSTE		; SI HAY PUENTE REMOTO "NO TIENE TECLADOOOOOOO"
	LDI				R16,32				; PONE UN ESPACIO
	STS				$7DE,R16
	STS				$7DF,R16
	STS				$7F0,R16
	STS				$7F1,R16
	STS				$7F2,R16
	STS				$7F3,R16
	STS				$804,R16
	STS				$805,R16



AJUSTE_PRESENTACION_1:
; POTENCIA 50 80 120 ETC CARGA 4 DIGITAS AL FINAL DE LA LINEA
	CALL			ENCENDER_FUENTE		; PARA EL AJUSTE DE AMPERIOS y salida e3 a cero en ini micro
	SBI				PORTD,6				; ACTIVA UNA POLARIDAD
	CALL			AJUSTE_AMPERIOS		; MEDICION DE AMPERIOS ESTA AL FINAL DE ESTA RUTINA
	RCALL			AJUSTE_PRESENTACION_4	


;       20x4        16x4   tipo de display
; linea 1-128 		128 
; linea 2-192		192
; linea 3-148		144
; linea 4-212		208
	LDI   			R16,148				; escribir en linea 3 DISTRIBUIDOR + MODELO + POTENCIA
	RCALL 			ENVINTR
	LDI   			YH,HIGH (LIN1P)
	LDI  			YL,LOW  (LIN1P)-2
	LDI   			R17,20
	CALL 			ENVIARTEXTO
	LDI   			R16,192				; 11000000 escribir en linea 2 
	RCALL 			ENVINTR
	LDI   			YH,HIGH (LIN2P)		; POSICION ALTA DEL TAXTO EN RAM DISTRIBUIDOR
	LDI   			YL,LOW  (LIN2P)-2	; direccion BAJA DEL TEXTO EN RAM  DISTRIBUIDOR    		
	LDI   			R17,20
	CALL 			ENVIARTEXTO
	LDI				R22,00
AJUSTE_PRESENTACION_2:					; RETARDO TECLADO
	CPI				R22,30
	BRLO			AJUSTE_PRESENTACION_2	
;LEC_TECLADO1:  ; RESULTADO EN R17 RUTINA LECTURA TECLADO
	CALL			LEC_TEC				; RUTINA PARA LEER LAS TECLAS
; CAMBIAR POTENCIA 50 80 120 ETC
	CPI				R17,0B11101111		; IDEM
	BREQ			SUBIR_R4			; SUBE LA POTENCIA
	CPI				R17,0B11111101		; IDEM
;	BREQ			BAJAR_R4			; BAJA LA PTENCIA
; CAMBIAR EMPRESA	TEAP AQUABEST ETC
	CPI				R17,0B11110101		; IDEM COLOCA LA EMPRESA
;	BREQ			BAJAR_R6
	CPI				R17,0B11100111		; IDEM COLOCA LA EMPRESA
	BREQ			SUBIR_R6
; CAMBIA EL TIPO  L   LS  LMG Q QS  QMG 123 456
	CPI				R17,0B11111001		; COLOCA EL TIPO
;	BREQ			BAJAR_R5
	CPI				R17,0B11101011		; COLOCA EL TIPO
	BREQ			SUBIR_R5
	CPI				R17,0B01111111		; IDEM
	BREQ			SALIR_AJUSTE		; GRABA EN EEPROM LA POSICION DE LAS DOS LINEAS
	CPI				LEC_REL, 120
	BREQ			SALIR_AJUSTE
	RJMP 			AJUSTE_PRESENTACION_1	
SUBIR_R4: ;SELECIONA LA POTENCIA DEL EQUIPO valores validos 0 1 2 3 4
	INC				R4
	LDI				R24,5
	CP				R4,R24
	BRNE			SUBIR_R41
	LDI				R24,0
	MOV				R4,R24
SUBIR_R41:
	RJMP 			AJUSTE_PRESENTACION_1	
BAJAR_R4: 
	DEC				R4
	MOV				R24,R4
	CPI				R24,1				
	BRLO			BAJAR_R41
	LDI				R24,8
	MOV				R4,R24	
BAJAR_R41:
	RJMP 			AJUSTE_PRESENTACION_1
SUBIR_R6: ; DISTRIBUIDOR valores validos 0 1 2
	INC				R6
	LDI				R24,3
	CP				R6,R24
	BRNE			SUBIR_R61
	LDI				R24,1
	MOV				R6,R24
SUBIR_R61:
	RJMP 			AJUSTE_PRESENTACION_1	
BAJAR_R6:
	DEC				R6
	MOV				R24,R6
	CPI				R24,1
	BRLO			BAJAR_R61
	LDI				R24,3
	MOV				R6,R24
BAJAR_R61:
	RJMP 			AJUSTE_PRESENTACION_1

SUBIR_R5: ; SELECIONA EL MODELO valores validos 0 1 2 3 4 5

	INC				R5
	LDI				R24,6
	CP				R5,R24
	BRNE			SUBIR_R51
	LDI				R24,0
	MOV				R5,R24
SUBIR_R51:
	RJMP 			AJUSTE_PRESENTACION_1	
BAJAR_R5:
	DEC				R5
	MOV				R24,R5
	CPI				R24,1
	BRLO			BAJAR_R51
	LDI				R24,3
	MOV				R6,R24
BAJAR_R51:
	RJMP 			AJUSTE_PRESENTACION_1




SALIR_AJUSTE:
CALL			APAGAR_FUENTE
CBI				PORTD,6
	LDI				R17,texto_presentacion
	MOV				R18,R4
	RCALL			EEPROM_ES
	LDI				R17,texto_presentacion + 1
	MOV				R18,R5
	RCALL			EEPROM_ES
	LDI				R17,texto_presentacion + 2
	MOV				R18,R6
	RCALL			EEPROM_ES

;	LDI				R17,PH_SB			; OPCION INICIAL BAJAR PH
;	LDI				R18,0				; VALOR A GRABAR CERO
;	RCALL			EEPROM_ES
	LDI				R17,RETARDO_INICIO	; OPCION INICIAL MODO VALENCIA
	LDI				R18,0				; VALOR A GRABAR CERO
	RCALL			EEPROM_ES
;	CALL			AJUSTE_PRODUCION	; SOLO PARA EL CASO DE QUE LA PISCINA TENGA CUBIERTA AUTOMATICA
	CALL			COMPARA2
	LDI				R18,00
	MOV				VAL_LED,R18
	CALL			LEDPANT
	LDI				R22,00
AJUSTE_PRESENTACION_3:					; RETARDO TECLADO
	CPI				R22,100
	BRLO			AJUSTE_PRESENTACION_3	
	CALL			L_HORA_1			; PARA INCREMENTAR 1 HORA, RESULTADO 000 HORAS
	RET

AJUSTE_PRESENTACION_4: ;CONFIGURA LA PANTALLA DE PRESENTACION

 



; FABRICANTE O VENDEDOR LA VARIABLE ES R6
    LDI   			YH,HIGH (LIN2P)    	; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN2P)     	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO4*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO4*2) 	; direccion baja del TEXTO en Flash 
	LDI				R16,16
	MUL				R16,R6				; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL,R0				; Y SUMA EL RESULTADO A ZL
    LDI   			R16,16      		; longitud de texto a copiar en RAM
CARGATEXTO_4:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y,R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGATEXTO_4  		; NO...seguimos cargando 
MOV	R16,R6
CPI R16,0
BRNE CARGATEXTO_4A ; SI NO ES CERO LO HACE NORMAL VA A CARGATEXTO_4A
	LDI   			YH,HIGH (LIN1P)    	; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN1P)     	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO4*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO4*2) 	; direccion baja del TEXTO en Flash 
	LDI				R16,16
	MUL				R16,R6				; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL,R0				; Y SUMA EL RESULTADO A ZL
    LDI   			R16,16      		; longitud de texto a copiar en RAM
CARGATEXTO_4B:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y,R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGATEXTO_4B  		; NO...seguimos cargando 
	RET

CARGATEXTO_4A:
; CONFIGURA LINEA TRES DISTRIBUIDOR TIPO POTENCIA
	LDI   			YH,HIGH (LIN1P)     ; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN1P)+12     ; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO3*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO3*2) 	; direccion baja del TEXTO en Flash 
	LDI				R16,4				; LONGITUD DEL TEXTO
	MUL				R16,R4				; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL,R0				; Y SUMA EL RESULTADO A ZL
    LDI   			R16,4      		; longitud de texto a copiar en RAM
CARGATEXTO_3:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y, R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1				; incrementa en una unidad      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGATEXTO_3  		; NO...seguimos cargando 
; EN LINEA TRES PONE SALICLOR O AQUABEST

; MODELO POSICION EN RAM
    LDI   			YH,HIGH (LIN1P)     ; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN1P)		; direccion baja donde se pone el texto en RAM 
	MOV				R18,R6
	CPI				R18,2				; 2 ES AQUABEST
	BRNE			CARGATEXTO_51		; SI ES DISTINTO 
    LDI   			ZH,high(TEXTO4A*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO4A*2) 	; direccion baja del TEXTO en Flash 
	RJMP			CARGATEXTO_52
CARGATEXTO_51:		; CARGA SALICLOR
    LDI   			ZH,high(TEXTO4A*2)	; direccion alta del TEXTO en Flash
	LDI   			ZL,low(TEXTO4A*2)+16; direccion baja del TEXTO en Flash 
CARGATEXTO_52:
	LDI				R18,2				; POSICION DEL TEXTO EN RAM 
	MUL				R16,R18				; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL,R0				; Y SUMA EL RESULTADO A ZL
    LDI   			R16,9    	  		; longitud de texto a copiar en RAM
CARGATEXTO_5:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y, R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1				; incrementa en una unidad      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGATEXTO_5  		; NO...seguimos cargando 
; CARGA EL TIPO DE EQUIPO SAL MAGNESIO O BAJO EN SAL
    LDI   			YH,HIGH (LIN1P)     ; direcion alta donde se pone el texto en RAM
    LDI   			YL,LOW (LIN1P)+9	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO3A*2)	; direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO3A*2) 	; direccion baja del TEXTO en Flash 
	LDI				R16,4				; LONGITUD DE TEXTO
	MUL				R16,R5				; MULTIPLICA POR 16 EL VALOR DE LA POSICION EN EEPROM
	ADD				ZL,R0				; Y SUMA EL RESULTADO A ZL
    LDI   			R16,4    	  		; longitud de texto a copiar en RAM
CARGA_TEXTO_6:
	LPM      							; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   				; apuntamos al siguiente elemento 
	ST    			Y, R0				; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1				; incrementa en una unidad      		
	DEC   			R16      			; Hemos terminado..?? 
	BRNE  			CARGA_TEXTO_6  		; NO...seguimos carga
	RET



PAR_MOD_DIS: ; LEE DE LA EEPROM R4,R5,R6 PARA CONFIGURAR LINES 2 Y3 DE PRESENTACION
	LDI				R17,texto_presentacion
	RCALL			EEPROM_RW
	MOV				R4,R18
	LDI				R17,texto_presentacion + 1
	RCALL			EEPROM_RW
	MOV				R5,R18
	LDI				R17,texto_presentacion + 2
	RCALL			EEPROM_RW
	MOV				R6,R18
	RET


AJUSTE_AMPERIOS:
	LDI				R26,140; RAMC_SAL		; NUMERO DE MEDICIONES
	LDI				R18,6;P_SAL			; LINEA DE ENTRADA EN EL CONVERTIDOR
	CALL			ADC_P
	STS				AMP_PWM+4,R24
	CALL			RADC
;	STS				$7DE,R1
	STS				$7DE,R2						; VALOR DE LAS DECENAS LO COLOCA EN LA LINEA 1 DE MODELO
	STS				$7DF,R3						; VALOR DE LAS UNIDADES
	RET
