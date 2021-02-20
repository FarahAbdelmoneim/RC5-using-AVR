
.DEF Alow= R16
.DEF Ahigh= R17
.DEF Blow= R18
.DEF Bhigh= R19
    LDI Alow, 0x34
    LDI Ahigh, 0x12
    LDI Blow, 0x56
    LDI Bhigh, 0x78

    LDI R26, 0X77
    LDI R27, 0X01

;ENCRYPTION
    ADD Alow,R20
    ADC Ahigh,R21
    ADD Blow,R22
    ADC Bhigh,R23
    LDI R24,8
    LDI R25, 0X0F
    ;AND R25, Blow
LOOP1 
    EOR Alow,Blow
    EOR Alow,Bhigh
    AND R25, Blow
    BREQ START5
LOOP2
    SBRS Ahigh, 7
    CLC
    SBRC Ahigh, 7
    SEC
    ROL Alow
    ROL Ahigh
    DEC R25
    BRNE LOOP2
START5
    LD R22,X+
    LD R23,X+ 

    LD R22,X+
    LD R23,X+   
    ADD Alow, R22
    ADC Ahigh,R23
    LDI R25,0X0F
    EOR Blow,Alow
    EOR Bhigh,Ahigh
    AND R25,Alow
    BREQ START4
LOOP3
    SBRS Bhigh, 7
    CLC
    SBRC Bhigh, 7
    SEC
    ROL Blow
    ROL Bhigh
    DEC R25
    BRNE LOOP3
START4
    LD R22,X+
    LD R23,X+ 

    LD R22,X+
    LD R23,X+   
    ADD Blow, R22
    ADC Bhigh,R23
    DEC R24
    BRNE LOOP1
    STS 0x0160,Alow
    STS 0x0161,Ahigh
    STS 0x0162,Blow
    STS 0x0163,Bhigh

   


;DECRYPTION
    LDI R24,8
    LDI R25, 0X0F
    ;AND R25, Alow
NEXT 
    SUB Blow,R22
    SBC Bhigh,R23
    AND R25, Alow
    BREQ START3
NEXT2
    SBRS Bhigh, 0
    CLC
    SBRC Bhigh, 0
    SEC
    ROR Blow
    ROR Bhigh
    DEC R25
    BRNE NEXT2
START3
    EOR Blow,Alow
    EOR Bhigh,Ahigh
    LDI R25,0X0F
    AND R25, Blow
    BREQ START2

    LD R22,-X
    LD R23,-X

    LD R22,-X
    LD R23,-X
    SUB Alow,R22
    SBC Ahigh,R23
NEXT3

    SBRS Ahigh, 0
    CLC
    SBRC Ahigh, 0
    SEC
    ROR Alow
    ROR Ahigh
    DEC R25
    BRNE NEXT3
START2
    EOR Alow,Blow
    EOR Ahigh,Bhigh

    LD R22,-X
    LD R23,-X

    LD R22,-X
    LD R23,-X
    DEC R24
    BRNE NEXT
    SUB Blow,R22
    SBC Bhigh,R23
    SUB Alow,R20
    SBC Ahigh,R21
    STS 0x0160,Alow
    STS 0x0161,Ahigh
    STS 0x0162,Blow
    STS 0x0163,Bhigh

;EXPANSION
; first step
; MAKING 12 REGISTER FOR THE K EACH 8-BIT
    LDI R22, 12
    LDI R25, 1
    LDI R28, 0X40 ; SETTING THE Y REGISTER TO THE LOCATION 0X0140 SO IT CAN START INCREMENTING FROM THAT
    LDI R29, 0X01
    ST  Y, R25
L1  ADD R25, R22
    ST  Y+, R25 
    DEC R22
    BRNE L1
    LDI R28, 0X40  ; SETTING THE Y REGISTER TO THE LOCATION 0X0140 SO IT CAN START INCREMENTING FROM THAT
    LDI R29, 0X01
;second step
; MAKING THE S (18 REGISTER EACH 16- BIT)
    LDI R24,18
    LDI R20,0XE1
    LDI R21,0XB7
    LDI R22,0X37
    LDI R23,0X9E 
    LDI R26,0X77 ; ACCESING THE X REGISTER (LOWER AND HIGHIER BYTES)
    LDI R27,0X01
AGAIN
    ADD R20, R22 ; ADDS THE LOWER BYTE
    ADC R21, R23 ;ADDS THE HIGHER BYTE WITH CARRY
    ST  X, R20   ; STORES THE RESULT OF LOWER BYTE IN LOCATION OF X THAT STARTS WITH (0X0177)
    INC R26 ; GOES TO THE NEXT LOCATION
    ST X, R21 ; STORES HIGHER BYTE IN THE NEXT LOCATION
    INC R26 ; INCREMENT IT FOR THE NEXT STORING PROCESS AND REPEAT THE LOOP
    DEC R24
    BRNE AGAIN
    LDI R26,0X77
    LDI R27,0X01
;third step
.DEF Alow= R16
.DEF Ahigh= R17
.DEF Blow= R18
.DEF Bhigh= R19
    LDI Alow, 0X00
    LDI Ahigh, 0x00
    LDI Blow, 0x00
    LDI Bhigh, 0x00
    LDI R23,6 ; COUNTER FOR L
    LDI R24, 18 ; COUNTER FOR 
    LDI R22, 54
REPEAT3    
    LDI R25, 3
    ADD Alow, Blow
    ADC Ahigh, Bhigh
    LD R20,X
    ADD Alow, R20
    ST X,Alow
    LD R20,X+
    ADC Ahigh, R20
    ST X, Ahigh
REPEAT   
    SBRS Ahigh, 7
    CLC
    SBRC Ahigh, 7
    SEC
    ROL Alow
    ROL Ahigh
    DEC R25
    BRNE REPEAT
    DEC R23 ;DECREASING COUNTER
    BREQ BEG
BACK
    LDI R30, 0X0F
    LD R21,Y
    ADD Blow,Alow
    ADC Bhigh, Ahigh
    ADD Blow, R21
    LD,R21,Y+
    ADC Bhigh, R21
    AND R30, Blow
    BREQ START
REPEAT2  
    SBRS Bhigh, 7
    CLC
    SBRC Bhigh, 7
    SEC
    ROL Blow
    ROL Bhigh
    DEC R30
    BRNE REPEAT2
START    
    DEC R24
    BREQ BEG2
BACK2    
    DEC R22
    BRNE REPEAT3
BEG LDI R28, 0X40  ; SETTING THE Y REGISTER TO THE LOCATION 0X0140 SO IT CAN START INCREMENTING FROM THAT
    LDI R29, 0X01
    LDI R23,6 ; COUNTER FOR L
    JMP BACK
BEG2 LDI R26, 0X77  ; SETTING THE Y REGISTER TO THE LOCATION 0X0140 SO IT CAN START INCREMENTING FROM THAT
    LDI R27, 0X01
    LDI R24,18 ; COUNTER FOR s
    JMP BACK2