; This file is part of the TinyCore 6502 MicroKernel,
; Copyright 2022 Jessie Oberreuter <joberreu@moselle.com>.
; As with the Linux Kernel Exception to the GPL3, programs
; built to run on the MicroKernel are expected to include
; this file.  Doing so does not affect their license status.

	RSRESET
LSHIFT	RB	1
RSHIFT	RB	1
LCTRL	RB	1
RCTRL	RB	1
LALT	RB	1
RALT	RB	1
LMETA	RB	1
RMETA	RB	1
CAPS	RB	1

	RSSET	$80
POWER	RB	1
F1	RB	1
F2	RB	1
F3	RB	1
F4	RB	1
F5	RB	1
F6	RB	1
F7	RB	1
F8	RB	1
F9	RB	1
F10	RB	1
F11	RB	1
F12	RB	1
F13	RB	1
F14	RB	1
F15	RB	1
F16	RB	1
DEL	RB	1
BKSP	RB	1
TAB	RB	1
ENTER	RB	1
ESC	RB	1

	RSSET	$A0
K0	RB	1
K1	RB	1
K2	RB	1
K3	RB	1
K4	RB	1
K5	RB	1
K6	RB	1
K7	RB	1
K8	RB	1
K9	RB	1
KPLUS	RB	1
KMINUS	RB	1
KTIMES	RB	1
KDIV	RB	1
KPOINT	RB	1
KENTER	RB	1
NUM	RB	1

PUP	RB	1
PDN	RB	1
HOME	RB	1
END	RB	1
INS	RB	1
UP	RB	1
DOWN	RB	1
LEFT	RB	1
RIGHT	RB	1
SCROLL	RB	1
SYSREQ	RB	1
BREAK	RB	1

SLEEP	RB	1
WAKE	RB	1
PRTSCR	RB	1
MENU	RB	1
PAUSE	RB	1
