/* 
 * 
 * File:   main.c
 * Author: William Bruno Sales de Paula Lima
 * Matrícula: 497345
 * Disciplina: Microprocessadores
 *
 */

#include <xc.h>
#define _XTAL_FREQ 4e6 // 4 MHz
#define saida PORTCbits.RC0
#define entrada PORTD

void main(void) {
    TRISD = 0xFF; // 0b11111111 -> Tornando toda a porta D como enrada (8 botões)
    TRISCbits.RC0 = 0; // tornando a porta RC0 como saída
    entrada = PORTD;
    
    while (1) {
        saida = 0;
                
        switch(entrada) {
            case (0b00000001): 
                __delay_ms(1.911);
                break;
            case (0b00000010): 
                __delay_ms(1.7025);
                break;
            case (0b00000100): 
                __delay_ms(1.517);
                break;
            case (0b00001000): 
                __delay_ms(1.4315);
                break;
            case (0b00010000): 
                __delay_ms(1.2755);
                break;
            case (0b00100000): 
                __delay_ms(1.1365);
                break;
            case (0b01000000): 
                __delay_ms(1.0125);
                break;
            case (0b10000000): 
                __delay_ms(0.9555);
                break;
            default: 
                continue;
        }
        
        saida ^= 1;
    }
}

