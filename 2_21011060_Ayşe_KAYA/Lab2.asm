codesg SEGMENT PARA 'tum'
                     ORG    100h
                     ASSUME CS:codesg,SS:codesg,DS:codesg
       start:        JMP    fibo
       fprev         DW     1
       bprev         DW     1
       tmp           DW     ?
       flag          DB     1
       nonPrimeIndex DW     2
       primeIndex    DW     0
       prime         DW     20 DUP(?)
       nonPrime      DW     20 DUP(?)
fibo PROC   NEAR
                     MOV    CX,18 
                     XOR    SI,SI
                     MOV    nonPrime[SI],1
       L1:           MOV    tmp,0
                     MOV    DI,2
                     MOV    flag,1                              ; MOV DADDR,DATA8 komutu var
                     MOV    BX,bprev
                     MOV    AX,fprev
                     ADD    tmp,AX
                     ADD    tmp,BX
                     MOV    AX,tmp
                     XOR    DX,DX
                     MOV    BX,2
                     DIV    BX
       while:        CMP    AX,DI                               ;AL->tmp/2
                     JB     fkontrol
                     CMP    flag,1
                     JNE    false
                     XOR    DX,DX
                     MOV    AX,tmp
                     DIV    DI
                     CMP    DX,0
                     JNE    for
                     MOV    flag,0
                     JMP    while
       for:          INC    DI
                     JMP    while
       fkontrol:     CMP    flag,1
                     JE     true
       false:        MOV    AX, tmp
                     MOV    BX,nonPrimeIndex
                     MOV    nonPrime[BX],AX
                     ADD    nonPrimeIndex,2
                     JMP    ifcikis
       true:         MOV    AX, tmp
                     MOV    BX,primeIndex
                     MOV    prime[BX],AX
                     ADD    primeIndex,2
       ifcikis:      MOV    AX,fprev
                     MOV    bprev,AX
                     MOV    AX,tmp
                     MOV    fprev,AX
                     LOOP   L1
                     RET
fibo ENDP
codesg ENDS
       END start
