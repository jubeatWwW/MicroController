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
#define PIN03	(1<<09)	; x3 - output
#define PIN02	(1<<08) ; x2 - output
#define PIN01	(1<<10) ; x1 - output
#define PIN00	(1<<11) ; x0 - output


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


INPUT_MAP	DCD  (1<<21), (1<<20), (1<<15), (1<<14)
OUTPUT_MAP	DCD	 (1<<11), (1<<10), (1<<08), (1<<09)
	
__main FUNCTION
	
	LDR		R0, =PORTA_base
	BL		set_output
	BL		set_input
	MOVS	R1, #0
	PUSH	{R1}
	PUSH	{R1}
	PUSH	{R1}
	PUSH	{R1}

main_loop
	


	;	R2 IS THE INPUT VALUE

	MOVS	R7, #16
	MOVS	R4, #0
column

	PUSH	{R1-R5}
	MOVS	R3, #0
	LDR		R1, =OUTPUT_MAP
loop_0
	
	LDR		R2, [R1]
	
	CMP		R3, R4
	BNE		loop_0_mid
	MOVS	R5, #DIRSET_reg
	STR		R2, [R0, R5]
	B		loop_0_end	
loop_0_mid
	MOVS	R5, #DIRCLR_reg
	STR		R2, [R0, R5]

	
loop_0_end	
	ADDS	R1, #4
	ADDS	R3, #1
	CMP		R3, #4
	BNE		loop_0
	
	
	POP		{R1-R5}
	
	
	MOVS	R1, #INPUT_reg
	LDR		R2, [R0, R1]	
	MVNS	R2, R2
	MOVS	R3, #4
	; R4 IS X, R3 IS Y
	LDR		R5, =INPUT_MAP
loop_1
	
	SUBS	R3, #1
	LDR		R6, [R5, #0]
	
	
	ANDS	R6, R6, R2
	BEQ		not_click
	
	PUSH	{R1-R3}
	
	MOVS	R1, #1
	MOVS	R2, #3
	SUBS	R2, R3
	MOVS	R3, R2
	LSLS	R3, #2
	ADDS	R3, R4
	MOVS	R7, R3
	POP		{R1-R3}
	
	
not_click

	ADDS	R5, #4
	CMP		R3, #0
	BNE		loop_1
	
	ADDS	R4, #1
	CMP		R4, #4
	BNE		column

	
	POP		{R4} ; LAST DISPLAY VALUE
	POP		{R3} ; OPERATOR
	POP		{R2} ; VALUE
	POP		{R1} ; STATE

	CMP		R7, #15
	BNE		state_0
	MOVS	R1, #0
	MOVS	R2, #0
	MOVS	R3, #0
	MOVS	R4, #0
	B		disp

state_0

	CMP		R1, #0
	BNE		state_1
	
	CMP		R7, #9
	BGT		disp
	
	ADDS	R2, R7
	ADDS	R1, #1
	
	MOVS	R4, R7
	
	B		disp	
	
state_1

	CMP		R1, #1
	BNE		state_2

	CMP		R7, #10 
	BNE		st10 ; +
	MOVS	R3, #1
	B		stend
st10
	CMP		R7, #11
	BNE		st11 ; -
	MOVS	R3, #2
	B		stend
st11
	CMP		R7, #12
	BNE		st12 ; *
	MOVS	R3, #3
	B		stend
st12
	CMP		R7, #13
	BNE		disp ; /
	MOVS	R3, #4
	B		stend

stend

	ADDS	R1, #1

	B		disp
state_2
	
	CMP		R1, #2
	BNE		state_3
	
	CMP		R7, #9
	BGT		disp

	CMP		R3, #1 
	BNE		st20 ; +
	ADDS	R2, R7
	B		stend2
st20
	CMP		R3, #2
	BNE		st21 ; -
	SUBS	R2, R7
	B		stend2
st21
	CMP		R3, #3
	BNE		st22 ; *
	MULS	R2, R7 ,R2
	B		stend2
st22
	CMP		R3, #4
	BNE		disp 
	
	BL		divide
	B		stend2

stend2
	
	ADDS	R1, #1
	MOVS	R4, R7
	
	B		disp
state_3
	CMP		R1, #3
	BNE		state_4
	CMP		R7, #14
	BNE		disp
	MOVS	R4, R2
	ADDS	R1, #1
	
state_4
	
disp
	
	PUSH	{R1}
	PUSH	{R2}
	PUSH	{R3}
	PUSH	{R4}
	
	
	MOVS	R5, R4
	BL		display
	
	B		main_loop

	
	ENDFUNC
	
divide	FUNCTION
	; 	R2 / R7
	
	CMP		R2, R7
	BGE		d_do
	MOVS	R2, #0
	B		d_end
	
d_do	
	PUSH	{R1,R7}
	
	MOVS	R1, #0

d_loop
	SUBS	R2, R7
	ADDS	R1, #1
	CMP		R2, R7
	BGE		d_loop
	MOVS	R2, R1
	POP		{R1,R7}
	
d_end	
	
	BX		LR
	
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
	LDR		R2, =PIN03
	STR		R2, [R0, R1]
	LDR		R2, =PIN02
	STR		R2, [R0, R1]
	LDR		R2, =PIN01
	STR		R2, [R0, R1]	
	LDR		R2, =PIN00
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
	

	BX		LR
	
	ENDFUNC


	END
