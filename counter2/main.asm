.nolist
.include "../m328Pdef.inc"
.list

; Definição de registradores
.def count = r24      ; contador principal
.def aux = r22        ; registro auxiliar para cálculos
.def division = r20   ; armazena a dezena do número
.def temp = r19       ; registro temporário

.org 0x0000
  rjmp main         ; Pula para o programa principal

; Função de pequeno delay
delay_low:
  ldi   r21, 10      ; Carrega 10 no registrador r21
delay_low0:
  dec   r21          ; Decrementa r21
  brne  delay_low0   ; Se não chegou a zero, repete
  ret                ; Retorna da subrotina

; Função que escreve o número no display de 7 segmentos
write:
  mov   aux, count    ; Copia o valor do contador para aux
  ldi   division, 0   ; Zera o registrador de dezenas

; Loop para separar unidade e dezena
; Esse loop é feito para implementar um divisão euclidiana, pois não existe comando de divisão no atmega328
div_aux:                  ; while aux >= 10:
  cpi   aux, 10       ; Compara aux com 10
  brlt  end_div_aux   ; Se aux < 10, sai do loop
  inc   division      ; Incrementa a dezena (division++)
  subi  aux, 10       ; Subtrai 10 de aux (aux -= 10)
  rjmp  div_aux       ; Repete o loop
end_div_aux:

  ; Primeiro digito (unidade)
  ldi   ZL, low(cathode<<1)  ; Carrega parte baixa do endereço da tabela
  ldi   ZH, high(cathode<<1) ; Carrega parte alta do endereço da tabela
  add   ZL, aux              ; Adiciona o valor da unidade como offset
  lpm   aux, Z               ; Lê o padrão da tabela para o dígito
  out   PORTB, aux           ; Escreve o padrão no PORTB
  rcall delay_low            ; Pequeno delay para visualização

  ; Segundo digito (dezena)
  ldi   ZL, low(cathode<<1)  ; Recarrega endereço da tabela
  ldi   ZH, high(cathode<<1)
  add   ZL, division         ; Adiciona o valor da dezena como offset
  lpm   aux, Z               ; Lê o padrão da tabela
  com   aux                  ; Inverte os bits (para display de ânodo comum)
  out   PORTB, aux           ; Escreve no PORTB
  rcall delay_low            ; Pequeno delay

  ret

; Programa principal
main:
  ldi   count, 0xff     ; Carrega 0xFF no contador
  out   DDRB, count     ; Configura todos os pinos do PORTB como saída
  out   PORTB, count    ; Coloca todos os pinos do PORTB como ligados

; Loop principal
loop:
; nesse loop, é incrementado o contador que irá de 0 a 59
; quando o valor se tornar 60 ele será zerado
; ao fim, é chamada a função de delay e escrita
  inc   count           ; Incrementa o contador
  ldi   aux, 60         ; Carrega 60 no registrador auxiliar
  cpse  count, aux      ; Compara e pula se count == 60
  rjmp  end             ; Se não for igual, vai para 'end'
  ldi   count, 0        ; Se count chegou a 60, reinicia para 0
end:
  rcall delay_and_write ; Chama função de delay e escrita
  rjmp  loop            ; Volta para o início do loop

; Função de delay mais longo que também chama a escrita
delay_and_write:
	ldi		r18, 16
delay2:
	ldi		r16, 32
delay1:
	ldi		r17, 64
delay0:
; Aqui é chamada a função de escrita. E necessário chamá-la aqui pois está sendo feito multiplexing
; Dentro do multiplexing, o contador em que está sendo escrito alterna entre o primeiro e o segundo
; Para que esse mudança permaneça acontecendo é nessário chamar a função repetidas vezes
  rcall write ; Chama função para escrever no display
	dec		r17
	brne	delay0
	dec		r16
	brne	delay1
	dec		r18
	brne	delay2
	ret

; Tabela de padrões para display de 7 segmentos (cátodo comum)
cathode: .db 0b1111110, 0b0110000, 0b1101101, 0b1111001, 0b0110011, 0b1011011, 0b1011111, 0b1110000, 0b1111111, 0b1110011