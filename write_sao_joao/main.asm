.nolist
.include "../m328Pdef.inc"
.list

.equ display = PORTB
.def aux = r16
.def count = r17
.equ ceil = 13
.equ LET_S = 0b1101101 
.equ LET_A = 0b1110111 
.equ LET_O = 0b111111 
.equ LET_J = 0b11110 
.equ LET__ = 0
.equ MINUS = 0b1000000 
.equ TWO = 0b1011011 
.equ ZERO = LET_O
.equ FIVE = 0b11101101  

.org 0x0000
  rjmp    main

show_text:
  show_text__check: ; S
    cpi   count, 0
    brne  show_text__check1
    ldi   aux, LET_S
    out   display, aux 
    rjmp  show_text__end
  show_text__check1: ; A
    cpi   count, 1
    brne  show_text__check2
    ldi   aux, LET_A
    out   display, aux 
    rjmp  show_text__end
  show_text__check2: ; O
    cpi   count, 2
    brne  show_text__check3
    ldi   aux, LET_O
    out   display, aux 
    rjmp  show_text__end
  show_text__check3: ; " "
    cpi   count, 3
    brne  show_text__check4
    ldi   aux, LET__
    out   display, aux 
    rjmp  show_text__end
  show_text__check4: ; J
    cpi   count, 4
    brne  show_text__check5
    ldi   aux, LET_J
    out   display, aux 
    rjmp  show_text__end
  show_text__check5: ; O
    cpi   count, 5
    brne  show_text__check6
    ldi   aux, LET_O
    out   display, aux 
    rjmp  show_text__end
  show_text__check6: ; A
    cpi   count, 6
    brne  show_text__check7
    ldi   aux, LET_A
    out   display, aux 
    rjmp  show_text__end
  show_text__check7: ; O
    cpi   count, 7
    brne  show_text__check8
    ldi   aux, LET_O
    out   display, aux 
    rjmp  show_text__end
  show_text__check8: ; -
    cpi   count, 8
    brne  show_text__check9
    ldi   aux, MINUS
    out   display, aux 
    rjmp  show_text__end
  show_text__check9: ; 2
    cpi   count, 9
    brne  show_text__check10
    ldi   aux, TWO
    out   display, aux 
    rjmp  show_text__end
  show_text__check10: ; 0
    cpi   count, 10
    brne  show_text__check11
    ldi   aux, ZERO
    out   display, aux 
    rjmp  show_text__end
  show_text__check11: ; 2
    cpi   count, 11
    brne  show_text__check12
    ldi   aux, TWO
    out   display, aux 
    rjmp  show_text__end
  show_text__check12: ; 5
    cpi   count, 12
    brne  show_text__end
    ldi   aux, FIVE
    out   display, aux 
    rjmp  show_text__end
  show_text__end:
    ret

delay:
  ldi   r20, 100
  delay0:
    ldi   r21, 100
    delay1:
      ldi   r22, 255
      delay2:
        dec   r22
        brne  delay2
      dec   r21
      brne  delay1
    dec   r20
    brne  delay0
  ret

main:
  ldi   count, 0xff
  clr   aux
  out   DDRB, count
  out   PORTB, aux
loop:
  inc   count
  cpi   count, ceil
  brlt  loop__else
  loop_if:
    clr   count
    rcall delay
  loop__else:
  rcall show_text
  rcall delay
  rjmp  loop

