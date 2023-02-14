DATA SEGMENT    
    MSGH1 DB 0DH,0AH,"JAYPEE INSTITUTE OF INFORMATION TECHNOLOGY$"
    MSGH2 DB 0DH,0AH,"            COA LAB PROJECT$" 
    MSGH3 DB 0DH,0AH,"------------------------------------------$" 
    MSGH4 DB 0DH,0AH,"      A SIMPLE 16 BIT CALCULATOR$" 
    MSGH5 DB 0DH,0AH,"$" 
         
    MSG DB 0AH,0DH, "ENTER OPERATOR (+,-,*,/,%,^): $" 
    MSG1 DB 0AH,0DH,"ENTER FIRST NUMBER: $"                                                                                 
    MSG2 DB 0AH,0DH,"ENTER SECOND NUMBER: $"                                               
    MSG3 DB 0DH,0AH,0DH,0AH,"SUM: $"
    MSG4 DB 0DH,0AH,"CARRY: $"
    MSG5 DB 0DH,0AH,"DIFFERENCE: $" 
    MSG6 DB 0DH,0AH,"PRODUCT: $" 
    MSG7 DB 0DH,0AH,"DIVISION: $" 
    MSG8 DB 0DH,0AH,"REMAINDER: $"  
    MSG9 DB 0DH,0AH,"POWER: $"
    DIVIDEZERO DB 0DH,0AH,"DIVIDE BY ZERO ERROR!$" 
    
    INVALID_MESSAGE DB 0AH,0DH, "INVALID INPUT$"    
    A DW 00H
    B DW 00H
    SUM DW 00H
    CARRY DB 00H
    DIFF DW 00H 
    MULTI1 DW 00H
    MULTI2 DW 00H
    DIV1 DW 00H
    DIV2 DW 00H
    POW1 DW 00H
    POW2 DW 00H
DATA ENDS    

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
START:   
    MOV AX,DATA
    MOV DS,AX 
    
    ; DISPLAY HEADINGS
    MOV AH,09H
    LEA DX,MSGH1
    INT 21H
    LEA DX,MSGH2
    INT 21H
    LEA DX,MSGH3
    INT 21H
    LEA DX,MSGH4
    INT 21H
    LEA DX,MSGH5
    INT 21H
     
    ; INPUT 1ST N0.
    MOV AH,09
    LEA DX,MSG1
    INT 21H 
    LEA SI,A
    CALL HSGET8
    MOV [SI+1],AL 
    CALL HSGET8
    MOV [SI],AL
        
    ; NEWLINE           
    MOV AH,09H
    LEA DX,MSGH5 
    INT 21H
            
    ; INPUT 1ST N0.
    MOV AH,09
    LEA DX,MSG2
    INT 21H 
    LEA SI,B
    CALL HSGET8
    MOV [SI+1],AL 
    CALL HSGET8
    MOV [SI],AL
    
    ; NEWLINE           
    MOV AH,09H
    LEA DX,MSGH5 
    INT 21H
    
    ; INPUT OPERATOR
    MOV AH,09H
    LEA DX,MSG 
    INT 21H 
    
    MOV AH,01H
    INT 21H   
    
    MOV BX,AX
     ; NEWLINE           
    MOV AH,09H
    LEA DX,MSGH5 
    INT 21H  
    MOV AX,BX
    
    CMP AL,'+'           
    JZ ADDITION 
    
    CMP AL,'-'          
    JZ SUBTRACTION       
               
    CMP AL,'*'           
    JZ MULTIPLICATION    
               
    CMP AL,'/'         
    JZ DIVISION         
               
    CMP AL,'%'          
    JZ MOD              
               
    CMP AL,'^'           
    JZ POW
       
    MOV AH,09H 
    LEA DX,INVALID_MESSAGE         
    INT 21H
          
    MOV AH,4CH
    MOV AL,00H
    INT 21H           
    

ADDITION:
    ; ADDITION LOGIC
     MOV AX,A
     ADD AX,B
     JNC SKIP
     INC CARRY
