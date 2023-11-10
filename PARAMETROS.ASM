
;		ESTOS SON LOS VALORES PREFIJADOS "PARAMETROS"
.def  temp_tec = r7
.def  val_led = r15		;posicion en RAM del valor de los led de pantalla
.equ  lcd_rw =$007		;bit de lectura escritura de la pantalla lcd
.equ  lcd_rs =$005		;bit para enviar datos o instruciones
.equ  led_pant =$004	;al subir graba los valores de los led
.equ  lcd_e =$006		;bit para validar los datos al descender

; POSICION DE LOS LED  Y CONTROL DEL TECLADO EN val_led (r15)
.equ  vel_tec = 120		; RETARDO EN LA VELOCIDAD DE SUBIDA O BAJADA EN PROGRAMACION DE PARAMETROS
.equ  PH =  007
.equ  CL =  006
.equ  ON =  005
;.equ  POLARIDAD = 4
.equ  MAX=  004
.equ  MIN=  003
.equ  TEC=  003			; activar teclado teclado activo con valor cero
.equ  LUZ=  002			; luz pantalla
.equ  SCL=  000			; linea de reloj para i2c
.equ  SDA=  001			; linea de datos para i2c
.def  rec_datos = r19	; recibir datos de la linea i2c
.equ  start= 6
.equ  oe   = 7
.equ  clk  = 6
.equ  eoc  = 2
.equ  EOL = 0x5E
.equ  RELOAD = 0x5F
; PARAMETROS

;.equ  cen_seg = $190
.def  lec_rel= r23			; los segundos en la interrupcion solo se usa en el programa principal
.equ  ph_max = 80
.equ  ph_min = 65
.equ  cl_max = 20
.equ  cl_min = 06
.equ  pro_max = 100			; 100%
.equ  pro_min = 05			; 5%
.equ  rd_max = 195			; 180 X 5 = 900
.equ  rd_min = 060			; 060 X 5 = 300
.equ  retardo_panel = 1		; para el control DEL PANEL RETARDO

; POSICION EN EEPRON DE LOS VALORES PROGRAMADOS
.equ  ph_men = $000			; posicion del ph programado en eepron
.equ  pro_men = $001		; posicion del tanto por ciento programado en eepron
.equ  cl_men = $002			; posicion del cloro de la piscina programado en eepron
.equ  rd_men = $003			; posicion del redox programado en eepron
.equ  clc_men = $004		; posicion para el calibrado del cloro libre
.equ  phc_men = $005		; posicion para el calibrado del Ph
.equ  sac_men = $006		; posicion para el calibrado de la sal
.equ  rdc_men = $007		; posicion para el calibrado del redox
.equ  pol_men = $010		; munero de veces que se ha encendido para la polaridad
.equ  ver_inv = $011		; verano-invierno se usa para la medicion de sal
.equ  sonda_caudal = $013	; con sonda de caudal
.equ  texto_presentacion = $012	; leer en la eepron  POTENCIA $012 y TYPO EN $012 + 1 DISTRIBUIDOR $012 + 2

; POTENCIA 		00 50					01 80			02 120	 	 03 180		04 220
; TYP0			00 L					01 LS			02 LMG		 03 Q 		04 QS 		05 QMG
; DISTRIBUIDOR	00 SALICLOR SERIE L		01 TEAP S.L. 	02 Aipool	 03 "            "
.equ  ph_sb = $022			; subir a bajar el Ph
.equ  pa_pm = $023			; producion manual o automatica anula la medicion de redox y cloro si es uno
.equ  re_pro = $024			; valor de reducion de la producion con cubiera
.equ  ciclos_minuto =$028	; NUMERO DE CICLOS PARA LA INVERSION MAX 4
.equ  ee_ciclos = $030		; VECES QUE SE ENCIENDE EN 1 CICLO 2-3-4,POSICION 31-32-33-34
.equ  n_min20 		= $048	; 6 min igual a 1 hora
.equ  n_horas 		= $049	; NUMERO DE HORAS FUNCIONANDO
.equ  n_horas_1 	= $04A	; NUMERO DE HORAS X 256
.equ  n_borrado		= $04B	; veces que se borran las horas
.equ  n_horasc		= $04C	; copia de seguridad de horas no se borran
.equ  n_horasc_1	= $04D
.equ  reg_rejilla 	= $050	; para la grabacion del desgaste de la rejilla VALOR SUPERIOR +8
.equ  apoyo_rd_cl 	= $060	; VALOR PARA ACTIVAR LA BOMBA DOSIFICADORA DE APOYO CLORO Y REDOX
.equ  retardo_inicio= $099	; RETARDO AL INICIO 20 O 240 SEGUNDOS
.equ  des_elect 	= $09B 
.equ  sensor_flujo	= $09D  ; SENSOR DE FLUJO ACTIVO A 0 A 1 VALOR INICIAL
.equ  polaridad_0	= $09E	; MEDICION DE SAL EN POLARIDAD 0
.equ  polaridad_1	= $09F	; MEDICION DE SAL EN POLARIDAD 1
.equ  mejor_polaridad =$0A0 ; POLORIDAD MAS EFICAD CERO O UNO "0 - 1"
.equ  inc_polaridad = 10		; DIFERENCIA ENTRE AMBAS POLARIDADES
; EN 9C ESCRIBE EL PORCENTAJE DE DESGASTE

;.equ r_seg = $090
;.equ r_min = $091
;.equ r_hor = $092
;.equ r_dia = $093
;.equ r_mes = $094
;.equ r_ano = $095
;.equ r_otro	= $096

