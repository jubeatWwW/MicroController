PRESERVE8
	THUMB
	
	AREA   |.data|, DATA, READONLY	


	AREA   |.text|, CODE, READONLY 	
	EXPORT __main

#define PORTA_base 0x41004400
#define PIN13 	(1<<17) ; c3
#define PIN12 	(1<<19) ; c2
#define PIN11	(1<<16) ; c1
#define PIN10 	(1<<18) ; c0
#define PIN09 	(1<<07) ; s2
#define PIN08 	(1<<06) ; s1
#define PIN07	(1<<21)	; y3 - input
#define PIN06	(1<<20) ; y2 - input
#define PIN05   (1<<15) ; y1 - input
#define PIN04	(1<<14) ; y0 - input
#define PIN03	(1<<09)	; x3 - input
#define PIN02	(1<<08) ; x2 - input
#define PIN01	(1<<10) ; x1 - input
#define PIN00	(1<<11) ; x0 - input

#define PINCFG_reg0	(0x40 + 11)
#define PINCFG_reg1	(0x40 + 10)
#define PINCFG_reg2	(0x40 + 8)
#define PINCFG_reg3	(0x40 + 9)
#define PINCFG_reg4	(0x40 + 14)
#define PINCFG_reg5	(0x40 + 15)
#define PINCFG_reg6	(0x40 + 20)
#define PINCFG_reg7	(0x40 + 21)

#define INPUT_reg	(0x20)
#define PINCFG_reg	(0x40)
#define OUTCLR_reg	(0x14)
#define OUTSET_reg	(0x18)
#define DIRSET_reg	(0x08)
#define DIRCLR_reg	(0x04)


#define INPUT_reg	(0x20)
#define PINCFG_reg	(0x40)
#define OUTCLR_reg	(0x14)
#define OUTSET_reg	(0x18)
#define DIRSET_reg	(0x08)
#define DIRCLR_reg	(0x04)


INPUT_MAP	DCD  (1<<21)+(1<<11), (1<<21)+(1<<10) , (1<<21)+(1<<08), (1<<21)+(1<<09) ,  (1<<20)+(1<<11), (1<<20)+(1<<10) , (1<<20)+(1<<08), (1<<20)+(1<<09) , (1<<15)+(1<<11), (1<<15)+(1<<10) , (1<<15)+(1<<08), (1<<15)+(1<<09) , (1<<14)+(1<<11), (1<<14)+(1<<10) , (1<<14)+(1<<08), (1<<14)+(1<<09)

__main FUNCTION
	
	LDR		R0, =PORTA_base
	BL		set_output
	BL		set_input
	

main_loop
	
	MOVS	R1, #INPUT_reg
	LDR		R2, [R0, R1]
	;	R2 IS THE INPUT VALUE

	MOVS	R7, #0

	LDR		R4, =INPUT_MAP
	MOVS	R3, #0
	; R4 IS MAP, R3 IS COUNTER
loop_1
	LDR		R5, [R4]	
	; 	R5 STORE THE VALUE OF INPUT_MAP
	
	MOVS	R6, R5
	PUSH	{R2}
	MVNS	R2, R2
	ANDS	R5, R5, R2
	POP		{R2}
	
	
	CMP		R6, R5
	BNE		not_clicked
	
	MOVS	R1, #1
	LSLS	R1, R3 
	
	ADDS	R7, R3
	;ORRS	R7, R7, R1
	
not_clicked
	
	ADDS	R4, #4
	ADDS	R3, #1
	CMP		R3, #16
	BNE		loop_1
	
	MOVS	R5, R7
	BL		display
	
	B		main_loop

	
	ENDFUNC
	
display FUNCTION
	PUSH	{R0-R7,LR}
; Get 2 digits
; R4: 10, R5: 1
	MOVS	R4, #0
loop1
	CMP		R5, #10
	BLT		done
	ADDS	R4, R4, #1
	SUBS	R5, R5, #10
	B		loop1
done

	LDR		R1, =PIN08
	MOVS	R2, #OUTCLR_reg
	STR		R1, [R0, R2]
	LDR		R1, =PIN09
	MOVS	R2, #OUTSET_reg
	STR		R1, [R0, R2]
	MOVS	R3, R4
	BL		display_num
	BL		delay
	LDR		R1, =PIN09
	MOVS	R2, #OUTCLR_reg
	STR		R1, [R0, R2]
	LDR		R1, =PIN08
	MOVS	R2, #OUTSET_reg
	STR		R1, [R0, R2]
	MOVS	R3, R5
	BL		display_num
	BL		delay
	POP		{R0-R7,PC}
	ENDFUNC
	
; R3: digit, R6: tmp
display_num FUNCTION
	LSRS	R6, R3, #3
	MOVS	R2, #OUTCLR_reg
	MOVS	R1, #1
	ANDS	R6, R6, R1
	BEQ		no_clr3
	MOVS	R2, #OUTSET_reg
no_clr3
	LDR		R1, =PIN13
	STR		R1, [R0, R2]

	LSRS	R6, R3, #2
	MOVS	R2, #OUTCLR_reg
	MOVS	R1, #1
	ANDS	R6, R6, R1
	BEQ		no_clr2
	MOVS	R2, #OUTSET_reg
no_clr2
	LDR		R1, =PIN12
	STR		R1, [R0, R2]

	LSRS	R6, R3, #1
	MOVS	R2, #OUTCLR_reg
	MOVS	R1, #1
	ANDS	R6, R6, R1
	BEQ		no_clr1
	MOVS	R2, #OUTSET_reg
no_clr1
	LDR		R1, =PIN11
	STR		R1, [R0, R2]

	MOVS	R6, R3
	MOVS	R2, #OUTCLR_reg
	MOVS	R1, #1
	ANDS	R6, R6, R1
	BEQ		no_clr0
	MOVS	R2, #OUTSET_reg
no_clr0
	LDR		R1, =PIN10
	STR		R1, [R0, R2]
	BX		LR
	ENDFUNC

delay	FUNCTION
	LDR		R3, =2000
FL1
	SUBS	R3, #1
	BNE		FL1
	BX		LR
	ENDFUNC
	
set_output FUNCTION
	
	MOVS	R1, #DIRSET_reg
	LDR		R2, =PIN13
	STR		R2, [R0, R1]
	LDR		R2, =PIN12
	STR		R2, [R0, R1]
	LDR		R2, =PIN11
	STR		R2, [R0, R1]
	LDR		R2, =PIN10
	STR		R2, [R0, R1]
	LDR		R2, =PIN09
	STR		R2, [R0, R1]	
	LDR		R2, =PIN08
	STR		R2, [R0, R1]	
	BX		LR
	ENDFUNC

set_input	FUNCTION
	
; INIT INPUT START
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg7
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN07
	STR		R2, [R0, R1]
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg6
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN06
	STR		R2, [R0, R1]

	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg5
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN05
	STR		R2, [R0, R1]
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg4
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN04
	STR		R2, [R0, R1]
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg3
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN03
	STR		R2, [R0, R1]
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg2
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN02
	STR		R2, [R0, R1]	
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg1
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN01
	STR		R2, [R0, R1]
	
	MOVS	R1, #0X02
	MOVS	R2, #PINCFG_reg0
	STRB	R1, [R0, R2]
	MOVS	R1, #DIRCLR_reg
	LDR		R2, =PIN00
	STR		R2, [R0, R1]		
	
	BX		LR
	
	ENDFUNC


	ENDs