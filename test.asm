		INCLUDE	"api.i"
		INCLUDE	"keys.i"

IO_CTRL		EQU	1

		; This is very naughty. Place ZP vars below kernel args, but way above DOS variables. Hopefully!
		RSSET	$E0
Events		RB	event_SIZEOF
Line		RB	2
String		RB	2

	IF __RS>$F0
		FAIL	"Too many ZP variables"
	ENDC


		SECTION	"Code",CODE[$2000]

Header:
		DB	$F2,$56		; magic
		DB	Length/$2000	; # blocks
		DB	Header/$2000	; start block #
		DW	Entry		; entry address
		DS	4		; fill

Entry:
		; Switch to text IO
		lda	#2
		sta	IO_CTRL

		jsr	ClearScreen

		stz	Line
		lda	#$C0
		sta	Line+1

		lda	#>.text1
		ldx	#<.text1
		jsr	PrintLine
		lda	#>.text2
		ldx	#<.text2
		jsr	PrintLine
		lda	#>.text3
		ldx	#<.text3
		jsr	PrintLine

		ldy	#0
.next_arg
		lda	(kargs_ext),y
		tax
		iny
		lda	(kargs_ext),y
		iny
		jsr	PrintLine
		cpy	kargs_extlen
		bne	.next_arg
		
		lda	#<Events
		sta	kargs_events
		lda	#>Events
		sta	kargs_events+1

.next_event
		jsr	kernel_NextEvent
		bcs	.next_event

		lda	Events+event_type
		cmp	#EVENT_KEY_PRESSED
		bne	.next_event

		lda	Events+event_key_raw
		cmp	#ESC
		beq	.reset

		clc
		rts

.reset
		sec
		rts


.text1		DB	"This is a kernel user program.",0
.text2		DB	"Press a key to exit, or ESC to reset (if hardware supports it.)",0
.text3		DB	"Arguments were:",0

PrintLine:
	; AX = string
		phy

		stx	String
		sta	String+1

		ldy	#0
.next		lda	(String),y
		beq	.done
		sta	(Line),y
		iny
		bra	.next
.done
		jsr	Newline
		ply
		rts

Newline:
		pha

		clc
		lda	Line
		adc	#80
		sta	Line
		lda	Line+1
		adc	#0
		sta	Line+1

		pla
		rts

ClearScreen:
		ldx	#0
		lda	#' '
.next
		sta	$C000+$000,x
		sta	$C000+$100,x
		sta	$C000+$200,x
		sta	$C000+$300,x
		sta	$C000+$400,x
		sta	$C000+$500,x
		sta	$C000+$600,x
		sta	$C000+$700,x
		sta	$C000+$800,x
		sta	$C000+$900,x
		sta	$C000+$A00,x
		sta	$C000+$B00,x
		sta	$C000+$C00,x
		sta	$C000+$D00,x
		sta	$C000+$E00,x
		sta	$C000+$F00,x
		sta	$C000+$1000,x
		sta	$C000+$1100,x
		sta	$C000+$1200,x
		inx
		bne	.next
.done
		rts


		CNOP	0,$2000

Length		EQU	@-Header
