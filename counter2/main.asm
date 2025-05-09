.nolist
.include "../m328Pdef.inc"
.list

.def count = r24
.def aux = r22
.def division = r20
.def temp = r19

.org 0x0000
	rjmp main

delay_low:
  ldi		r21, 10
delay_low0:
	dec		r21
	brne	delay_low0
  ret

write:
  mov   aux, count
  ldi   division, 0
div_aux:
  cpi   aux, 10
  brlt  end_div_aux
  inc   division
  subi   aux, 10
  rjmp  div_aux
end_div_aux:
  ;primeiro digito
  ldi   ZL, low(cathode<<1)
  ldi   ZH, high(cathode<<1)
  add   ZL, aux
  lpm   aux, Z
  out   PORTB, aux
  rcall delay_low
  ;segundo digito
  ldi   ZL, low(cathode<<1)
  ldi   ZH, high(cathode<<1)
  add   ZL, division
  lpm   aux, Z
  com   aux
  out   PORTB, aux
  rcall delay_low
  ;limpa
  
  ret

main:
  ldi		count, 0xff
	out		DDRB, count
	out		PORTB, count
loop:
	inc 	count
	ldi		aux, 60;
	cpse	count, aux;
	rjmp	end
	ldi 	count, 0;

end:
	rcall delay_and_write
	rjmp 	loop

delay_and_write:
	ldi		r18, 16
delay2:
	ldi		r16, 32
delay1:
	ldi		r17, 64
delay0:
  rcall write
	dec		r17
	brne	delay0
	dec		r16
	brne	delay1
	dec		r18
	brne	delay2
	ret


cathode: .db 0b1111110, 0b0110000, 0b1101101, 0b1111001, 0b0110011, 0b1011011, 0b1011111, 0b1110000, 0b1111111, 0b1110011
