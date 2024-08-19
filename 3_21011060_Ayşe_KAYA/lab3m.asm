    PUBLIC MEDYAN_HESAP
    EXTRN sayilar:word,n:word,sonuc:word
my_code SEGMENT PARA 'code'
                 ASSUME CS:my_code
MEDYAN_HESAP PROC FAR
                 PUSH   SI
                 PUSH   CX
                 PUSH   DI
                 PUSH   BX

                 MOV    SI,2
                 MOV    CX,n
                 DEC    CX
    L2:          MOV    AX,sayilar[SI]    ;AX<-key
                 SUB    SI,2
                 MOV    DI,SI
                 ADD    SI,2
    while:       CMP    DI,0              ; j>=0
                 JL     cik
                 MOV    BX,sayilar[DI]   ;BX<-sayilar[j]
                 CMP    BX,AX    ; sayilar[j]>key(AX)
                 JLE    cik
                 MOV    sayilar[DI+2],BX   ;BX<-sayilar[j+1]=sayilar[j]
                 SUB    DI,2
                 JMP    while
    cik:         MOV    sayilar[DI+2],AX    ;sayilar[j+1]=key
                 ADD    SI,2
                 LOOP   L2                ; insertion sort for loop
                 
                
                 MOV    CX,n  
                 SHR    CX,1
                 JC     tek
                 XOR    SI,SI
            L3:  MOV    AX, sayilar[SI]
                 ADD    SI,2
                 LOOP   L3
                 ADD    AX,sayilar[SI]
                 SHR    AX,1
                 MOV    sonuc,AX
                 JMP    bitis
    tek:         XOR    SI,SI
    L4:          MOV    AX, sayilar[SI]
                 ADD    SI,2
                 LOOP   L4
                 MOV    AX,sayilar[SI]
                 MOV    sonuc,AX
    bitis:       POP    BX
                 POP    DI
                 POP    CX
                 POP    SI
                 RETF
MEDYAN_HESAP ENDP       
my_code ENDS
             END



