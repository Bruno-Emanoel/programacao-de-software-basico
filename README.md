# Projetos de Programação de Software Básico - Bruno Emanoel

Repositório dedicado aos projetos da disciplina **Programação de Software Básico** na **Universidade Federal da Bahia (UFBA)**.  
Todos os projetos são desenvolvidos em **Assembly AVR (ATmega328)** e simulados no **SimulIDE**.

## 📌 Sobre
- **Linguagem**: Assembly AVR (para ATmega328).
- **Ferramenta**: SimulIDE (arquivos `.sim1`).
- **Objetivo**: Estudo de conceitos de baixo nível (registradores, periféricos, temporização, etc.).

## 📂 Estrutura do Repositório
```
|--_projeto_1 # Exemplo: Piscar LED
|  |--_src # Pasta de arquivos de código fonte assembly fora do principal
|     |--foo.asm
|  |--main.asm # Código fonte principal em assembly
|  |--circuito.sim1 # Arquivo de simulação
|--_projeto_2 # Exemplo: Leitura de ADC
...
```

## ⚙️ Como Usar
1. **SimulIDE**: Abra o arquivo `.sim1` no [SimulIDE](https://www.simulide.com/).
2. **Compilação**: Use `avra` ou `avr-gcc` para gerar o `.hex`:
   ```bash
   avra main.asm
3. **Carregue no SimulIDE**:
- Selecione o ATmega328 no simulador.
- Carregue o .hex gerado.

## 📝 Notas

  Estes projetos foram criados para fins educacionais e seguem os tópicos da disciplina.

## 📚 Recursos

[Manual do ATmega328](https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf)

[SimulIDE Documentation](https://simulide.com/p/simulidekb/)
