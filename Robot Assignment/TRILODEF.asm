;------------------------------------------------------------------------------
;Name: trilodef.asm
;Description: Definitions for access to jump table and variables by user programs
;Programmer: Roger Arrick - Arrick Robotics (c)
;Language: ASM51
;Date: 9/16/98
;Edit: 3
;
;****** Version 2.1 of Trilobot System Software.
;
;Function:
;User should include this file into any 8051 ASM program that needs access
;to the Trilobot's routines via the Jump table at 8000H.
;Variable locations in memory are also listed.
;
;Modules used:
;none
;
;Revision History:
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;Jump table.   EPROM 8000h - 83FFh (1K)
;
;This table allows access to various public routines needed by
;external programs.  These locations will never change even if
;the routines themselves change.

;Routines do not destroy registers but will destroy flags (PSW)

;If not stated, routine receives nothing and returns nothing.
;Normally single bytes are passed to/from routine using the A register.
;Normally words are passed to/from routine using the DPTR register.
;Normally two seperate bytes are passed to/from routine using A and B registers.


	;SYS - System routines.

sysres		equ	8000h	;Reset vector.
				;Does not return.
syscv		equ	8003h	;Copy vectors from EEPROM into RAM 80 bytes.
syssd		equ	8006h	;Set defaults in EEPROM.
sysres4		equ	8009h	;Do mode, mode code in EEPROM .
				;Does not return.
sysestop	equ	800ch	;Emergency stop response.
				;Sound effect, display message,
				;reset coprocessors, resets system.
				;Does not return.
systw		equ	800fh	;Test whiskers and do fix sequence.
syshbi		equ	8012h	;Hearbeat Interrupt service routine.
				;Updates 1/20 second and second counter.
				;sysclkf,sysclk1,sysclk2,sysclk3.
				;Returns with an RETI.

	;Space here for 13 more Lcalls.

	;UTL - Utility routines.
	;Access to commonly used features.
utlwas		equ	803ch	;Wait seconds.
				;Receives A=# of seconds.
utlwam		equ	803fh	;Wait milliseconds.
				;Receives A=# of milliseconds.
utlltu		equ	8042h	;Lower to upper case, clears msb.
				;Receives A=character.
				;Returns A=new character.
utllaon		equ	8045h	;Laser on.
utllaoff	equ	8048h	;Laser off.
utlhlon		equ	804bh	;Headlight on.
utlhloff	equ	804eh	;Headlight off.
utlrlon		equ	8051h	;Red on.
utlrloff	equ	8054h	;Red off.
utlglon		equ	8057h	;Green on.
utlgloff	equ	805ah	;Green off.
utlpoon		equ	805dh	;Powerful output on.
utlpooff	equ	8060h	;Powerful output off.
utlgbv		equ	8063h	;Get battery voltage.
				;Returns A=volts, B=tenths.
utlgbs		equ	8066h	;Get battery status code.
				;Returns A= 1=ok 2=low
				;3=very low 4=too low.
				;Based on EEPROM settings.
utlgw		equ	8069h	;Get whisker status .
				;Returns A=8 whiskers where
				;each bit is a whisker, 1=on.
utlgc		equ	806ch	;Get compass heading code.
				;Returns A= 0=N 1=NE 2=E 3=SE
				;4=S 5=SW 6=W 7=NW.
utlgc1		equ	806fh	;Get compass heading in degrees.
				;Returns DPTR 0-359 degrees.
utlgi		equ	8072h	;Get tilt.
				;Returns A=bits are direction.
				;0=front 1=right 2=back 3=left.
utlgt		equ	8075h	;Get temp.
				;Returns A = degree F.
utlgd		equ	8078h	;Get dip switches.
				;Returns A = bits 0-3 = switch 1-4 1=on
utlrci		equ	807bh	;Initialize RC servos.
				;Sets travel limits to max, sets speed for
				;head and gripper, relax head and gripper.
				;Set motion on, set power on.