SKIP:MOV SUM,AX 

    ; DISPLAY RESULT
    MOV AH,09H
    LEA DX,MSG3
    INT 21H
    LEA SI,SUM 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
     
    MOV AH,09H
    LEA DX,MSG4
    INT 21H
    LEA SI,CARRY
    CALL HSPUT8
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H 
    
SUBTRACTION:
    ; SUBTRACTION LOGIC
    MOV AX,A
    SUB AX,B
    MOV DIFF,AX 

    ; DISPLAY RESULT
    MOV AH,09H
    LEA DX,MSG5
    INT 21H
    LEA SI,DIFF 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H 

MULTIPLICATION:
    ; MULTIPLICATION LOGIC
    MOV AX,A
    MOV BX,B 
    MOV DX,00H
    MUL BX
    MOV MULTI1,AX
    MOV MULTI2,DX 

    ; DISPLAY RESULT
    MOV AH,09H
    LEA DX,MSG6
    INT 21H
    LEA SI,MULTI2 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
    
    LEA SI,MULTI1 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H 

DIVISION: 
; DIVISION LOGIC
    MOV AX,A
    MOV BX,B
    MOV DX,00H
    ADD BX,DX 
    JZ DIVIDEBYZERO
    DIV BX
    MOV DIV1,AX
    MOV DIV2,DX 

    ; DISPLAY RESULT (QUOTIENT)
    MOV AH,09H
    LEA DX,MSG7
    INT 21H    
    LEA SI,DIV1 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H
    
DIVIDEBYZERO:
    MOV AH,09H
    LEA DX,DIVIDEZERO
    INT 21H
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H

MOD:
; DIVISION LOGIC
    MOV AX,A
    MOV BX,B
    MOV DX,00H
    ADD BX,DX 
    JZ DIVIDEBYZERO
    DIV BX
    MOV DIV1,AX
    MOV DIV2,DX 

    ; DISPLAY RESULT
    MOV AH,09H
    LEA DX,MSG8
    INT 21H
    LEA SI,DIV2 
    INC SI
    CALL HSPUT8
    DEC SI
    CALL HSPUT8
    
    MOV AH,4CH
    MOV AL,00H
    INT 21H

POW:        
   MOV DX,00H
   MOV AX,A
   MOV BX,B
   MOV CX,BX
   ADD CX,00H
   JZ ANS
   CMP CX,01H
   JZ ANS1
   DEC CX
BCK:
   MUL AX
   LOOP BCK
   JMP ANS1
 
ANS:
   MOV POW1,01H
   MOV POW2,00H
   JMP SKIP01

ANS1:
   MOV POW1,AX
   MOV POW2,DX
      
SKIP01:
   MOV AH,09H
   LEA DX,MSG9
   INT 21H
   LEA SI,POW2 
   INC SI
   CALL HSPUT8
   DEC SI
   CALL HSPUT8 
   
   LEA SI,POW1 
   INC SI
   CALL HSPUT8
   DEC SI
   CALL HSPUT8
    
   MOV AH,4CH
   MOV AL,00H
   INT 21H
     
PROC HSGET8  
    PUSH CX
    
    ;HIGHER NIBBLE
    MOV AH,0AH
    INT 21H   
    SUB AL,30H
    CMP AL,09H
    JLE G1
    SUB AL,07H
G1: MOV CL,04H
    ROL AL,CL 
    MOV CH,AL
    
    ;LOWER NIBBLE
    MOV AH,01H
    INT 21H
    SUB AL,30H
    CMP AL,09H
    JLE G2
    SUB AL,07H
G2: ADD AL,CH
    
    POP CX
    
    RET
ENDP HSGET8 

PROC HSPUT8  
    PUSH CX
    
    ; HIGHER NIBBLE
    MOV AL,[SI]
    AND AL,0F0H
    MOV CL,04H
    ROL AL,CL 
    ADD AL,30H
    CMP AL,39H
    JLE P1
    ADD AL,07H
P1: MOV AH,02H
    MOV DL,AL
    INT 21H
    
    MOV AL,[SI]
    AND AL,0FH
    ADD AL,30H
    CMP AL,39H
    JLE P2
    ADD AL,07H
P2: MOV AH,02H
    MOV DL,AL
    INT 21H
    
    POP CX
    
    RET
ENDP HSGET8  
     
CODE ENDS
END START