; ZONA PARA ALMACENAR LOS VALORES MEDIDOS DE PH,RD, CL EN MEMORIA RAN DEL MICRO
.equ  ram_ph 		= $200	; VALOR LEIDO PERO AMORTIGUADO " QUITADA LA OSCILACION"
.equ  ramp_ph 		= $201	; VALOR PROGRAMADO DEL PH
.equ  ramc_ph 		= $202	; VALOR PARA EL AJUSTE POR TECLADO DEL PH
.equ  ph_real 		= $203	; VALOR PUNTUAL REAL
.equ  ram_pro 		= $204	; VALOR LEIDO
.equ  ramp_pro 		= $205	; VALOR PROGRAMADO
.equ  ram_cl 		= $206	; valor leido cloro
.equ  ramp_cl 		= $207	; valor programado cloro
.equ  ramc_cl 		= $208	; VALOR PARA AL AJUSTE DE LA SONDA ECL6 POR TECLADO
.equ  redox_real	= $223	; ALMACENA EL REDOX REAL PARA TACTIL
.equ  ram_rd 		= $209	; VALOR DEL REDOX REAL
.equ  ramp_rd 		= $20A	; VALOR DEL REDOX PROGRAMADO
.equ  ramc_rd 		= $20B	; VALOR PARA EL AJUSTE DEL REDOX
.equ  ram_sal 		= $20C	; VALOR INICIAL DE CONCENTRACION DE SAL
.equ  ramc_sal 		= $20D	; VALOR PARA EL AJUSTE DE LA CONCENRACION DE SAL
.equ  ram_pol 		= $20E	; VALOR EN RAM LA POLARIDAD GUARDADO EN RAM
.equ  ram_temp 		= $20F	; VALOR EN RAM DE LA TEMPERATURA
.equ  ram_sal_c 	= $210
.equ  ram_sal_corte = $211
.equ  ram_pro_pro 	= $212	; % reducion de la producion con cubierta
.equ  ram_pro_pro_m = $213	; PORCENTAJE CON CUBIERTA
.equ  ram_ciclos	= $214
.equ  ram_caudal 	= $215	; SEGUNDOS RETRASO CAUDAL PARA CORTAR POR FALTA DE FLUJO
.equ  ram_rd_cl		= $216	; POSICION EN RAN DEFERENCIA PARA ACTIVAR LA DOSIFICACION DE APOYO CL_RD
.equ  ram_amperios 	= $217	; AMPERIOS DEL SHUNT
.equ  pro_remoto_1 	= $218	; PRODUCCION EN GRAMOS HORA 
.equ  pro_remoto_2 	= $219	; PRODUCCION EN GRAMOS HORA 
.equ  pro_remoto_3 	= $21A	; PRODUCCION EN GRAMOS HORA 
.equ  pro_remoto_4 	= $21B	; PRODUCCION EN GRAMOS HORA 
.equ  prod_total	= $21C
.equ  i2c_control	= $21D	; registro de datos para el pcf 8574
.equ  ram_med_ini_sal = $21E; VALOR INICIAL DE SAL POR ERROR DEL TLC27
.equ  nciclos		= $21F	; NUMERO DE CICLOS PARA LA INVERSION DE POLARIDAD
.equ  sal_electrodo = $220	; VALOR MAXIMO SEGUN POLARIDAD
.equ  hora = $400			; posicion en ram
.equ  minu = $401
.equ  seg  = $402
.equ  analogico = $420

.equ  panel_OE =  7			; PARA EL PANEL EXTERNO ACTIVO O INACTIVO
.equ  panel_data= 5			; PARA EL PANEL EXTERNO BIT DEL DATO
.equ  panel_clk = 6			; PARA EL PANEL EXTERNO RELOJ GRABA EL DATO
.def  control = r20			; REGISTRO DE CONTROL VER OPCIONES EN ATMEGA16.ASM PRIMERAS LINEAS " NO UTILIZAR EN RUTINAS "
.def  control_1 = r11		; SEGUNDO REGISTRO DE CONTROL " NO UTILIZAR EN RUTINAS "
.equ  max_sal = 190
.equ  min_sal = 00
			.equ  t_ciclo = 36					; SEGUNDOS POR CICLO 33 CON CRISTAL DE CUARZO ***********************************************
.equ  lim_sal = 10			; PARA DAR INFORMACION AÑADIR SAL
.equ  lim_sal2 = 1			; limite de amperios en control remoto
.equ  ri2c = 5				; SALIDA PROTOCOLO I2C
.equ  b_acido = 5			; salida para el control de la bomba de acido

;.equ  s2_rd_cl	= 5			; salida para el apoyo de redox y cloro 

.equ  eeprom = 0b10100000
.equ w = 0					; opcion escribir PARA PCF8591
.equ r = 1					; opcion leer PARA PCF8591
.equ pcf8591 = 0B10010000	; modulos de PH RD CL Y SAL DIRECION DE CONTROL
.equ retardo_programacion = 15
.equ retardo1 = 10			; es el retardo para cambio de opcion en programacion
.equ retardo2 = 26			; retardo digito encendido RETARDO2- RETARDO3
.equ retardo3 = 12			; retardo digito apagado
.equ E_fuente = 3
.equ t_radio_ini = 40
.equ t_radio_e = 8
.equ data_t = 7				; linea salida de datos por radio

.equ lec_eeprom = $350
.equ m_prueba = $200
; linea de entrada para medidas analogicas del atmega64
.equ p_sal = 6
.equ p_cl = 1
.equ p_rd = 2
.equ p_ph = 3
.equ p_vsal = 4
.equ p_vfuente = 5
.equ p_tcl = 6
.equ p_temp = 7