utlrc		equ	807eh	;Move RC servos.
				;Receives B=servo # (1-8)
				;A=position (1-254, 0=off).
utlrcr		equ	8081h	;Get 8 RC receiver channels.
				;Receives values in R0-R7.
utloff		equ	8084h	;Turns robot power off.
				;Obviously will NOT return anything!
utlrco		equ	8087h	;Reset coprocessors.
utlhead		equ	808ah	;Head movement utility.
				;Receives A=movement code.
				;0=relax, 1=straight, 2=up&middle,
				;3=down&middle, 4=15Dleft&level,
				;5=90Dfarleft&level, 6=15Dright&level,
				;7=90Dfarright&level, 8=YES motion,
				;9=NO motion 10=Scan slow 11=far left,
				;12=left 13=middle 14=right 15=far right
				;16=up, 17=level, 18=down.
utlgrip		equ	808dh	;Gripper movement utility.
				;Receives A=movement code.
				;0=relax 1=down&open 2=close&up 3=open,
				;4=close, 5=up, 6=down,
				;Returns A=gripper switch 1=on, 0=off.
utljoy		equ	8090h	;Get joystick values.
				;Returns X axis into DPH (0-99),
				;Y axis into DPL (0-99)
				;B.6=switch 1, B.7=switch 2,
				;B.0-B.2 = X position 0-7,
				;B.3-B.5 = Y position 0-7
utlson		equ	8093h	;Sonar scan.
				;Returns B=center distance in inches,
				;DPL=15 degrees left, DPH=15 degrees right.
utlpak		equ	8096h	;"Press any key" LCD message and key wait.
				;Does NOT return key.

utlgo		equ	8099h	;Drive motor control.
				;Starts motion and returns.
				;Receives A=speed(0-4), B=turn ratio code, 
				;DPTR=distance in encoder counts (4/inch).

utlgoi		equ	809ch	;Intelligent drive motor control.
				;Sets auto stop on, starts move,
				;waits untill done.
				;Receives A=whisker mask DPTR=distance
				;B=turn ratio code. Speed from EEPROM.
				;Returns distance moved in DPTR.

	;Space here for 1 more Lcalls.

utlgow		equ	80a2h	;Wait until current drive motion done.

utlgoa		equ	80a5h	;Set auto stop on whisker.
				;Receives A=whisker mask, bits=whiskers.
				;1=active, 0=ignore.
utlgod		equ	80a8h	;Get drive motor distance.
				;Returns current distance in DPTR.
utlgos		equ	80abh	;Get drive motor speed.
				;Returns current motor speed in A.
utlgor		equ	80aeh	;Rotate right.
				;Receives A=# of degrees/2.
utlgol		equ	80b1h	;Rotate left.
				;Receives A=# of degrees/2.
utlgoh		equ	80b4h	;Rotate to a specific compass heading.
				;Receives A=heading in degrees/2. 0=north.
utlgoc		equ	80b7h	;Drive motor control via code.
				;Receives A=code.
				;(see PN command in user guide).
utlgog		equ	80bah	;Get desired motor speed from EEPROM.
				;Returns speed in A.
utlgll		equ	80bdh	;Get light levels.
				;Receives A=light sensor 0=front, 1=right,
				;2=left, 3=right.
				;Returns A=light level.
utlgh2o		equ	80c0h	;Get water sensor.
				;Returns A= 1=yes, 0=no.
utlgpir		equ	80c3h	;Get PIR sensor.
				;Returns A= 1=yes, 0=no.
utlgv		equ	80c6h	;Get software version.
				;Receives A=code, 1=system software,
				;2=coprocessor #1, 3=co#2.
				;Returns DPH=version # left of'.' ,
				;DPL=version # right of '.'.
utlgz		equ	80c9h	;Get hardware byte.
				;Receives A=code, 1=RAM,2=EEPROM,3=IDATA
				;4=EPROM, 5=CPU port #1, 6=CPU port #3.
				;DPTR=address.
				;Returns A=data byte.
