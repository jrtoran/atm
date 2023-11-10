; Frecuencimetro entrada en INT0 y INT1
; GIFR  es el flags de las interrupciones bit 7 int1 y bit 6 int0
; GIMSK registro general de interrupciones bit 7 int1 y bit 6 int0
; si de ponen a 1 se activa la entrada por interrupcio n
; SREG el bit 7 actiba la interrupciones en el micro poniendolo a 1
; existe una instrucion que activa la interrupciones en SREG es SEI, ya activada
; PH 7.0 corresponde a 1540khz v=2,19 en lm331 pata 6
; al subir la temperatura baja la frecuencia

FREC0:

	OUT				GIMSK, R16			; puerta d entrada 2 y 3
	WDR

FRECA:
	LDI				R16, 0b00001111		; Activar interrupcion por flanco
	OUT				MCUCR, R16 
	CLR				R22					; pone a cero el contador de tiempo
	OUT				TCNT0, R22			; PONE A CERO EL CONTADOR
	MOV     	    R4, R22
FRECB:

	CP	 			R22, R18			; R22 contador timer TIMER0_OVR interrupcion 245
	BRBS			0,FRECB
	LDI				R16, 0b00000000
	OUT				GIMSK, R16			; puerta d entrada 2 y 3 ANULADA
	RET

INT10:      ;INTERRUPCION SEÑAL DE SAL ENTRADA INT0
	INC				R4
	RETI
INT10B:
	RETI

INT11:      ;INTERRUPCION SEÑAL DE SAL ENTRADA INT1
	INC				R4					; SI R4 NO ES CERO
	RETI

