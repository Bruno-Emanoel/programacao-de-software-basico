.nolist
.include "../m328Pdef.inc"
.list

.def count1 = r16
.def count2 = r17
.def count3 = r18
.def aux = r19
.def param = r20

.org 0x0000
  rjmp  main

delay:
  ldi   r21, 11
delay__0:
  ldi   r22, 22
delay__1:
  ldi   r23, 33
delay__2:
;writing
  mov   param, count1
  cbi   PORTB, 0
  rcall write
  mov   param, count2
  sbi   PORTB, 0
  cbi   PORTB, 1
  rcall write
  mov   param, count3
  sbi   PORTB, 1
  cbi   PORTB, 2
  rcall write
  sbi   PORTB, 2

  dec   r23
  brne  delay__2
  dec   r22
  brne  delay__1
  dec   r21
  brne  delay__0
  ret

delay_low:
  ldi   r24, 0x10
delay_low__0:
  dec   r24
  brne  delay_low__0
  ret

write:
  ldi   ZH, high(table<<1)
  ldi   ZL, low(table<<1)
  add   ZL, param
  brcc  write__not_carry
  inc   ZH
write__not_carry:
  lpm   aux, Z
  out   PORTC, aux
  rcall  delay_low
  ldi   aux, 0
  out   PORTC, aux
  ret

main:
  clr   count2
  clr   count3
  ldi   count1, 0xff
  out   DDRC, count1
  ldi   aux, 0b111
  out   DDRB, aux
  out   PORTB, aux
  ldi   aux, 0xff
  out   PORTC, aux

loop:
  inc   count1
  cpi   count1, 10
  brne  loop__if
  clr   count1
  inc   count2

  cpi   count2, 10
  brne  loop__if
  clr   count2
  inc   count3

  cpi   count3, 10
  brne  loop__if
  clr   count3
loop__if:
  rcall  delay
  rjmp  loop



table:
  .db 0b111111, 0b110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b111, 0b1111111, 0b1101111