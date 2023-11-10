; PANEL_A CONTROLA EL MODULO DE 16 DIGITOS LUMINOSO
; LA LINEA OE ES RESET DE PANEL
; en R24 el digito, en el micro  puertos B-  5 dato  6 reloj  "7 OE ACTIVAR SALIDA"  OJO TAMBIAN SE USA PARA RADIO


PANEL:

;	CBI			PORTB, PANEL_OE		; PONE A UNO PARA INHIBIR LA SALIDA OJO ES INVERTIDA DESPUES LA SEÑAL POR EL 74HC132

	CBI			PORTB, PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB, PANEL_CLK
;	SBI			PORTB, PANEL_OE		; PONE A UNO PARA QUE SE VISUALICEN LOS NUMEROS ( ES INVERTIDA LA SEÑAL )
	LDI			R18, 16				; NUMERO DE CARACTERES
	RJMP		BYTA
PANEL_1:
	DEC			R16
	BRNE		BYTA				; VA A BYTA SI ES DISTINTO DE CERO	
	
	RET

BYTA:
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 7				; si es cero salta la siguiente instrucion
	SBRC		R24, 3				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A UNO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO

; BYT 1
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 6				; si es cero salta la siguiente instrucion
	SBRC		R24, 2				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO

; BYT 2
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 5				; si es cero salta la siguiente instrucion
	SBRC		R24, 1				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO

; BYT 3
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 4				; si es cero salta la siguiente instrucion
	SBRC		R24, 0				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO

; BYT 4
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 3				; si es cero salta la siguiente instrucion
	SBRC		R24, 5				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO


; BYT 5
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 2				; si es cero salta la siguiente instrucion
	SBRC		R24, 6				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO

; BYT 6
	CBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	CBI			PORTB,  PANEL_CLK	; PONE A CERO EL NIVEL DEL RELOJ
;	SBRC		R24, 1				; si es cero salta la siguiente instrucion
	SBRC		R24, 4				; si es cero salta la siguiente instrucion
	SBI			PORTB,  PANEL_DATA	; PONE A CERO EL BIT 0 DEL PUERTO B
	LDI 		R25, retardo_panel
	CALL		RETARDO
	SBI			PORTB,  PANEL_CLK	; SEÑAL DEL RELOJ A UNO DATO VALIDO
	LDI 		R25, retardo_panel
	CALL		RETARDO


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
	RJMP		PANEL_1

