; PONER EN LA FUENTE UNA TENSION DE 7,5V Y MEDIR ENTRE NEGATIVO Y LA PATA 3 DEL LM331 UNA FRECUENCIA DE 2000Hz
; EN LA PANTALLA DE INICIO DEVERA INDICAR 5,6
; LA PANTALLA DEBERA INDICAR UNA CONCENTRACION DE 4KG POR METRO CUBICO
; LA FUENTE HAY QUE LIMITARLA A 18 AMPERIOS 


CONTROL_SAL:
	WDR							; ACTUALIZA EL PERRO GUARDIAN

	MOV				R31, R6


	LDI				R16, 35		; 3.5 GRAMOS
	LDI				R30, 64		; valor leido que corresponde con la concentracion de sal de 3,5 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a SAL1

	LDI				R16, 40		; 4.0 GRAMOS
	LDI				R30, 62		; valor leido que corresponde con la concentracion de sal de 4,0 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a SAL1

	LDI				R16, 45		; 4.5 GRAMOS
	LDI				R30, 59		; valor leido que corresponde con la concentracion de sal de 4,5 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a SAL1

	LDI				R16, 50		; 5.0 GRAMOS
	LDI				R30, 56		; valor leido que corresponde con la concentracion de sal de 5,0 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a SAL1

	LDI				R16, 55		; 5,5 GRAMOS
	LDI				R30, 53		; valor leido que corresponde con la concentracion de sal de 5,5 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a reset1

	LDI				R16, 60		; 6,0 GRAMOS
	LDI				R30, 50		; valor leido que corresponde con la concentracion de sal de 6,0 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a reset1

	LDI				R16, 65		; 6,5 GRAMOS
	LDI				R30, 48		; valor leido que corresponde con la concentracion de sal de 6,5 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a reset1

	LDI				R16, 70
	LDI				R30, 46		; valor leido que corresponde con la concentracion de sal de 7,0 gramos
	CP				R31, R30
	BRBC			0,SAL1		; si R31 es mayor va a reset1

SAL1:
	MOV				R6, R16		; PONE EN R16 EL VALOR DE LA CONCENTRACION DE SAL EQUIVALENTE A LA FRECUENCIA LEIDA
	RET
