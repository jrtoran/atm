;  DATOS PANTALLA 2 DE 20x4

; PASA EL TEXTO A RAM POSICION $ 100 DE FLASN POSICION TEXTO6 Y TEXTO7 CSEG 1580

;cargamos TEXTO PANTALLA DOS   
 



INI_LCD_2: 
    LDI   			YH,0x04        	; direcion alta donde se pone el texto en RAM VALOR ANTIGUO 00
    LDI   			YL,0x20      	; direccion baja donde se pone el texto en RAM VALOR ANTIGUO EC
    LDI   			ZH,high(TEXTO6*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO6*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,180      	; longitud de texto a copiar en RAM
;*** RURINA CARGAR TEXTO DE FLASH A RAM  
;EN Y (YH,YL) POSICION EN RAM
;EN Z (ZH,ZL) POSICION EN FLASH
;EN R16 NUMERO DE LETRAS (BYTS)

CARGATEXTO_2A:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2A  	; NO...seguimos cargando 

; SEGUNDA PARTE NO SE PUEDE HACER EN UNA POR SUPERAR LOS 255 CARACTERES
    LDI   			YH,0x05        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0x10      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO7*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO7*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,240      	; longitud de texto a copiar en RAM
;*** RURINA CARGAR TEXTO DE FLASH A RAM  
;EN Y (YH,YL) POSICION EN RAM
;EN Z (ZH,ZL) POSICION EN FLASH
;EN R16 NUMERO DE LETRAS (BYTS)

CARGATEXTO_2AA:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2AA 	; NO...seguimos cargando 


; SEGUNDA PARTE NO SE PUEDE HACER EN UNA POR SUPERAR LOS 255 CARACTERES
    LDI   			YH,0x06        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0x00      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO8*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO8*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,240      	; longitud de texto a copiar en RAM
;*** RURINA CARGAR TEXTO DE FLASH A RAM  
;EN Y (YH,YL) POSICION EN RAM
;EN Z (ZH,ZL) POSICION EN FLASH
;EN R16 NUMERO DE LETRAS (BYTS)

CARGATEXTO_2BA:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2BA 	; NO...seguimos cargando 

    LDI   			YH,0x06        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0xF0      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO9*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO9*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,240      	; longitud de texto a copiar en RAM
;*** RURINA CARGAR TEXTO DE FLASH A RAM  
;EN Y (YH,YL) POSICION EN RAM
;EN Z (ZH,ZL) POSICION EN FLASH
;EN R16 NUMERO DE LETRAS (BYTS)

CARGATEXTO_2BB:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2BB 	; NO...seguimos cargando 

    LDI   			YH,0x08        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0xF8      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO10*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO10*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,240      	; longitud de texto a copiar en RAM

CARGATEXTO_2BC:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2BC 	; NO...seguimos cargando 


;  PONE EL TEXTO DE FLASH A RAM
   LDI   			YH,0x09        	; direcion alta donde se pone el texto en RAM
    LDI   			YL,0xFC      	; direccion baja donde se pone el texto en RAM 
    LDI   			ZH,high(TEXTO11*2); direccion alta del TEXTO en Flash
    LDI   			ZL,low(TEXTO11*2) ; direccion baja del TEXTO en Flash 
    LDI   			R16,200      	; longitud de texto a copiar en RAM

CARGATEXTO_2BD:
	LPM      						; leemos TEXTO de FLASH y lo almacena en R0
	ADIW  			ZL,1   			; apuntamos al siguiente elemento 
	ST    			Y, R0			; guardamos en RAM POSICION Y EL CONTENIDO DE R0
	ADIW  			YL,1      		
	DEC   			R16      		; Hemos terminado..?? 
	BRNE  			CARGATEXTO_2BD 	; NO...seguimos cargando 



	RET     						; SI...terminamos 

