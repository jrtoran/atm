 ;- the routine writes one page of data from RAM to Flash
 ; the first data location in RAM is pointed to by the Y pointer
 ; the first data location in Flash is pointed to by the Z pointer
 ;- error handling is not included
 ;- the routine must be placed inside the boot space
 ; (at least the do_spm sub routine)
 ;- registers used: r0, r1, R16, R17, R24, R25, 21
 ; (R16, R17, R24, R25, 21 must be defined by the user)
 ; storing and restoring of registers is not included in the routine
 ; register usage can be optimized at the expense of code size

.DEF TEMP1=R16
.DEF TEMP2=R17
.DEF LOOPLO=R24
.DEF LOOPHI=R25
.DEF SPMCRVAL=R21
.EQU RAM_FLASH = $8000	; INICIO DE DATOS PARA RECIBIR EN FLASH
.EQU RAM_RAM = $45C		; INICIO DE DATOS PARA TRANFERIR EN RAM


.EQU PAGESIZEB = PAGESIZE*2;PAGESIZE  es 128 byt por 2 256 una pagina





ES_PAG_PRU:


; .org	FOURTHBOOTSTART
 ; Erase Page 1
; ldi	ZL,LOW(1<<7)
 ;ldi	ZH,HIGH(1<<7)
LDI 	ZL,LOW(RAM_FLASH)
LDI		ZH,HIGH(RAM_FLASH)
LDI		YL,LOW(RAM_RAM)
LDI		YH,HIGH(RAM_RAM)

; BORRAR PAGINA
 ldi	SPMCRVAL,(1<<SPMEN) | (1<<PGERS)
STS	SPMCR,SPMCRVAL
 CALL DO_SPM
 NOP	; 4 Cycle do nothing
 NOP
 NOP
 NOP
	 ;  Vuelva a habilitar la sección RWW
   Ldi spmcrval, (1 << RWWSRE) |  (1 << SPMEN)
   CALL DO_SPM



 ; Write 0xABCD at address : 0x01 into the Buffer
 LDI	ZH,0
 LDI	ZL,2
 LDI	R16,0xAB
 MOV	R0,R16
 LDI	R16,0xCD
 MOV	R1,R16
 LDI	r16,(1<<SPMEN) | (1<<PGWRT)
STS	SPMCR,R16
 CALL DO_SPM
 NOP
 NOP
 NOP
 NOP
 ; Write Buffer To Page 1 (Address : 0x0080 - 0x00FF)
 LDI	ZL,LOW(1<<7)
 LDI	ZH,HIGH(1<<7)
 LDI	r16,(1<<SPMEN) | (1<<PGWRT)
STS	SPMCR,R16
 CALL DO_SPM
 LOOP:
; RJMP	LOOP
RET




PRU1:









ES_PAG:




ldi SPMCRVAL,(1<<PGERS)+(1<<SPMEN)
call do_spm
	 ;  Vuelva a habilitar la sección RWW
   Ldi spmcrval, (1 << RWWSRE) |  (1 << SPMEN)
   CALL DO_SPM


 ;TRANSFERIR DATOS DE RAM A FLASH
ldi LOOPLO, low(PAGESIZEB) ;INICIA LA VARIABLE DATOS A LEER DE LA RAM
ldi LOOPHI, high(PAGESIZEB) ;NO NECESARIO PARA PAGESIZEB<=256 SOLO UNA PAGINA
LDI 	ZL,LOW(RAM_FLASH)
LDI		ZH,HIGH(RAM_FLASH)
LDI		YL,LOW(RAM_RAM)
LDI		YH,HIGH(RAM_RAM)

wrloop:
ld r0,Y+
ld r1,Y+
ldi SPMCRVAL, (1<<SPMEN) + (1<<PGWRT)
call do_spm
adiw ZH:ZL, 2
sbiw LOOPHI:LOOPLO, 2;USE SUBI PARA PAGESIZEB<=256 ****
brne wrloop



 ;ESCRIBE LA PAGINA
subi ZL, low(PAGESIZEB) ;restore pointer
sbci ZH, high(PAGESIZEB) ;not required for PAGESIZEB<=256
ldi SPMCRVAL, (1<<PGWRT) + (1<<SPMEN)
call do_spm

;read back and check, optional
ldi LOOPLO, low(PAGESIZEB) ;init loop variable
ldi LOOPHI, high(PAGESIZEB) ;not required for PAGESIZEB<=256
subi YL, low(PAGESIZEB) ;restore pointer
sbci YH, high(PAGESIZEB)
rdloop:
lpm r0, Z+  
ld r1, Y+
cpse r0, r1
jmp error
sbiw LOOPHI:LOOPLO, 2;use subi for PAGESIZEB<=256*********************
brne rdloop
ret


 do_spm:
 ;input: 21 determines SPM action
 ;disable interrupts if enabled, store status
in TEMP2, SREG
cli
;check for previous SPM complete
wait:
lds TEMP1, SPMCR 
sbrc TEMP1, SPMEN
rjmp wait
;SPM timed sequence
sts SPMCR,SPMCRVAL
spm
nop
nop
nop
 ;restaura SREG
OUT SREG,TEMP2
ret

