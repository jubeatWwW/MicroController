	PRESERVE8
	THUMB
	
	AREA	|.data|, DATA, READWRITE
	ALIGN	4
	
result		DCD		0
max_size	DCD		0

		
	AREA	|.text|, CODE, READONLY
	EXPORT	__main
	
m			DCD		0x0C
n			DCD		0x09
		
__main	FUNCTION
	
	ldr		r2, =m
	ldr		r3, =n
	ldr		r0, [r2]
	ldr		r1, [r3]
	push{	r0,r1}
	BL		GCD
	nop
calend
	b	calend
	ENDFUNC
	
GCD	FUNCTION
	push{	lr}
	
	ldr		r2, [sp, #4]
	ldr		r3, [sp, #8]
	
	cmp		r2, #0
	beq		reta
	b		nozeroa
reta
	movs	r4, r3
	pop{	r0,r1,pc}
	
nozeroa

	cmp		r3, #0
	beq		retb
	b		nozerob
retb
	movs	r4, r2
	pop{	r0,r1,pc}
	
nozerob
	
	movs	r5, #0x01
	movs	r6, r2
	orrs	r6, r3, r6
	ands	r6, r5, r6
	cmp		r6, #0			
	beq		case1
	b		case2s
case1
	lsrs	r0, r2, #1
	lsrs	r1, r3, #1
	push{	r0, r1}
	bl		GCD
	movs	r5, #0x02
	muls	r4, r5, r4
	b		caseEXIT
case2s
	movs	r6, r2
	ands	r6, r5, r6
	cmp		r6, #0
	beq		case2
	b		case3s
case2
	lsrs	r0, r2, #1
	movs	r1, r3
	push{	r0, r1}
	bl		GCD
	b		caseEXIT
case3s
	movs	r6, r3
	ands	r6, r5, r6
	cmp		r6, #0
	beq		case3
	b		case4s
case3
	lsrs	r1, r3, #1
	movs	r0, r2
	push{	r0, r1}
	bl		GCD
	b		caseEXIT
case4s
	cmp		r2, r3
	bgt		bigger
	b		smaller
bigger
	subs	r0, r2, r3
	movs	r1, r3
	b		nexpar
smaller
	subs	r0, r3, r2
	movs	r1, r2
nexpar
	push{	r0,r1}
	bl		GCD
caseEXIT

	pop{	r0,r1,pc}
	ENDFUNC
	END