utlgu		equ	80cch	;Get user port, digital and analog.
				;Receives A=1=digital, 2=analog.
				;Returns A=byte.
utlse		equ	80cfh	;Set E-stop.
				;Receives A=1=on, 2=off.
			
utlpu		equ	80d2h	;Put user port.
				;Receives A=bit #(0-7),
				;B=bit value (0 or 1).

	;Space here for 9 more Lcalls.

	;SIO - Serial I/O routines.
	;Main serial port.  Interrupt driven with send and recv buffers.
sioint		equ	80f0h	;Initialize serial I/O. (internal UART)
				;Clears buffers, etc. Baud from EEPROM
sioisr		equ	80f3h	;Interrupt service routine.
				;Handles serial I/O interrupts and
				;buffers. Returns with an RETI.
sioget		equ	80f6h	;Get character after waiting for it.
				;Returns A=character.
sioput		equ	80f9h	;Put character.
				;Receives A=character.
siogs		equ	80fch	;Get receive status.
				;Returns character IF available into A.
				;C=0=empty, C=1=got a character.
siops		equ	80ffh	;Put with status return.
				;Receives A=character to put.
				;C=0=buffer full, C=1=sent it
siopcl		equ	8102h	;Put CRLF.
siopst		equ	8105h	;Put string at DPTR.
				;Receives DPTR=address in code space.
				;String ends with 0.
siopsi		equ	8108h	;Put string immediately after call.
				;String ends with 0.
siopss		equ	810bh	;Put string from EEPROM.
				;Receives DPTR=address in EEPROM.
siocgb		equ	810eh	;Clear get buffer.
siocpb		equ	8111h	;Clear put buffer.
siogrs		equ	8114h	;Get status of RX buffer.
				;Returns A=# of bytes in RX buffer.
siogts		equ	8117h	;Get status of TX buffer.
				;Returns A=# of bytes in TX buffer.
siopcr		equ	811ah	;Put character repeatedly.
				;Receives A=character B=quantity.
sioghb		equ	811dh	;Get hex byte as 2 ascii characters.
				;Returns A=byte.
siophb		equ	8120h	;Put hex byte.
				;Receives A=byte.
sioghw		equ	8123h	;Get hex word as 4 ascii characters.
				;Returns DPTR=word.
siophw		equ	8126h	;Put hex word.
				;Receives DPTR=word.
siogdb		equ	8129h	;Get decimal byte
				;Returns A=byte.
siopdb		equ	812ch	;Put decimal.
				;Receives A=byte.
siogdw		equ	812fh	;Get decimal word.
				;Returns DPTR=word.
siopdw		equ	8132h	;Put decimal word.
				;Receives DPTR=word.
siopbb		equ	8135h	;Put binary byte.
				;Receives A=byte.

	;Space here for 6 more Lcalls.

	;SIA - Serial I/O Aux port (bit bang).
	;Normally used for speech synthesizer.
siaint		equ	814ah	;Initialize.
				;Baud in EEPROM.
siaget		equ	814dh	;Get character after waiting.
				;Returns A=character.
siaput		equ	8150h	;Put character after waiting.
				;Receives A=character.
siapst		equ	8153h	;Put string from code area.
				;Receives DPTR=address in code area.
				;String ends with 0.
siapsi		equ	8156h	;Put string immediately after call.
				;String ends with 0.
siapss		equ	8159h	;Put string from EEPROM.
				;Receives DPTR=address in EEPROM.

	;Space here for 14 more Lcalls.

	;SIB - Serial I/O coprocessor network port (bit bang)
	;These routines are not normally used by the programmer since
	;they deal with undocumented coprocessor commands, etc.
	;Access coprocessors using UTL calls.
sibint		equ	8186h	;Initialize.
				;Baud in EEPROM.
sibget		equ	8189h	;Get character after waiting.
				;Returns A=character.
sibput		equ	818ch	;Put character after waiting.
				;Receives A=character.
