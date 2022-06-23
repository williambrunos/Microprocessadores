#include "p18f4550.inc"             ; incluir o pic utilizado
 ; configura��es necess�rias 
CONFIG FOSC = XT_XT 
CONFIG WDT = OFF
CONFIG LVP = OFF 

VARIAVEIS UDATA_ACS 0	; Se��o de dados n�o inicializados
    CONT     RES 1	; Vari�vel contadora para a soma e subtra��o
    CONT1    RES 1	; Primeira contadora para o delay
    CONT2    RES 1      ; Segunda contadora para o delay
    SWT1     EQU .1     ; Bot�o 1 que incrementa + 1 � vari�vel CONT
    SWT2     EQU .2     ; Bot�o 2 que decrementa - 1 � vari�vel CONT
     
RES_VECT  CODE    0x0000     
    GOTO    START                   
MAIN_PROG CODE

START
    BSF TRISC, SWT1    ; Torna o swt1 como entrada -> TRISB
    BSF TRISC, SWT2    ; Torna o swt2 como entrada -> TRISB
    MOVLW b'0'         ; move 0 (bin�rio) para o w
    MOVWF TRISD        ; torna a porta D como sa�da
    
    LOOP
	BTFSC PORTC, SWT1 ; Verficar se o portb na posi��o stw1 � 0 ou 1
	CALL INCREMENT
	BTFSC PORTC, SWT2 ; Verificar se o portb na posi��o stw2 � 0 ou 1
	CALL DECREMENT
	
	MOVLW         CONT        ; movimenta o que est� em CONT para W
	MOVWF         PORTD       ; movimenta o que est� em W para PORTD (sa�da)

    GOTO LOOP

    INCREMENT
      CALL	    DELAY200MS	;{Verifica se o bot�o fica pressionado por 1 segundo
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS	;}
      BTFSS	    PORTC, SWT1	; pula caso o bot�o ainda esteja pressionado depois de 1 segundo
      RETURN
      BTFSC PORTC, SWT2		; Se o bot�o 2 estiver pressionado ao mesmo tempo que o 1...
      RETURN			; ... retorna para LOOP
      INCF	    CONT	; incrementa 1 no registrador cont
      

     RETURN
     
    DECREMENT
      CALL	    DELAY200MS	;{Verifica se o bot�o fica pressionado por 1 segundo
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS
      CALL	    DELAY200MS	;}
      BTFSS	    PORTC,SWT2	; Caso o bot�o ainda esteja pressionado depois de 1 sec
      RETURN
      BTFSC PORTC, SWT1		; Se o bot�o 1 estiver apertado ao mesmo tempo que o bot�o 2...
      RETURN			; ... retorna para LOOP
      DECF	    CONT	; decrementa 1 no registrador cont
      
    RETURN

     DELAY200MS
     MOVLW .200			;Coloca o valor 200 no registrador
     MOVWF CONT1		;Passa o valor 200 do registrador para vari�vel CONT1

    DELAYM
     CALL DELAY200U		;Chama a fun��o de delay de 200us
     CALL DELAY200U		;Chama a fun��o de delay de 200us
     CALL DELAY200U		;Chama a fun��o de delay de 200us
     CALL DELAY200U		;Chama a fun��o de delay de 200us
     CALL DELAY200U		;Chama a fun��o de delay de 200us
     DECFSZ CONT1		;Decrementa CONT2 e pula caso seja 0
     BRA DELAYM			;Volta para a Subrotina DELAYM
     RETURN			;Retorna para a �ltima posi��o antes da fun��o

    DELAY200U		
     MOVLW .46			;Coloca o valor 46 no registrador
     MOVWF CONT2		;Passa o valor 46 do registrador para vari�vel CONT1
     
    DELAY
    NOP				;N�o faz nada por 1 ciclo de clock
    DECFSZ CONT2		;Decrementa CONT1 e pula caso seja 0
    BRA DELAY			;Volta para a Subrotina DELAY
    BTFSC PORTC,SWT1		;Caso o pino stw1 fique em zero em algum momento ele retorna
    RETURN			;Retorna para a ultima posi��o antes da fun��o
    BTFSC PORTC,SWT2		;Caso o pino stw2 um fique em zero em algum momento ele n�o pula 
    RETURN			;Retorna para a ultima posi��o antes da fun��o
    
    POP			;Limpa pilha
    POP			;Limpa pilha
    POP			;Limpa pilha
    GOTO LOOP		;volta para o loop principal
    
    
END