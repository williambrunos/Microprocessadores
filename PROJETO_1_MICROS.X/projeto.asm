#include "p18f4550.inc"             ; incluir o pic utilizado
 ; configurações necessárias 
CONFIG FOSC = XT_XT 
CONFIG WDT = OFF
CONFIG LVP = OFF 

VARIAVEIS UDATA_ACS 0	; Seção de dados não inicializados
    CONT     RES 1	; Variável contadora para a soma e subtração
    CONT1    RES 1	; Primeira contadora para o delay
    CONT2    RES 1      ; Segunda contadora para o delay
    SWT1     EQU .1     ; Botão 1 que incrementa + 1 à variável CONT
    SWT2     EQU .2     ; Botão 2 que decrementa - 1 à variável CONT
     
RES_VECT  CODE    0x0000     
    GOTO    START                   
MAIN_PROG CODE

START
    BSF TRISC, SWT1    ; Torna o swt1 como entrada -> TRISB
    BSF TRISC, SWT2    ; Torna o swt2 como entrada -> TRISB
    MOVLW b'0'         ; move 0 (binário) para o w
    MOVWF TRISD        ; torna a porta D como saída
    
    LOOP
	BTFSC PORTC, SWT1 ; Verficar se o portb na posição stw1 é 0 ou 1
	CALL INCREMENT
	BTFSC PORTC, SWT2 ; Verificar se o portb na posição stw2 é 0 ou 1
	CALL DECREMENT
	
	MOVLW         CONT        ; movimenta o que está em CONT para W
	MOVWF         PORTD       ; movimenta o que está em W para PORTD (saída)

    GOTO LOOP

    INCREMENT
      CALL	    DELAY200MS	;{Verifica se o botão fica pressionado por 1 segundo
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS	;}
      BTFSS	    PORTC, SWT1	; pula caso o botão ainda esteja pressionado depois de 1 segundo
      RETURN
      BTFSC PORTC, SWT2		; Se o botão 2 estiver pressionado ao mesmo tempo que o 1...
      RETURN			; ... retorna para LOOP
      INCF	    CONT	; incrementa 1 no registrador cont
      

     RETURN
     
    DECREMENT
      CALL	    DELAY200MS	;{Verifica se o botão fica pressionado por 1 segundo
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS	;}
      BTFSS	    PORTC,SWT2	; Caso o botão ainda esteja pressionado depois de 1 sec
      RETURN
      BTFSC PORTC, SWT1		; Se o botão 1 estiver apertado ao mesmo tempo que o botão 2...
      RETURN			; ... retorna para LOOP
      DECF	    CONT	; decrementa 1 no registrador cont
      
    RETURN

     DELAY200MS
     MOVLW .200			;Coloca o valor 200 no registrador
     MOVWF CONT1		;Passa o valor 200 do registrador para variável CONT1

    DELAYM
     CALL DELAY200U		;Chama a função de delay de 200us
     CALL DELAY200U		;Chama a função de delay de 200us
     CALL DELAY200U		;Chama a função de delay de 200us
     CALL DELAY200U		;Chama a função de delay de 200us
     CALL DELAY200U		;Chama a função de delay de 200us
     DECFSZ CONT1		;Decrementa CONT2 e pula caso seja 0
     BRA DELAYM			;Volta para a Subrotina DELAYM
     RETURN			;Retorna para a última posição antes da função

    DELAY200U		
     MOVLW .46			;Coloca o valor 46 no registrador
     MOVWF CONT2		;Passa o valor 46 do registrador para variável CONT1
     
    DELAY
    NOP				;Não faz nada por 1 ciclo de clock
    DECFSZ CONT2		;Decrementa CONT1 e pula caso seja 0
    BRA DELAY			;Volta para a Subrotina DELAY
    BTFSC PORTC,SWT1		;Caso o pino stw1 fique em zero em algum momento ele retorna
    RETURN			;Retorna para a ultima posição antes da função
    BTFSC PORTC,SWT2		;Caso o pino stw2 um fique em zero em algum momento ele não pula 
    RETURN			;Retorna para a ultima posição antes da função
    
    POP			;Limpa pilha
    POP			;Limpa pilha
    POP			;Limpa pilha
    GOTO LOOP		;volta para o loop principal
    
    
END