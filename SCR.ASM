; RUTINA DESPLAZAMIENTO DE LA LINEA 4 PANTLLA 20X4

SCR:			;RUTINA DE CONTROL
	LDI				R16,212				; 11000000 escribir en linea 2 linea (192)( linea 4 seria 212)
	CALL			ENVINT
	LDI				YH,HIGH(SCR_LIN)	; POSICION ALTA DEL TAXTO EN RAM
	LDI				YL,LOW (SCR_LIN)+5	; direccion BAJA DEL TEXTO EN RAM      	
 	ADD				YL,LEC_REL
  	LDI				R17,20 				; bytes a enviar 
	CALL			ENVIARTEXTO			; RUTINA PARA ENVIAR TEXTO A PANTALLA
	RET
;       20x4        16x4   tipo de display
; linea 1-128 		128 
; linea 2-192		192
; linea 3-148		144
; linea 4-212		208
