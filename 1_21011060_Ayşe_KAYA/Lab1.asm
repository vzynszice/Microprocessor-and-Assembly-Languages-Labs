datasg SEGMENT PARA 'veri'
    kilo   DD 82,62,64,86
    boy    DW 160,172,179,182
    vucut  DB 4 DUP(?)
    n      DW 4
datasg ENDS
stacksg SEGMENT PARA STACK 'yigin'
            DW 35 DUP(?)
stacksg ENDS
codesg SEGMENT PARA 'kod'
           ASSUME CS:codesg,DS:datasg,SS:stacksg
ANA PROC FAR
           PUSH   DS
           XOR    AX,AX
           PUSH   AX
           MOV    AX,datasg
           MOV    DS,AX
           MOV    CX,n
           XOR    SI,SI
           MOV    BX,10000   
    L1:    XOR    DX,DX
           MOV    AX, WORD PTR kilo[SI]
           MUL    BX
           MOV    WORD PTR kilo[SI+2],DX
           MOV    WORD PTR kilo[SI],AX
           ADD    SI,4 ; kilo dizisi Double Word olduğu için
           LOOP   L1

           MOV    CX,n
           XOR    SI,SI
    L2:    XOR    AX,AX
           MOV    AL,BYTE PTR boy[SI]
           MUL    AL ; taşma olacak sonu AX te
           MOV    boy[SI],AX
           ADD    SI,2 ; boy dizisi word tipinde
           LOOP   L2

           MOV    CX,n
           XOR    SI,SI
           XOR    DI,DI
           XOR    BX,BX
    L5:    MOV    DX,WORD PTR kilo[SI+2]
           MOV    AX,WORD PTR kilo[SI]
           DIV    boy[DI]
           MOV    vucut[BX],AL 
           ADD    DI,2
           INC    BX
           ADD    SI,4 ; Kilo dizisi double word tipinde 
           LOOP   L5

           XOR    SI,SI
           MOV    CX,n
    L3:    PUSH   CX
           MOV    CX,n
           SUB    CX,SI
           XOR    DI,DI
    L4:    MOV    AL,vucut[DI]
           CMP    DI,3
           JAE    son
           CMP    AL,vucut[DI+1]
           JBE    zipla
           MOV    BL,vucut[DI+1]
           MOV    vucut[DI],BL
           XCHG   AL,vucut[DI+1]
zipla:     INC    DI
           LOOP   L4
son:       POP    CX
           INC    SI
           LOOP   L3
           RETF
ANA ENDP
codesg ENDS
    END ANA
