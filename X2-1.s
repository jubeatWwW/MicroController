	PRESERVE8
	THUMB
	
	AREA	|.data|, DATA, READWRITE
	ALIGN	4
	
user_stack	SPACE 128
expr_result	DCD		0

		
	AREA	|.text|, CODE, READONLY
	EXPORT	__main
		
postfix_expr	DCB	"-100  +10 +20 + - 10 +", 0
/*
-100 10 20 + - 10 +
*/

__main	FUNCTION
	LDR		r0, =postfix_expr
	ldr		r1, =user_stack
	mrs		r1, MSP
	movs	r1, #0
	movs	r3, #0
	movs	r7, #0
	movs	r4, #0
	movs	r6, #0
	movs	r5, #0
loop
	cmp 	r5, #1
	beq		EndExpr
	ldrb	r2, [r0, r1]
	adds 	r1, r1, #1
	
	cmp		r2, #0x30
	blt		notNum
	cmp 	r2, #0x39
	bgt		notNum
	b		isNum
isNum
	movs 	r4, #0x30
	subs 	r2, r2, r4
	movs 	r4, #10
	muls	r3, r4, r3
	adds	r3, r3, r2
	b		loop
notNum
	cmp		r2, #0x2B
	beq		addOp
	cmp 	r2, #0x2D
	beq		subOp
	cmp		r2, #0x20
	beq		spaceOp
	cmp		r2, #0x00
	beq		LastOp
	b		error
LastOp
	movs	r5, #1
	b		spaceOp
error
	movs	r3, #0
	subs	r3, r3, #1
	b		iferror
	
addOp
	cmp		r3, #0
	bne		error
	movs 	r6, #1
	b		loop
subOp
	cmp		r3, #0
	bne		error
	movs	r6, #2
	b loop
spaceOp
	cmp		r6, #0
	beq		strNum
	cmp 	r6, #1
	beq		addJudge
	cmp		r6, #2
	beq		subJudge
strNum
	cmp		r3, #0
	beq		loop
	push{	r3}
	movs	r3, #0
	movs	r6, #0
	b		loop
addJudge
	cmp 	r3, #0
	bne		isPos
	b		addCal
isPos
	push{	r3}
	movs	r3, #0
	movs	r6, #0
	b		loop
addCal
	pop{	r3}
	movs	r4, r3
	pop{	r3}
	adds	r3, r3, r4
	push{	r3}
	movs	r3, #0
	movs	r6, #0
	b		loop
subJudge
	cmp 	r3, #0
	bne		isNeg
	b		subCal
isNeg
	negs	r3, r3
	push{	r3}
	movs	r3, #0
	movs	r6, #0
	b		loop
subCal
	pop{	r3}
	movs	r4, r3
	pop{	r3}
	subs	r3, r3, r4
	push{	r3}
	movs	r3, #0
	movs	r6, #0
	b		loop
	
EndExpr
	pop{	r3}
iferror
	ldr		r0, =expr_result
	str		r3, [r0]
	
	ldr		r1, =expr_result
	ldr		r2, [r1]
program_end
	B	program_end
	ENDFUNC
	END
		
		