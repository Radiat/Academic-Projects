 CSEG  AT 4023H      
SER_VEC: LJMP SER_INT

  CSEG  AT 5000H
        USING  0
START: MOV   SP,#0C0H 
       CLR   TI   
       SETB  RS0
       MOV   R0,#BUFFER
       MOV   R2,#20
       CLR   RS0
       MOV   IE,#10010000B
LOOP:  SJMP  LOOP

        USING  1 
SER_INT: PUSH  PSW
        PUSH  ACC
        SETB  RS0
        JB    RI,L2
        CLR   TI
        JNB   FLAG,SER_DONE
        MOV   A,@R0
        MOV   SBUF,A
        INC   R0
        CLR   FLAG
        DJNZ  R2,SER_DONE
        MOV   IE,#0
        SJMP  SER_DONE
L2:     CLR   RI
        MOV   A,SBUF
        MOV   @R0,A
        SETB  TI
        SETB  FLAG
SER_DONE:POP  ACC
        POP  PSW
        RETI

        DSEG   AT 30H
BUFFER: DS    20

        BSEG AT 0
FLAG:   DBIT  1

         END