sibpst		equ	818fh	;Put string from code area.
				;Receives DPTR=address in code area.
				;String ends with 0.
sibpsi		equ	8192h	;Put string immediately after call.
				;String ends with 0.
sibghb		equ	8195h	;Get hex byte as 2 ascii characters.
				;Returns A=byte.
sibphb		equ	8198h	;Put hex byte as 2 ascii characters.
				;Receives A=byte.
sibghw		equ	819bh	;Get hex word as 4 ascii characters.
				;Returns DPTR=word.
sibphw		equ	819eh	;Put hex word as 4 ascii characters.
				;Receives DPTR=word.

	;Space here for 11 more Lcalls.

	;SEE - Serial EEPROM routines (EEPROM)
seeint		equ	81c2h	;Initialize.
seeins		equ	81c5h	;Installed?
				;Returns A= 0=no, A=1=yes.
seetst		equ	81c8h	;Test.
				;Returns A= 0=bad/not installed,
				;1=128, 2=256, 4=512, 8=1k, 16=2k.
seeget		equ	81cbh	;Get a byte.
				;Receives DPTR=address.
				;Returns A=byte.
seeput		equ	81ceh	;Put a byte.
				;Receives DPTR=address, A=byte.

	;Space here for 15 more Lcalls.

	;IHF - Intel hex file routines.
ihfget		equ	81e0h	;Get an Intel hex file into RAM.
				;Returns C= 1=success, 0=failed.
ihfasc		equ	81e3h	;Get after first colon into RAM
				;Returns C= 1=success, 0=failed.
ihfput		equ	81e6h	;Put an Intel hex file from RAM.
				;Receives r1:r0 = start address in ram,
				;r3:r2 = end address in ram.
				;r5:r4 = desired output address.
	;Space here for 2 more Lcalls.

	;ATD - Analog to digital input routines.
atdint		equ	81efh	;Initialize.
atdget		equ	81f2h	;Get value with filtering. (use this).
				;Receives A=channel # (0-15).
				;Returns A=value.
atdgsv		equ	81f5h	;Get a single value. (not normally needed).
				;Receives A=channel # (0-15).
				;Returns A=value.
	;Space here for 2 more Lcalls.

	;SON - Sonar range finding.
	;Sonar range finding is sometimes affected by airflow and noise.
sonint		equ	81feh	;Initialize.
songet		equ	8201h	;Get distance.
				;Returns A=inches, B=20ths of an inch.
songdc		equ	8204h	;Get dual distance.
				;Returns A=first echo in inches.
				;B=second echo in inches.
				;Space here for 2 more Lcalls.

	;SND - Sound routines.
	;Uses speaker to create sounds and PWM speech and mic input.
	;PWM speech are words stored in the bottom 32k of code space.
	;Speech synthesizer is controlled through the aux serial port (sia).
sndint		equ	820dh	;Initialize.
sndget		equ	8210h	;Get an audio into RAM.
				;Receives DPTR=start addr, A:B=stop addr.
sndput		equ	8213h	;Put sound, tones, etc.
				;Uses PWM or synthesizer depending on EEPROM.
				;Receives A=sound code. See PS command.
sndgl		equ	8216h	;Get sound level
				;Returns A=level (0-7).
