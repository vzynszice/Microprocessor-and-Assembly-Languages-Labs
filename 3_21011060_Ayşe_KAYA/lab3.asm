     EXTRN MEDYAN_HESAP:FAR   
     PUBLIC sayilar,n,sonuc
myds SEGMENT PARA 'veri'
    CR      EQU 13
    LF      EQU 10
    MSG1    DB  CR,LF,'n giriniz: ',0
    MSG2    DB  CR,LF,'Siradaki elemani girin: ',0
    MSG3    DB  CR,LF,'sonuc: ',0
    HATA    DB  CR,LF,'n sayisi 0-10 arasinda olmalidir!',0
    n       DW  ?
    sayilar DW  10 DUP(?)
    sonuc   DW  ?
myds ENDS
myss SEGMENT PARA STACK 'yigin'
         DW 40 DUP(?)
myss ENDS
mycs SEGMENT PARA 'kod'
                  ASSUME     CS:mycs,SS:myss,DS:myds
GIRIS_D    MACRO sayilar,n,MSG2
           LOCAL L1
           MOV CX,n
           XOR SI,SI
L1:        MOV AX,OFFSET MSG2
           CALL PUT_STR
           CALL GETN
           MOV sayilar[SI],AX
           ADD SI,2
           LOOP L1
           ENDM 
MAIN PROC FAR
                  PUSH       DS
                  XOR        AX,AX
                  PUSH       AX
                  MOV        AX,myds
                  MOV        DS,AX

    ;--------n girişi------

    giris:        MOV        AX,OFFSET MSG1
                  CALL       PUT_STR
                  CALL       GETN
                  MOV        n,AX
                  CMP        n,10
                  JG         hatad
                  CMP        n,0
                  JG         dizigir
    hatad:        MOV        AX,OFFSET HATA
                  CALL       PUT_STR
                  JMP        giris

    ;-----dizi girisi
    
    dizigir:      GIRIS_D    sayilar,n,MSG2
                  MOV        AX,n 
                  CALL       PUTN
                  MOV        CX,n
                  XOR       SI,SI
     yazdir:      MOV        AX,sayilar[SI]
                  CALL       PUTN
                  ADD        SI,2
                  LOOP       yazdir
                  CALL       PUTN
                  CALL       MEDYAN_HESAP
                  MOV        AX,OFFSET MSG3
                  CALL       PUT_STR
                  MOV        AX,sonuc
                  CALL       PUTN
                  RETF
MAIN ENDP
      
PUTC PROC NEAR                                          ;
                  PUSH       AX
                  PUSH       DX
                  MOV        DL,AL
                  MOV        AH,2
                  INT        21H
                  POP        DX
                  POP        AX
                  RET
PUTC ENDP                                               ;AL yazmacındaki değeri gösterir

GETC PROC NEAR
                  MOV        AH,1h
                  INT        21H
                  RET
GETC ENDP

GETN PROC NEAR                    ;Klavyeden basılan sayıyı okur, sonucu AX üzerinden döndürür
                  PUSH       BX
                  PUSH       CX
                  PUSH       DX
    GETN_START:   MOV        DX,1
                  XOR        BX,BX
                  XOR        CX,CX
    NEW:          CALL       GETC
                  CMP        AL,CR
                  JE         FIN_READ
                  CMP        AL,'-'
                  JNE        CTRL_NUM
    NEGATIVE:     MOV        DX,-1
                  JMP        NEW
    CTRL_NUM:     CMP        AL,'0'
                  JB         ERROR
                  CMP        AL,'9'
                  JA         ERROR
                  SUB        AL,'0'
                  MOV        BL,AL
                  MOV        AX,10
                  PUSH       DX
                  MUL        CX
                  POP        DX
                  MOV        CX,AX
                  ADD        CX,BX
                  JMP        NEW
    ERROR:        MOV        AX,OFFSET HATA
                  CALL       PUT_STR
                  JMP        GETN_START
    FIN_READ:     MOV        AX,CX
                  CMP        DX,1
                  JE         FIN_GETN
                  NEG        AX
    FIN_GETN:     POP        DX
                  POP        CX
                  POP        DX
                  RET
GETN ENDP

PUT_STR PROC  NEAR
                  PUSH       BX
                  MOV        BX,AX
                  MOV        AL,BYTE PTR [BX]
                  PUT_LOOP:  CMP AL,0
                  JE         PUT_FIN
                  CALL       PUTC
                  INC        BX
                  MOV        AL,BYTE PTR [BX]
                  JMP        PUT_LOOP
                  PUT_FIN:    POP BX
                  RET
PUT_STR ENDP

PUTN PROC NEAR
                  PUSH       CX
                  PUSH       DX
                  XOR        DX,DX
                  PUSH       DX
                  MOV        CX,10
                  CMP        AX,0
                  JGE        CALC_DIGITS
                  NEG        AX
                  PUSH       AX
                  MOV        AL,'-'
                  CALL       PUTC
                  POP        AX
    CALC_DIGITS:  DIV        CX
                  ADD        DX,'0'
                  PUSH       DX
                  XOR        DX,DX
                  CMP        AX,0
                  JNE        CALC_DIGITS
    DISP_LOOP:    POP        AX
                  CMP        AX,0
                  JE         END_DISP_LOOP
                  CALL       PUTC
                  JMP        DISP_LOOP
    END_DISP_LOOP:POP        DX
                  POP        CX
                  RET
PUTN ENDP
mycs ENDS
            END MAIN




