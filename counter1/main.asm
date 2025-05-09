.nolist
.include "../m328Pdef.inc"
.list

.def count = r24
.def aux = r22

.org 0x0000
	rjmp main


main:
    ldi		count, 0xff
	out		DDRB, count
	out		PORTB, count
loop:
	inc 	count
	ldi		aux, 10;
	cpse	count, aux;
	rjmp	check
	ldi 	count, 0;

check:
	cpi		count, 0
	brne	check1
	ldi 	aux, 0b1111110
	out		PORTB, aux 
	rjmp	end
check1:
	cpi		count, 1
	brne	check2
	ldi 	aux, 0b0110000
	out		PORTB, aux 
	rjmp	end
check2:
	cpi		count, 2
	brne	check3
	ldi 	aux, 0b1101101
	out		PORTB, aux 
	rjmp	end
check3:
	cpi		count, 3
	brne	check4
	ldi 	aux, 0b1111001
	out		PORTB, aux 
	rjmp	end
check4:
	cpi		count, 4
	brne	check5
	ldi 	aux, 0b0110011
	out		PORTB, aux 
	rjmp	end
check5:
	cpi		count, 5
	brne	check6
	ldi 	aux, 0b1011011
	out		PORTB, aux 
	rjmp	end
check6:
	cpi		count, 6
	brne	check7
	ldi 	aux, 0b1011111
	out		PORTB, aux 
	rjmp	end
check7:
	cpi		count, 7
	brne	check8
	ldi 	aux, 0b1110000
	out		PORTB, aux 
	rjmp	end
check8:
	cpi		count, 8
	brne	check9
	ldi 	aux, 0b1111111
	out		PORTB, aux 
	rjmp	end
check9:
	cpi		count, 9
	brne	end
	ldi 	aux, 0b1111011
	out		PORTB, aux 
	rjmp	end

end:
	rcall 	delay_500ms
	rjmp 	loop

delay_500ms:
	ldi		r20, 64
delay2:
	ldi		r19, 128
delay1:
	ldi		r18, 255
delay0:
	dec		r18
	brne	delay0
	dec		r19
	brne	delay1
	dec		r20
	brne	delay2
	ret