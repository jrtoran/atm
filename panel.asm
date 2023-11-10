; PANEL
; Enviar datos a un panel formado por el 74hc4094 y el uln2003A
; en R24 el digito, en el micro  puertos B-  5 dato  6 reloj  "7 OE ACTIVAR SALIDA"  OJO TAMBIAN SE USA PARA RADIO


; orden de envio para
; panel TPIC6B565N			panel 4094
;  Q7  -  G  -  1  				E	3  
;  Q6  -  dp -  0				F	2
;  Q5  -  B  -  6				G	1
;  Q4  -  D  -  4				Bp	0
;  Q3  -  C  -  5				C	5
;  Q2  -  E  -  3				B	6
;  Q1  -  A  -  7				D	4
;  Q0  -  F  -  2				A	7


PANEL:

;	CBI			PORTB, PANEL_OE		; PONE A UNO PARA INHIBIR LA SALIDA OJO ES INVERTIDA DESPUES LA SEÑAL POR EL 74HC132
	RCALL		RADC
	MOV 		R24, R3				; NUMERO A ENVIAR A PANEL
	SUBI		R24, 48				; RESTA PARA CONVERTIR EL ASCI EN DECIMAL
	RCALL		BCD					; CALCULA LOS PALITOS A ENCENDER PRIMER NUMERO
	RCALL		BYTA				; ENVIA EL BYT AL PANEL
	MOV			R24, R2				; EL SEGUNDO NUMERO ETC...
	SUBI		R24, 48
	RCALL		BCD
	RCALL		BYTA
;	MOV			R24, R1				; EL TERCER NUMERO ETC...
;	SUBI		R24, 48
;	RCALL		BCD
;	RCALL		BYTA	
	CBI			PORTB, PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB, PANEL_CLK
;	SBI			PORTB, PANEL_OE		; PONE A UNO PARA QUE SE VISUALICEN LOS NUMEROS ( ES INVERTIDA LA SEÑAL )
	RET

BYTA:
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 7				; si es cero salta la siguiente instrucion
	SBRC		R24, 3				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A UNO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO

; BYT 1
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 6				; si es cero salta la siguiente instrucion
	SBRC		R24, 2				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO

; BYT 2
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 5				; si es cero salta la siguiente instrucion
	SBRC		R24, 1				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO

; BYT 3
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 4				; si es cero salta la siguiente instrucion
	SBRC		R24, 0				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO

; BYT 4
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 3				; si es cero salta la siguiente instrucion
	SBRC		R24, 5				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO


; BYT 5
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 2				; si es cero salta la siguiente instrucion
	SBRC		R24, 6				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO

; BYT 6
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 1				; si es cero salta la siguiente instrucion
	SBRC		R24, 4				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO


; BYT 7
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 0				; si es cero salta la siguiente instrucion
	SBRC		R24, 7				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	RCALL		RETARDO
	RET

BCD:   ;CALCULO DE LOS DIGITOS A ENCENDER

	CPI			R24, 0
	BRBC		1, BCD1
	LDI			R24, 0B11111100
	RET
BCD1:
	CPI			R24, 1
	BRBC		1, BCD2
	LDI			R24, 0B01100000
	RET
BCD2:
	CPI			R24, 2
	BRBC		1, BCD3
	LDI			R24, 0B11011010
	RET
BCD3:
	CPI			R24, 3
	BRBC		1, BCD4
	LDI			R24, 0B11110010
	RET
BCD4:
	CPI			R24, 4
	BRBC		1, BCD5
	LDI			R24, 0B01100110
	RET
BCD5:
	CPI			R24, 5
	BRBC		1, BCD6
	LDI			R24, 0B10110110
	RET
BCD6:
	CPI			R24, 6
	BRBC		1, BCD7
	LDI			R24, 0B10111110
	RET
BCD7:
	CPI			R24, 7
	BRBC		1, BCD8
	LDI			R24, 0B11100000
	RET
BCD8:
	CPI			R24, 8
	BRBC		1, BCD9
	LDI			R24, 0B11111110
	RET
BCD9:
	LDI			R24, 0B11110110

	RET
