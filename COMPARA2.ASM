COMPARA2:
	PUSH			R18				; SALVAMOS EL REGISTRO A UTILIZAR Y LA GUARDAMOS EN LA PILA
	CLR				R18				; SE LIMPIA EL REGISTRO A UTILIZAR
	MOV				R0, R18			; Y LOS DEMAS
	MOV				R1, R18
	MOV				R2, R18
	MOV				R3, R18
	LDI   			ZH, $23			; direccion alta del TEXTO en Flash
	LDI   			ZL, $00			; direccion baja del TEXTO en Flash 
	LDI   			R16,250     	; longitud de texto a copiar en RAM
CARGATEXTO_3A:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,10  			; apuntamos al siguiente elemento 
	ADD   			R2, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	BRVC			CARGATEXTO_3A1
	INC				R3
CARGATEXTO_3A1:
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_3A  	; NO...seguimos cargando 
	RCALL			ACT1
	LDI				R30, $024		; POSICION 0x26
	CP				R2, R30
	BRNE			ACT
	LDI				R31, $029		; POSICION 0x27
	CP				R3, R31
	BRNE			ACT
	LDI				R18, 251		; SI SE MENOR PONE EL PH NORMAL
	LDI				R17, $025
	CALL			EEPROM_ES		; ACTUALIZA LA EEPROM
	SET
	BLD				CONTROL_1, 4
	POP				R18
	RET
ACT:
	CLT
	BLD				CONTROL_1, 4
	LDI				R18, 255		; SI SE MENOR PONE EL PH NORMAL
	LDI				R17, $025
	CALL			EEPROM_ES		; ACTUALIZA LA EEPROM CON EL VALOR INICIAL
	POP				R18
	RET	
ACT1:
	MOV				R18, R2
	LDI				R17, $026
	CALL			EEPROM_ES
	MOV				R18, R3
	LDI				R17, $027
	CALL			EEPROM_ES
	RET

