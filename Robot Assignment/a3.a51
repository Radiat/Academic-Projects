	;------------------------------------------------------------------------------
	;Name: a3.a51
	;Description: Robot light-seeking program
	;Programmer: Chris Carpio
	;Language: 8051 ASM
	;Date: December 1, 2007
	;Edit: Too Many :(
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
	
	
	temp	EQU	07CH			;used for temporary storage on where to jump to
	currComm	EQU	07DH		;which key is currently pressed
	COLON EQU 07EH
	
	ORG	0023H			;Serial Port Interrupt
		LJMP SEND


	CSEG	at	0100h	;Start program above vectors.
		sjmp start		;but send PC over some interrupt functions
		
	SEND:				;Checks to see if program tripped RI unintentionally
		JNB RI, SERIAL	;If not, send it to Serial which handles TI
		CLR RI
		RETI
		
	SERIAL:			;Processes and sends the next output to Serial Port
					;In order and format: mm:ss:hh, counter 
	push ACC
	push PSW
	mov A, #07H
	lcall utlgll
	CLR TI
	MOV SBUF, A
	JNB TI, $
	CALL COLO
	CLR TI
	MOV A, #20H
	MOV SBUF, A
	JNB TI, $
	CLR TI
	MOV A, currComm
	MOV SBUF, A
	JNB TI, $
	CLR TI
	MOV A, #0DH
	MOV SBUF, A
	JNB TI, $
	CLR TI
	pop PSW
	pop ACC
	RETI

	COLO: CLR TI			;Used for the many ASCII colons in serial output
		push ACC
		MOV A, COLON
		MOV SBUF, A
		JNB TI, $
		pop ACC
		RET

	start:      	
		MOV SCON,	#0C0H	;Baud Rate Clock at 9-bit UART, with enabling TI.
		MOV TMOD,	#20H	;Setting Timer 2 for baud rate
		MOV TH1,	#0FDH 	;Init baud rate
		SETB ES				;Enabling interrupts
		SETB TI
		SETB TR1
		SETB EA
		lcall	trmclr		;Clear LCD.
		lcall	trmpsi		;Message on LCD.
		db	0				;Top line.
		db		'Trilobot'
		db	0
		lcall	trmpsi		;Message on LCD.
		db	40h				;Bottom line.
		db		'a3.a51'
		db	0
		
		mov A, 	#0FFH		;Enable all whiskers
		lcall 	utlgoa
		mov	A, 	#1			;Wait 1 sec
		lcall	utlwas
		mov A, 	#'A'			;init movement
		
	
		;jump if movement is not complete, or if there's no new movement	
	
	;start of detection loop
	loop: 	push ACC						;since whisker method uses A, protect it
			lcall utlgw
			jnz collision					;if any of A is set, means whisker has been hit
			pop ACC
			
	;Detecting the end of a movement
			cjne	A, #'A', sameState
	
		;jumps if there's nothing in the stack
	jnb		staflag, sameState
	
		;if there's something in the stack and movement is complete, deal with it
	stack: 	pop 	temp
			mov A,	temp
		
	for8:	cjne	A, #'8', back2		;input 8 makes the robot go forward 3 inches
			call	mov8				;push the location of command unto the stack
			;setb 	staflag
			sjmp	doneMove
	back2: cjne A, #'2', left4
			call	mov2
			;setb 	staflag
			sjmp	doneMove
	left4: cjne A, #'4', right6
			call	mov4
			;setb 	staflag
			sjmp	doneMove
	right6: cjne A, #'6', left7
			call	mov6
			;setb 	staflag
			sjmp	doneMove
	left7: cjne A, #'7', right9
			call	mov7
			;setb 	staflag
			sjmp	doneMove
	right9: cjne A, #'9', stopall
			call	mov9
			;setb 	staflag
			sjmp	doneMove
	stopall: cjne A, #'5', undef
			call	stop
			;setb 	staflag
			sjmp	doneMove
	
		;Had to set this up because jumps were becoming out of range
	sameState: ajmp keyboard
		
		;invoked when a whisker is tweaked, overrides all move functions
	collision:	CPL A			;to invert which whiskers have been hit
				lcall 	utlgoa	;so that only whiskers that haven't been hit are enabled
				mov A, 	#'2'	;emulating a '2' press on the keypad
				call 	move	;doing the move
				mov A, 	#0FFH	;Hopefully obstacle is clear, enable all whiskers again
				lcall 	utlgoa	
				sjmp 	loop	;back to detect more collisions
				
		;Robot initializes move, go back to detecting keyboard input
	doneMove:	clr staflag
			clr A			;So that A may be set by the robot again
			sjmp keyboard
				
				
		;These locations are called when popped off the stack
		;They contain specific distance values that are used with
		;moving or rotating the robot. They call on other, more general methods
		;to actually move it.
	mov8: 	mov A, #40H
			call move
			ret
	mov2:	mov A, #60H
			call move
			ret
	mov4: 	mov A, #06H
			call move
			ret
	mov6: 	mov A, #26H
			call move
			ret
	mov7:	mov A, #02H
			call move
			ret
	mov9:	mov A, #22H
			call move
			ret
	stop:	mov	A, #0FFH     	;otherwise stop
			call move
			ret
			
	;General move method
	move: 	lcall	utlgoc
			mov currComm, A		;Displaying the current keypress
			ret
	
		;If program is here, it means something went boom
	undef: 	lcall	trmclr		;Clear LCD.
			lcall	trmpsi		;Message on LCD.
			db	0			;Top line.
			db	'I GO BOOM'
			db	0
			ret


	
	
	keyboard: lcall	utlwas    
		lcall	sioget          
		lcall	sioput        			;get command and echo 
		cjne	A, #'0', back			;if no input, go back to repitition loop
		
		;If program gets to this line, means that there was keyboard input
		;Need to detect input, and push value to stack
		setb	staflag
		push 	ACC
		CLR 	A
		ajmp 	back
		
		;Had to set this up since jumps were becomng out of range
	back:	mov currComm, A
		ajmp loop
			

	

	
		BSEG					;Area for the bit flags used in processing
		STAFLAG: DBIT 1			;Flag for detecting something in the stack

		
	;----------------------------------------------------------------------
		end
