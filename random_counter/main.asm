.nolist
.include "../m328Pdef.inc"
.list

.equ button = PB0
.equ display = PORTD

.def quocient = r23
.def division = r22
.def auxj = r21
.def auxi = r20
.def aux = r19
.def value = r18
.def count = r17
.def temp = r16

.org 0x0000
	rjmp  main

wait_and_write:
  ldi   auxi, 0xFF
wait_and_write__delay1:
  ldi   auxj, 0xF
wait_and_write__delay2:
  rcall write
  rcall inc_count
  dec   auxj
  brne  wait_and_write__delay2
  dec   auxi
  brne  wait_and_write__delay1
  ret

inc_count:
  inc   count
	ldi		aux, 60;
	cpse	count, aux;
  ret
	ldi 	count, 0;
  ret

delay_low:
  ldi   aux, 0xF
delay_low__loop:
  dec   aux
  brne  delay_low__loop
  ret

write:
  mov   quocient, value
  ldi   division, 0
write__div:
  cpi   quocient, 10
  brlt  write__end_div
  inc   division
  subi  quocient, 10
  rjmp  write__div
write__end_div:
  ;primeiro digito
  ldi   ZL, low(cathode<<1)
  ldi   ZH, high(cathode<<1)
  add   ZL, quocient
  lpm   quocient, Z
  out   display, quocient
  rcall delay_low
  ;segundo digito
  ldi   ZL, low(cathode<<1)
  ldi   ZH, high(cathode<<1)
  add   ZL, division
  lpm   quocient, Z
  com   quocient
  out   display, quocient
  rcall delay_low
  ret

main:
  ldi   count, 0xFF
  out   DDRD, count
  out   display, count
  cbi   DDRB, button
  sts   UCSR0B, R1
  ldi   value, 0
main__loop:
  rcall inc_count
  ; se o botão não estiver apertado...
  sbis  PINB, button
  ; escreve o número anterior
  rcall wait_and_write
  sbis  PINB, button
  ; e então continue no loop
  rjmp  main__loop
  mov   value, count
main__change:
  rcall wait_and_write
  sbic  PINB, button
  rjmp  main__change
  rjmp  main__loop

cathode: .db 0b1111110, 0b0110000, 0b1101101, 0b1111001, 0b0110011, 0b1011011, 0b1011111, 0b1110000, 0b1111111, 0b1110011
