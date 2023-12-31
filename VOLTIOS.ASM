; RUTINA PARA PRESENTAR EN PANTALLA GRAFICA LOS VALORES DE TENSION Y PRO. DE CLORO
VOLTIOS:
; TENSION SALIDA DE FUENTE
	LDI				R18,P_VFUENTE		; LINEA A LEER
	LDI				R26,81				; NUMERO DE LECTURAS
	CALL			ADC_P
	STS				S_FUENTE,R24		; GRABA EL VALOR EN S_FUENTE
	CALL			RADC

;	STS				$3B0,R1
	STS				$3B0,R2				; RESULTADO DE DECENAS
	STS				$3B2,R3				; RESULTADO UNIDADES
STS $72C,R2
STS $72E,R3			; PONE LOS VALORES DE LA TENSION DE LA FUENTE EN PANTALLA GRAFICA
; LEE EL VOLTAJE DE SALIDA PARA DECIDIR TIPO DE AVERIA 
	LDI				R18,P_VSAL			; LINEA A LEER
	LDI				R26,81				; NUMERO DE LECTURAS
	CALL			ADC_P
	LDI				R18,0x4E			; ESCRIBE UNA N
	STS				$3B4,R18
STS		$730,R18		; PONE EN PANTALLA GRAFICA
	LDI				R18,0x4F			; ESCRIBE UNA O
	STS				$3B5,R18
STS		$731,R18		; PONE EN PANTALLA GRAFICA
	CPI				R24,25
	BRLO			VOLTIOS_A
	LDI				R18,0x53
	STS				$3B4,R18				; RESULTADO DE DECENAS
STS		$730,R18		; PONE EN PANTALLA GRAFICA
	LDI				R18,0x49
	STS				$3B5,R18				; RESULTADO UNIDADES
STS		$731,R18		; PONE EN PANTALLA GRAFICA
VOLTIOS_A:

	LDI				R18, P_TCL			; LEE LOS AMPERIOS
	LDI				R26, 110			; NUMERO DE LECTURAS
	CALL			ADC_P
	LDI				R16, 48				; PONE UN CERO
	STS				0x3BA, R16
	STS				0X736,R16
	LSR				R24					; SI ES PAR
	BRCC			VOLTIOS_B			; SALTA SI EL ACARREO ES UNO QUEDA EL CINCO
	LDI				R16,53				; PONE UN CINCO EN LUGAR DEL 0
	STS				$3BA,R16
	STS				0X736,R16
VOLTIOS_B:
	CALL			RADC
	STS				$74B, R2
	STS				$74C, R3			
STS				$733, R2
STS				$734, R3		; PONE EL VALOR DE LA PRODUCION DE CLORO EN PANTALLA GRAFICA

	RET	