sndpt		equ	8219h	;Put tone.
				;Receives A=freq (delay in us between cyc),
				;1=100us=10khz  250=25000us=40hz.
				;B=duration (# of cycles).
	;Space here for 5 more Lcalls.

	;CMD - Command mode processor.
cmd		equ	822bh	;Start command mode.
cmd0		equ	822eh	;Start without LCD message, beeps.
cmd1		equ	8231h	;Jump point when receive ! from SIO module.

	;Space here for 2 more Lcalls.
	
	;TRM - Terminal control (LCD & Keypad).
	;Controls a 16 character x 2 line LCD and a 16 key keypad.
	;Keys are 0-9, up arrow, down arrow, left, right, Y, N.
	;Keyclick sound are set in EEPROM.
trmint		equ	823ah	;Initialize the LCD and keypad.
trmmnu		equ	823dh	;Menu system.
				;Menus are displayed on the LCD and user
				;selects items with keypad.
				;Select menu item using 'Y', Up=previous,
				;Down=next, ignore others.
				;Selecting menu items can cause other menus
				;to display or calls to code.
				;Call with DPTR pointing to menu table in
				;code space.
				;Routines to be called should end with an
				;"RET" to return to menu.
				;
				;Menu table format:
				; 16 characters for top line title.
				; Each menu item contains:
				; 16 characters of text describing item
				; The next byte is an action code -
				;    1=next word is an address for a menu
				;      table to do if selected.
				;    2=next word is an address to LCALL to
				;      if selected.
				;    3=ignore next word, RET to program that
				;      called trmmnu.
				; The next word is an address to jump to or
				; another menu table address.
				; 0=end of table.
				;
				;Example menu table:
				;
				;trmmnut:;	str	'Select item:    '
				;	str	'Go to main menu '
				;	;1=next word is menu address.
				;	db	1
				;	dw	menumain
				;	str	'joystick control'
				;	;2=next word is jump address
				;	db	2
				;	dw	joyctrl
				;	;End of table.
				;	db	0
				;----------------------------------------------

trmmsg		equ	8240h	;Display message utility with delays.
				;Receives A=delay between screens in sec.
				;DPTR=address in code area of message.
				;Each line must be 16 characters.
				;0= end of table.
				;Sample table:
				;
				;samptbl:	str	'topline message '
				;	str	'bottom line     '
				;	str	'another top line'
				;	str	'2nd bottom line '
				;	db	0
				;----------------------------------------------
			
trmwas		equ	8243h	;Wait seconds and finish if keypressed.
				;Receives A=# of seconds.
				;Returns C= 1=keypressed, 0=not.
trmget		equ	8246h	;Get keypress with wait, echo 0-9,N,Y. click.
				;Returns A=character.

trmgs		equ	8249h	;Get keypad status,
				;No wait, echo to LCD(except arrows), click.
				;Returns C= 1=keypressed, A=0-9,Y,N,U,D,L,R.
trmgk		equ	824ch	;Get keycode only, no echo, no click, no wait.
				;Returns C=1=keypressed, A=keycode 0-15

trmgq		equ	824fh	;Get quick keypad status.
				;Returns C=1=keypressed. No character.

trmgh		equ	8252h	;Get keypress as a hex character 0-F,
				;echo and keyclick.
				;Returns A=00-0F.
trmghb		equ	8255h	;Get hex byte as 2 digits.
				;Returns A=hex byte.
trmghw		equ	8258h	;Get hex word as 4 digits..
				;Returns DPTR=word.
trmgdb		equ	825bh	;Get decimal byte as 1-3 digits.
				;Returns A=byte.
trmgdw		equ	825eh	;Get decimal word as 1-5 digits.
				;Returns DPTR=word.
trmput		equ	8261h	;Put character to LCD at current position.
trmclr		equ	8264h	;Clear LCD and set cursor to top left.
trmclrt		equ	8267h	;Clear LCD top line.
trmclrb		equ	826ah	;Clear LCD bottom line.
trmcur		equ	826dh	;Move LCD cursor to location
				;Receives A=location.
				;00=first line, 40h=second line.
trmpsi		equ	8270h	;Put string to LCD following call.
				;First byte of string is control code
				;0-79 = move cursor position to 0-79.
				;80 = print in current location.
				;81 = clr screen then print string.
				;String ends with 0.
trmpst		equ	8273h	;Put string to LCD from code space
				;Receives DPTR=address.
				;String ends with 0.
trmpbb		equ	8276h	;Put binary byte to LCD. 8 digits.
				;Receives A=byte.
trmpbw		equ	8279h	;Put binary word to LCD. 16 digits.
				;Receives DPTR=word.
trmphb		equ	827ch	;Put hex byte to LCD. 2 digits.
				;Receives A=byte.
trmphw		equ	827fh	;Put hex word to LCD. 4 digits.
				;Receives DPTR=word.
trmpdb		equ	8282h	;Put decimal byte to LCD. 1-3 digits.
				;Receives A=byte.
trmpdw		equ	8285h	;Put decimal word to LCD. 1-5 digits.
				;Receives DPTR=word.

	;Space here for 4 more Lcalls.

	;BAS - Basic interpreter.

	;Space here for 30 more Lcalls.

	;IRC - Infrared Communications.
	;Should start at 82EEh
	;Uses RC5 infrared codes used by many remote controls.
	;RC5 codes are 11 bits (5=device select, 6=action code).
	;High light levels will constantly cause interrupts.
	;User is responsable for enabling external interrupt #1
	;to allow receive when/if needed.
	;A translation table is used to convert the RC5 codes into
	;ascii characters.  P=play, R=record, etc.
	;If interrupts are not enabled, the user can receive using the
	;ircgc routine then translating it using irccta.
	;If interrupts are enabled, received code will be placed in
	;buffer which can then be read using ircgs or ircget.
	
ircint		equ	82eeh	;Initializes interrupt and variables.
				;User must turn on int. (setb ex1).
ircisr		equ	82f1h	;Interrupt service routine.
				;Translates received RC5 to character
				;and stuffs in buffer.
				;Returns with RETI.
ircldt		equ	82f4h	;Loads default translation table into RAM.
ircpbc		equ	82f7h	;Transmit RC5 code.
				;Receives DPTR=RC5 code.
				;(DPH=5 bit addr, DPL=6 bit code.
ircput		equ	82fah	;Translates character to RC5 then sends.
				;Receives DPTR=RC5 code.
ircgs		equ	82fdh	;Gets character from receive buffer.
				;Interrupt ex1 must be on to receive here.
				;Returns A=translated char, C=1=received.
ircget		equ	8300h	;Waits for character (same as ircgs).
				;Returns A=character.
ircgc		equ	8303h	;Gets RC5 code.
				;Returns DPTR=RC5 code, C=1=got one.
irccta		equ	8306h	;Translate RC5 code to character.
				;Receives DPTR=RC5 code.
				;Returns A=translated code.
ircatc		equ	8309h	;Translate character to RC5 code.
				;Receives A=character.
				;Returns DPTR=RC5 code. C=1=succeeded.

	;Space here for 10 more Lcalls.

;------------------------------------------------------------------------------
;End of Jump table.
;------------------------------------------------------------------------------




;------------------------------------------------------------------------------
;Memory usage.
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;Constants:
memode	bit	p1.0	;Memory mode, 1=norm, 0=RAM in code area.
estop		bit	21h.3	;Emergency stop flag. 1=active,0=not.
				;Causes Red shoulder button to be E-stop.
dio0		equ	8000h	;I/O port - dip switches, keypad, analog mux
dio1		equ	8001h	;I/O port - Sonar, LCD, buttons, water, PIR, etc.
dio2		equ	8002h	;I/O port - Grip sw, LEDs, laser, light, etc.
;
;------------------------------------------------------------------------------
;Internal RAM (IDATA), 256 bytes total at 00h-ffh
dior0		equ	3eh	;Storage for non-readable output port dio0.
dior1		equ	3fh	;Storage for non-readable output port dio1.
dior2		equ	40h	;Storage for non-readable output port dio2.
sysclkf		equ	41h	;fractional seconds. # of 1/20th seconds (0-19)
sysclk1		equ	42h	;# of seconds since power on. Low byte.
sysclk2		equ	43h	;middle byte.
sysclk3		equ	44h	;high byte.
;
;Reserved locations used for system programs 20h-22h, 30h-4fh.
;Stack is set to 50h and grows upwards.
;
;------------------------------------------------------------------------------
;External RAM usage (Data space), 32k total at 0000h-7fffh.
;0000-0079 for interrupt vectors.
;0100-7bff user programs
;7c00-7cff IRC translation table
;7d00-7dff IRC rx buffer
;7e00-7eff SIO rx buffer
;7f00-7fff SIO tx buffer
;8000-8002 I/O ports.  (use jump table routines to access).
;
;RAM is battery backed up.
;
;------------------------------------------------------------------------------
;EPROM usage (Code space). 64K total at 0000h - ffffh.
;0000-0079 for interrupt vectors.
;0080-7fff PWM speech data, can be used by user programs
;8000-83ff Jump table
;8400-ffff System program
;
;Note about RAM and EPROM control using MEMODE.
;A control bit named MEMODE is used to place RAM into code space so a program
;in RAM can be executed.  Upon reset, MEMODE is 1 which causes all 64k of EPROM
;to reside in code space, and 32k of RAM to reside at 0000-7fff in data space.
;When MEMODE is 0, the 32k of RAM also appears in the bottom half of code space
;in addition to it's data space location.  Remember that interrupt vectors are
;the bottom of EPROM and must first be copied to RAM before switching.  See
;the SYSCV routine.
;
;------------------------------------------------------------------------------
;EEPROM usage.  2k total at 0000h-07ffh.
;
;Addr(hex)	Use
;0	Controller ID for command mode
;1	Console baud rate, 0=300, 1=1200, 2=2400, 3=4800, 4=9600, 5=19200
;2	Aux serial port baud rate, 0=300, 1=1200, 2=2400, 3=4800, 4=9600, 5=19200
;3	Sound control.  0=off, 1=PWM speech, 2=Speech synthesizer.
;4
;5	Speech synthesizer voice #0-7 default=7
;6	Power up sound effect # (default 9)
;7	Keyclick sound effect # (default 11)
;8	Battery low threshold. (anything above this is OK)
;	value=(voltage/6)*50, voltage=value*6*.02
;	so, 108=13v 100=12v, 91-11v, 83=10v, 75-9v, 69=8v, 58=7v, 50=6v
;9	Battery Very low threshold (Time to panic)
;a	Battery too low threshold (not enough to do anything but die)
;b	Startup Mode
;	0=terminal mode. (default)
;	1=console command mode.
;	2=console menu mode.
;	3=joystick control mode.
;	4=RC receiver control mode.
;	5=IR control mode.
;	6=run from eprom at following address.
;	7=run from ram at following address.
;	8=line following mode.
;	9=TriloGuard mode.
;	10=Wander mode.
;	11=test mode.
;c	Run address high byte
;d	Run address low byte
;e	heartbeat interrupt 1=on, 0=off.
;f-13	Characters indicating uninitalized EEPROM. "12345" ascii string
;	Defaults put in EEPROM if that string not found here
;14-64	Power up speech string. 80 characters sent to aux serial port
;	Ending in 0.  Put 0 at location 20 for no output
;	Only sent if sound control=2
;65	Year built
;66	Month built
;67	Reset count high byte
;68	Reset count medium byte
;69	Reset count low byte
;6a	Password high byte
;6b	Password low byte
;6c	360 degree rotate distance 
;6d	Motor speed (default 3)
;6e	Head azimuth servo far left position 50
;6f	Head azimuth servo middle position 125
;70	Head azimuth servo far right position 200
;71	head alt servo far up position 100
;72	head alt servo middle (straight) position 125
;73	head alt servo far down position 150
;74	Head servo speeds
;75	Gripper servo full close position 100
;76	Gripper servo full open position 150
;77	Gripper servo full up position 100
;78	Gripper servo full down position 150
;79	Gripper servo speeds
;7a	Joystick X lower limit
;7b	Joystick X center
;7c	Joystick X high limit
;7d	Joystick Y lower limit
;7e	Joystick Y center
;7f	Joystick Y high limit
;
;Leave 0000h-03ffh of the EEPROM for system use.  Top 1k 0400h-07ffh for user.


;------------------------------------------------------------------------------
;End of trilodef.asm
;------------------------------------------------------------------------------

