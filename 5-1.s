	PRESERVE8
	THUMB
	
	AREA   |.data|, DATA, READONLY	


	AREA   |.text|, CODE, READONLY 	
	EXPORT __main

#define PORTA_base 0x41004400
#define PIN13 	(1<<17)
#define PIN12 	(1<<19)
#define PIN11	(1<<16)
#define PIN10 	(1<<18)
#define PIN9 	(1<<07)
#define PIN8 	(1<<06)
#define PIN7	(1<<21)		;;count
#define PIN6	(1<<20)		;;clear




#define PINCFG_reg6	(0x40 + 20)
#define PINCFG_reg7	(0x40 + 21)

#define INPUT_reg	(0x20)
#define PINCFG_reg	(0x40)
#define OUTCLR_reg	(0x14)
#define OUTSET_reg	(0x18)
#define DIRSET_reg	(0x08)
#define DIRCLR_reg	(0x04)

__main	FUNCTION
	BL		PinInit
	
	movs	r7, #0	
	BL		Led1Display	
	movs	r7, #1
	movs	r6, #0
loop 

	movs 	r2,#INPUT_reg
	ldr 	r1, [r0, r2]
	ldr	 	r3, =PIN7
	ands	r1, r1, r3
	cmp 	r1, #0
	beq		AddPushed
	
	movs 	r2,#INPUT_reg
	ldr 	r1, [r0, r2]
	ldr	 	r3, =PIN6
	ands	r1, r1, r3
	cmp 	r1, #0
	beq		Reset
	b		PushEventComplete

Reset
	bl		longdelay
	movs	r7, #0
	movs	r6, #0
	b		loop

AddPushed

	bl		longdelay
	movs 	r2, #INPUT_reg
	ldr	 	r1, [r0, r2]
	ldr	 	r3, =PIN7
	ands	r1, r1, r3
	cmp 	r1, #0
	beq		AddPushed
	
	bl		longdelay
	movs 	r2, #INPUT_reg
	ldr	 	r1, [r0, r2]
	ldr	 	r3, =PIN7
	ands	r1, r1, r3
	cmp 	r1, #0
	beq		AddPushed
	
	bl		fib
	
PushEventComplete
	bl 		Led1Display
	bl		delay
	bl		Led2Display
	bl		delay
	
	b 		loop
	b		.
	ENDFUNC

fib	FUNCTION
	push{	lr}
	movs	r5, r7
	adds	r7, r7, r6
	movs	r6, r5
	pop{	pc}
	ENDFUNC

Led1Display	FUNCTION
	push{	r7, lr}
	
	cmp		r7, #10
	blt		getNum1Exit
getNum1
	subs	r7, r7, #10
	cmp		r7, #10
	bge		getNum1
getNum1Exit

	ldr		r1, =PIN8
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	
	ldr		r1, =PIN9
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
	movs	r4, #1
	ands	r4, r7, r4
	cmp 	r4, #0
	beq		LED1_OFF
	
	ldr		r1, =PIN10
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED2
LED1_OFF
	ldr		r1, =PIN10
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LED2
	lsrs	r7, #1
	movs	r4, #1
	ands	r4, r7, r4
	cmp 	r4, #0
	beq		LED2_OFF
	
	ldr		r1, =PIN11
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED3
LED2_OFF
	ldr		r1, =PIN11
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LED3
	lsrs	r7, #1
	movs	r4, #1
	ands	r4, r7, r4
	cmp 	r4, #0
	beq		LED3_OFF
	
	ldr		r1, =PIN12
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED4
LED3_OFF
	ldr		r1, =PIN12
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]

LED4
	lsrs	r7, #1
	movs	r4, #1
	ands	r4, r7, r4
	cmp 	r4, #0
	beq		LED4_OFF
	
	ldr		r1, =PIN13
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LEDEXIT
LED4_OFF
	ldr		r1, =PIN13
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LEDEXIT	
	
	bl		delay
	
	pop{	r7, pc}
	ENDFUNC
	
