;                PROTOCOLO I2C INTERNO DEL AT MEGA 16
		; ------------------LOS PINES SCL Y SDA SE HAN DE CONFIGURAR COMO SALIDA -------------------------
		; RUTINA PARA LA LECTURA DEL CONVERTIDOR ANALOGICO DIGITAL PCF8574
		; EL DATO A GRABAR EN R17
		; ESTA RUTINA NO VERIFICA QUE EL CONVERTIDOR RESPONDA PUEDE NO ESTAR PRESENTE
ERROR_1_C:  ; NO HAY MODULO
	RET

PCF_C:
	CLR				R24
	CLR				R1
	CBI				PORTC, 1	; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	CBI				DDRC, 1		; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	CBI				PORTC, 0	; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	CBI				DDRC, 0		; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	RCALL			I2C_ATMEGA_C
	LDI				R16, 00
	OUT				TWAR, R16		; DIVISOR DE FRECUENCIA
	OUT				TWBR, R16
	OUT				TWDR, R16
	OUT				TWSR, R16
	SBI				PORTC, 1	; PONE EL PUERTO C PORT 1 COMO SALIDA DE DATOS
	SBI				DDRC, 1		; PONE EL PUERTO C PORT 1 COMO SALIDA DE DATOS
	SBI				PORTC, 0	; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	SBI				DDRC, 0		; PONE EL PUERTO C PORT 1 COMO ENTRADA DE DATOS
	RET


I2C_ATMEGA_C:
; INICIALIZACION DEL PERIFERICO A 400KHZ

	LDI		R16, 2
	OUT		TWBR, R16		; DIVISOR DE FRECUENCIA
	LDI		R16, (1<<TWPS1) | (1<<TWPS0)
	OUT		TWSR, R16		; REGISTRO DE CONTROL

; CONDICION DE START
	LDI		R16, (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)
	OUT		TWCR, R16

ESPERA1_C: ; ESPERA EL ENVIO DE LA CONDICION START
	IN		R16, TWCR
	SBRS	R16, TWINT
	RJMP	ESPERA1_C
; CHEQUEAR SI HA HABIDO ERROR EN EL ENVIO DE LA ORDEN START
;	IN		R16, TWSR
;	ANDI	R16, 0xF8
;	CPI		R16, I2C_START
;	BRNE	ERROR_1_C	;  ****AQUI HAY UN ESCESO DE SALTO SE PONE UN RET DIRECTO
; CARGA EN TWDR LA DIRECION DEL PERIFERICO A LEER 
	LDI		R16, 0B01000000 + W
;LSL R17
;ADD R16, R17
	OUT		TWDR, R16
	LDI		R16, (1<<TWINT) | (1<<TWEN)
	OUT		TWCR, R16
; ESPERA EL ENVIO DE LA DIRECION DEL PERIFERICO
ESPERA2_C:
	IN		R16, TWCR
	SBRS	R16, TWINT
	RJMP	ESPERA2_C
; CHEQUEAR SI HA HABIDO ERROR EN EL ENVIO DE LA DIRECION DEL PERIFERICO
; SI NO HAY MODULO POS YA ESTA FIN
	IN		R16, TWSR
	ANDI	R16, 0xF8
	CPI		R16, MT_SLA_ACK
	BRNE	ERROR_1_C		; SI NO HAY PERIFERICO TERMINA LA RUTINA

; CHEQUEAR SI HA HABIDO ERROR EN EL ENVIO DE LA DIRECION DEL PERIFERICO
;	IN		R16, TWSR
;	ANDI	R16, 0xF8
;	CPI		R16, MR_SLA_ACK
;	BRNE	ERROR_C

;ESCRIBIR EL DATO
	MOV				R16, R17
	OUT				TWDR, R16
	LDI				R16, (1<<TWINT) | (1<<TWEN)
	OUT				TWCR, r16
; ESPERA EL ENVIO DEL DATO AL PERIFERICO
ESPERA3_C:
	IN				R16, TWCR
	SBRS			R16, TWINT
	RJMP			ESPERA3_C
; TRANSMITIR SE�AL DE STOP
	LDI		R16, (1<<TWINT)|(1<<TWEN)|(1<<TWSTO)
	OUT		TWCR, R16
	RET
ERROR_C:
	RET

