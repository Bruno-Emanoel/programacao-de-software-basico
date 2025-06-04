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
; ver main, última função deste código

delay_and_write:
  ldi   r21, 11
delay__0:
  ldi   r22, 22
delay__1:
  ldi   r23, 33
delay__2:
; aqui é feita a escrita utilizando a técnica de multiplexação "varredura"
; é utilizado a variável "param" para guarda o valor que será escrito em portb
; a multiplexação é feita ao fazer clear no bit referen ao digito que está sendo escrito
  mov   param, count1 ; primeiro digito escrito será unidade
  cbi   PORTB, 0      ; usar pb0 como terra
  rcall write         ; escrever o número escrito em param
  mov   param, count2 ; segundo digito escrito será a dezena
  sbi   PORTB, 0      ; deixar de usar pb0 como terra
  cbi   PORTB, 1      ; usar pb1 como terra
  rcall write         ; escrever o número escrito em param
  mov   param, count3 ; terceiro digito escrito será a centena
  sbi   PORTB, 1      ; deixar de usar pb1 como terra
  cbi   PORTB, 2      ; usa pb2 como terra
  rcall write         ; escrever o número escrito em param
  sbi   PORTB, 2      ; deixar de usar pb2 como terra

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
  ; essa função usa o endereço da tabela de mapeamento para número em 7 segmentos
  ; utilizando de um offset guardado na variável "param", setada antes da chamad dessa função
  ; Ele então escreve em PORTC o valor recuperado e aguarda alguns instantes
  ldi   ZH, high(table<<1)  ; pegar a parte mais significativa do endereço da tabela. o bit menos significativo é ignorado(vide doc)
  ldi   ZL, low(table<<1)   ; pegar a parte menos significativa do endereço da tabela. o bit menos significativo é ignorado(vide doc)
  add   ZL, param           ; usar param como offset/indice na tabela para o valor desejado
  brcc  write__not_carry    ; caso não haja carry vá para aquele label 
  inc   ZH                  ; caso haja, incremente a parte mais significativa
write__not_carry:
  lpm   aux, Z              ; recupere o valor apontado por Z
  out   PORTC, aux          ; escreva o valor recuperado em portc
  rcall  delay_low          ; espere um pouco para o valor ficar visível por um tempo
  ldi   aux, 0              ; colocar 0 em aux
  out   PORTC, aux          ; zera o que está em portc para não acontecerem interferências
  ret

main:
  clr   count2       ; count 2 é zerado
  clr   count3       ; count 3 é zerado
  ldi   count1, 0xff ; count 1 recebe valor 0b11111111 pois será incrementado em seguida
  out   DDRC, count1 ; todos os pins em ddrc são de saída
  ldi   aux, 0b111   ; aux recebe 7 em binário
  out   DDRB, aux    ; pb0, pb1 e pb2 são indicados como saída
  out   PORTB, aux   ; pb0, pb1 e pb2 são setado, isso pq quando um deles for zero seu respectivo led irá ligar
  ldi   aux, 0       ; aux é zerado
  out   PORTC, aux   ; port c é limpo

loop:
; o início do loop geral do programa consiste em incrementar o valor que será exibido
; então será chama a função de delay que também escreve os valores
  inc   count1       ; incrementa o primeiro contador, unidade
  cpi   count1, 10   ; compare o novo valor de unidade com 10
  brne  loop__if     ; se for diferente de 10, vá para esse label
  clr   count1       ; se for igual a 10, limpe o registrador

  inc   count2       ; e então incremente o valor da dezena
  cpi   count2, 10   ; compare agora o novo valor de dezena com 10
  brne  loop__if     ; se for diferente, vá para esse label
  clr   count2       ; se for igual, limpe o registrador

  inc   count3       ; e então incremente o valor de centena
  cpi   count3, 10   ; compare o novo valor de centena com 10
  brne  loop__if     ; se for diferente, vá para esse label
  clr   count3       ; se for igual, limpe o registrado
loop__if:
  rcall  delay_and_write ; delay e escreve
  rjmp  loop ; retorne para o início do loop



table:
  .db 0b111111, 0b110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b111, 0b1111111, 0b1101111