Led2Display	FUNCTION
	push{	r6-r7, lr}
	movs	r6, #0
	
	cmp		r7, #10
	blt		noLED
	b		hasLED
noLED
	ldr		r1, =PIN8
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		decjudge
hasLED
	ldr		r1, =PIN8
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
decjudge
	
	cmp		r7, #10
	blt		getNum2Exit
getNum2
	subs	r7, r7, #10
	adds	r6, r6, #1
	cmp 	r7, #10
	bge		getNum2
getNum2Exit


	
	ldr		r1, =PIN9
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	
	movs	r4, #1
	ands	r4, r6, r4
	cmp 	r4, #0
	beq		LED1_OFFB
	
	ldr		r1, =PIN10
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED2B
LED1_OFFB
	ldr		r1, =PIN10
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LED2B
	lsrs	r6, #1
	movs	r4, #1
	ands	r4, r6, r4
	cmp 	r4, #0
	beq		LED2_OFFB
	
	ldr		r1, =PIN11
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED3B
LED2_OFFB
	ldr		r1, =PIN11
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LED3B
	lsrs	r6, #1
	movs	r4, #1
	ands	r4, r6, r4
	cmp 	r4, #0
	beq		LED3_OFFB
	
	ldr		r1, =PIN12
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LED4B
LED3_OFFB
	ldr		r1, =PIN12
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]

LED4B
	lsrs	r6, #1
	movs	r4, #1
	ands	r4, r6, r4
	cmp 	r4, #0
	beq		LED4_OFFB
	
	ldr		r1, =PIN13
	movs	r2, #OUTSET_reg
	str		r1, [r0, r2]
	b		LEDEXITB
LED4_OFFB
	ldr		r1, =PIN13
	movs	r2, #OUTCLR_reg
	str		r1, [r0, r2]
	
LEDEXITB
	
	bl		delay
	
	pop{	r6-r7, pc}
	ENDFUNC

	

PinInit FUNCTION
	push{	lr}
	LDR		R0, =PORTA_base
	;Initial pin
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN13
	STR		R4,	[R0, R2] ;Set PA17 DIR HIGH
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN12	
	STR		R4,	[R0, R2] ;Set PA19 DIR HIGH
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN11	
	STR		R4,	[R0, R2] ;Set PA16 DIR HIGH
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN10	
	STR		R4,	[R0, R2] ;Set PA18 DIR HIGH
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN9	
	STR		R4,	[R0, R2] ;Set PA18 DIR HIGH
	
	MOVS	R2, #DIRSET_reg
	LDR		R4, =PIN8	
	STR		R4,	[R0, R2] ;Set PA18 DIR HIGH
	
	;initial input pin
	;;;;;;;;;;;INPUT PIN7;;;;;;;;;;;;;;;;
	MOVS	R2,#0x02		;;INEN=1
	MOVS	R4,#PINCFG_reg7
	STRB	R2,[R0,R4]
	MOVS	R4, #DIRCLR_reg
	LDR		R2, =PIN7
	STR		R2,	[R0, R4] ;Set PA21 DIR LOW
	;;;;;;;;;;INPUT PIN6;;;;;;;;;;;;;;;;;
	MOVS	R2,#0x02
	MOVS	R4,#PINCFG_reg6
	STRB	R2,[R0,R4]
	MOVS	R4, #DIRCLR_reg
	LDR		R2, =PIN6
	STR		R2,	[R0, R4] ;Set PA21 DIR LOW

	pop{	pc}
	
	ENDFUNC

delay FUNCTION
	push{	r1, lr}
	LDR		R1,	=2000  
delay1
	SUBS	R1,	#1
	BNE		delay1         
	pop{	r1, pc}
	ENDFUNC
	
longdelay FUNCTION
	push{	r1, lr}
	LDR		R1,	=30000
delay2
	SUBS	R1,	#1      
	BNE		delay2         
	pop{	r1, pc}
	ENDFUNC

	END