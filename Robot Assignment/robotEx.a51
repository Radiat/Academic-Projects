;------------------------------------------------------------------------------
;Name: robotEx.a51
;Description: Example 8051 assembly program
;Programmer: Gyula Lorincz
;Language: 8051 ASM
;Date: Nov. 6, 2002
;Edit: 1
;
;
;Modules used:
;  trilodef.asm
;
;Revision History:
;
;Public Routines:
;
;Public Variables:
;
;Public Constants:
;
;Private Routines:
;
;Private Variables:
;
;Private Constants:
;
;------------------------------------------------------------------------------


	
$ nolist
$ include (trilodef.asm)  	;Trilobot system definitions.
$ list


	CSEG	at	0100h		;Start program above vectors.

start:      	
	lcall	trmclr		;Clear LCD.
	lcall	trmpsi		;Message on LCD.
	db	0			;Top line.
	db	'Trilobot'
	db	0
	lcall	trmpsi		;Message on LCD.
	db	40h			;Bottom line.
	db	'robotEx.a51'
	db	0

	;Wait.
	mov	a, #1			;Wait 1 sec
	lcall	utlwas
	
loop:	mov	A, #1			;Wait 1 sec
	lcall	utlwas    
	lcall	sioget          
	lcall	sioput        	;get command and echo 
for:	cjne	A, #'8', stop	;8 is forward
	mov	A, #50H
	lcall	utlgoc
	sjmp	loop

stop:	mov	A, #0FFH     	;otherwise stop    
	lcall	utlgoc      
	sjmp	loop    
	
;----------------------------------------------------------------------
	end
