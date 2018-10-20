global uint8 speicher(&hFFFF), rom_speicher(16000000), rom_ram_speicher(8000000)
global int32 mx,my,mz,mb,oldmz,scroll
global uint32 anzahl_rom_banks
global uint8 tasten(1)

'Adressen in 'speicher()'
const M_MBC=&h0147
const M_GBC=&h0143

const M_JOYP=&hFF00
const M_SB=&hFF01
const M_SC=&hFF02
const M_DIV=&hFF04
const M_TIMA=&hFF05
const M_TMA=&hFF06
const M_TAC=&hFF07
const M_INTERRUPT_FLAG=&hFF0F
const M_LCD_CONTROL=&hFF40
const M_LCD_STATUS=&hFF41
const M_SCROLLY=&hFF42
const M_SCROLLX=&hFF43
const M_SCANLINE=&hFF44	
const M_LYC=&hFF45
const M_DMA=&hFF46
const M_BGP=&hFF47
const M_OBP0=&hFF48
const M_OBP1=&hFF49
const M_WY=&hFF4A
const M_WX=&hFF4B
const M_INTERRUPT_ENABLE=&hFFFF

const M_VRAM=&h8000
const M_OAM=&hFE00

#define C_VBLANK	(1 shl 0)
#define C_LCDSTAT	(1 shl 1)
#define C_TIMER		(1 shl 2)
#define C_SERIAL	(1 shl 3)
#define C_JOYPAD	(1 shl 4)

union register
	uint16 x
	type
		uint8 low
		uint8 high
	end type
end union

class opcode
	varchar*16 nam
	uint8 laenge
	uint8 zeit
	as sub() execute
end class

#undef stop
global as register reg1, reg2, reg3, reg4, reg5, reg6
global as opcode op
global uint8 interrupts_master = 1, stop = 0

#define af reg1.x
#define a reg1.high
#define f reg1.low
#define bc reg2.x
#define b reg2.high
#define c reg2.low
#define de reg3.x
#define d reg3.high
#define e reg3.low
#define hl reg4.x
#define h reg4.high
#define l reg4.low
#define sp reg5.x
#define pc reg6.x
#define pch reg6.high
#define pcl reg6.low

global uint32 rom_bank, rom_ram_bank, rom_bank_modus, ram_an
declare function read_byte(adresse uint16) uint8

sub write_byte(adresse uint16, wert uint8)
	if adresse <= &h7FFF then

		schreibe_log("MBC: Schreiben bei 0x" + hex(adresse,4) + ": " + hex(wert,2))
	
		'Banknummer MOD 40, damit keine ungültigen Banken geladen werden können
	
		select case as const speicher(M_MBC)
			case &h01, &h02, &h03			'MBC1
				MBC1()
			case &h19 to &h1E				'MBC5
				MBC5()
			case else						'Alles andere ist wahrscheinlich eine Variation von MBC1
				MBC1()
		end select
	elseif adresse >= &hA000 and adresse <= &hBFFF then	'ROM-RAM
		if ram_an = 1 then rom_ram_speicher(adresse - &hA000 + rom_ram_bank * &h2000) = wert
	elseif adresse=M_DMA then
		for i in(0,&h9F) 
			speicher(&hFE00 + i) = read_byte((wert shl 8) + i) 'speicher(wert+i)
		next
		schreibe_log("DMA von 0x" + hex(wert,2) + "00")
	elseif adresse = M_DIV then speicher(M_DIV) = &h00
	elseif adresse = M_SCANLINE then speicher(M_SCANLINE) = &h00
	else
		speicher(adresse) = wert
		select case as const adresse
			case M_TAC
				if (wert and &h04) = 0 then : schreibe_log("[TAC] Timer aus")
				elseif (wert and &h04) > 0 then : schreibe_log("[TAC] Timer an")
				end if
			case M_INTERRUPT_ENABLE
				if (wert and &h01) = 0 then schreibe_log("[IE] V-Blank aus")
				if (wert and &h02) = 0 then schreibe_log("[IE] LCD-STAT aus")
				if (wert and &h04) = 0 then schreibe_log("[IE] Timer aus")
				if (wert and &h08) = 0 then schreibe_log("[IE] Serial aus")
				if (wert and &h10) = 0 then schreibe_log("[IE] Joypad aus")
				
				if (wert and &h01) > 0 then schreibe_log("[IE] V-Blank an")
				if (wert and &h02) > 0 then schreibe_log("[IE] LCD-STAT an")
				if (wert and &h04) > 0 then schreibe_log("[IE] Timer an")
				if (wert and &h08) > 0 then schreibe_log("[IE] Serial an")
				if (wert and &h10) > 0 then schreibe_log("[IE] Joypad an")
			case M_LCD_CONTROL
				if (wert and &h80) = 0 then schreibe_log("[LCD] LCD aus")
				if (wert and &h80) > 0 then schreibe_log("[LCD] LCD an")
		end select
	end if
end sub

sub write_word(adresse uint16, wert uint16)
	write_byte(adresse,wert)
	write_byte(adresse + 1,(wert shr 8))
end sub

function read_byte(adresse uint16) uint8
	if adresse = M_JOYP then
		select case as const speicher(M_JOYP) and &h30
			case 16 : return tasten(0)
			case 32 : return tasten(1)
		end select
	elseif adresse >= &hA000 and adresse <= &hBFFF then	'ROM RAM
		if speicher(M_MBC) = &h00 then return speicher(adresse)
		if ram_an = 1 then 
			return rom_ram_speicher(adresse - &hA000 + rom_ram_bank * &h2000)
		else
			return &hFF
		end if
	else
		return speicher(adresse)
	end if
end function

function read_word(adresse uint16) uint16
	return read_byte(adresse) + (read_byte(adresse+1) shl 8)
end function

global int32 zeit
#include once "befehle.bas"

'NAME			 	 L   T  SUB
global as opcode opcodes(&hFF) => { _ 
("NOP             ", 0,  1, @NOP		) , _	'00
("MOV %1, BC      ", 2,  3, @MOV_I16_BC	) , _	'01
("MOV A, (BC)     ", 0,  2, @MOV_A_pBC) , _		'02
("INC BC          ", 0,  2, @INC_BC) , _		'03
("INC B           ", 0,  1, @INC_B) , _			'04
("DEC B           ", 0,  1, @DEC_B) , _			'05
("MOV %0, B       ", 1,  2, @MOV_I8_B) , _		'06
("RCL A           ", 0,  1, @RCL_A) , _			'07
("MOV SP, (%1)    ", 2,  5, @MOV_SP_A16) , _	'08
("ADD BC, HL      ", 0,  2, @ADD_BC_HL) , _		'09
("MOV (BC), A     ", 0,  2, @MOV_pBC_A) , _		'0A
("DEC BC          ", 0,  2, @DEC_BC) , _		'0B
("INC C           ", 0,  1, @INC_C) , _			'0C
("DEC C           ", 0,  1, @DEC_C) , _			'0D
("MOV %0, C       ", 1,  2, @MOV_I8_C) , _		'0E
("RCR A           ", 0,  1, @RCR_A) , _			'0F
_
("STOP            ", 1,  0, 0) , _				'10
("MOV %1, DE      ", 2,  3, @MOV_I16_DE) , _	'11
("MOV A, (DE)     ", 0,  2, @MOV_A_pDE) , _		'12
("INC DE          ", 0,  2, @INC_DE) , _		'13
("INC D           ", 0,  1, @INC_D) , _			'14
("DEC D           ", 0,  1, @DEC_D) , _			'15
("MOV %0, D       ", 1,  2, @MOV_I8_D) , _		'4,
("ROL A           ", 0,  1, @ROL_A) , _			'17
("JMP %0          ", 1,  3, @JMP_R8) , _		'18
("ADD DE, HL      ", 0,  2, @ADD_DE_HL) , _		'19
("MOV (DE), A     ", 0,  2, @MOV_pDE_A) , _		'1A
("DEC DE          ", 0,  2, @DEC_DE) , _		'1B
("INC E           ", 0,  1, @INC_E) , _			'1C
("DEC E           ", 0,  1, @DEC_E) , _			'1D
("MOV %0, E       ", 1,  2, @MOV_I8_E) , _		'1E
("ROR A           ", 0,  1, @ROR_A) , _			'1F
_
("JNZ %0          ", 1,  0, @JNZ_R8) , _		'20
("MOV %1, HL      ", 2,  3, @MOV_I16_HL) , _	'21
("MOV A, (HL+)    ", 0,  2, @MOV_A_HLA) , _		'22
("INC HL          ", 0,  2, @INC_HL) , _		'23
("INC H           ", 0,  1, @INC_H) , _			'24
("DEC H           ", 0,  1, @DEC_H) , _			'25
("MOV %0, H       ", 1,  2, @MOV_I8_H) , _		'26
("DAA             ", 0,  1, @DAA) , _			'27
("JZ %0           ", 1,  0, @JZ_R8) , _			'28
("ADD HL, HL      ", 0,  2, @ADD_HL_HL) , _		'29
("MOV (HL+), A    ", 0,  2, @MOV_HLA_A) , _		'2A
("DEC HL          ", 0,  2, @DEC_HL) , _		'2B
("INC L           ", 0,  1, @INC_L) , _			'2C
("DEC L           ", 0,  1, @DEC_L) , _			'2D
("MOV %0, L       ", 1,  2, @MOV_I8_L) , _		'2E
("CPL             ", 0,  1, @CPL) , _			'2F
_
("JNC %0          ", 1,  0, @JNC_R8) , _		'30
("MOV %1, SP      ", 2,  3, @MOV_I16_SP ) , _	'31
("MOV A, (HL-)    ", 0,  2, @MOV_A_HLS) , _		'32
("INC SP          ", 0,  2, @INC_SP) , _		'33
("INC (HL)        ", 0,  3, @INC_pHL) , _		'34
("DEC (HL)        ", 0,  3, @DEC_pHL) , _		'35
("MOV %0, (HL)    ", 1,  3, @MOV_I8_pHL) , _	'36
("SCF             ", 0,  1, @SCF) , _			'37
("JC %0           ", 1,  0, @JC_R8) , _			'38
("ADD SP, HL      ", 0,  2, @ADD_SP_HL) , _		'39
("MOV (HL-), A    ", 0,  2, @MOV_HLS_A) , _		'3A
("DEC SP          ", 0,  2, @DEC_SP) , _		'3B
("INC A           ", 0,  1, @INC_A) , _			'3C
("DEC A           ", 0,  1, @DEC_A) , _			'3D
("MOV %0, A       ", 1,  2, @MOV_I8_A) , _		'3E
("CCF             ", 0,  1, @CCF) , _			'3F
_
("MOV B,B         ", 0,  1, @MOV_B_B) , _		'40
("MOV C,B         ", 0,  1, @MOV_C_B) , _		'41
("MOV D,B         ", 0,  1, @MOV_D_B) , _		'42
("MOV E,B         ", 0,  1, @MOV_E_B) , _		'43
("MOV H,B         ", 0,  1, @MOV_H_B) , _		'44
("MOV L,B         ", 0,  1, @MOV_L_B) , _		'45
("MOV (HL),B      ", 0,  2, @MOV_pHL_B) , _		'46
("MOV A,B         ", 0,  1, @MOV_A_B) , _		'47
("MOV B,C         ", 0,  1, @MOV_B_C) , _		'48
("MOV C,C         ", 0,  1, @MOV_C_C) , _		'49
("MOV D,C         ", 0,  1, @MOV_D_C) , _		'4A
("MOV E,C         ", 0,  1, @MOV_E_C) , _		'4B
("MOV H,C         ", 0,  1, @MOV_H_C) , _		'4C
("MOV L,C         ", 0,  1, @MOV_L_C) , _		'4D
("MOV (HL),C      ", 0,  2, @MOV_pHL_C) , _		'4E
("MOV A,C         ", 0,  1, @MOV_A_C) , _		'4F
_
("MOV B,D         ", 0,  1, @MOV_B_D) , _		'50
("MOV C,D         ", 0,  1, @MOV_C_D) , _		'51
("MOV D,D         ", 0,  1, @MOV_D_D) , _		'52
("MOV E,D         ", 0,  1, @MOV_E_D) , _		'53
("MOV H,D         ", 0,  1, @MOV_H_D) , _		'54
("MOV L,D         ", 0,  1, @MOV_L_D) , _		'55
("MOV (HL),D      ", 0,  2, @MOV_pHL_D) , _		'56
("MOV A,D         ", 0,  1, @MOV_A_D) , _		'57
("MOV B,E         ", 0,  1, @MOV_B_E) , _		'58
("MOV C,E         ", 0,  1, @MOV_C_E) , _		'59
("MOV D,E         ", 0,  1, @MOV_D_E) , _		'5A
("MOV E,E         ", 0,  1, @MOV_E_E) , _		'5B
("MOV H,E         ", 0,  1, @MOV_H_E) , _		'5C
("MOV L,E         ", 0,  1, @MOV_L_E) , _		'5D
("MOV (HL),E      ", 0,  2, @MOV_pHL_E) , _		'5E
("MOV A,E         ", 0,  1, @MOV_A_E) , _		'5F
_
("MOV B,H         ", 0,  1, @MOV_B_H) , _		'60
("MOV C,H         ", 0,  1, @MOV_C_H) , _		'61
("MOV D,H         ", 0,  1, @MOV_D_H) , _		'62
("MOV E,H         ", 0,  1, @MOV_E_H) , _		'63
("MOV H,H         ", 0,  1, @MOV_H_H) , _		'64
("MOV L,H         ", 0,  1, @MOV_L_H) , _		'65
("MOV (HL),H      ", 0,  2, @MOV_pHL_H) , _		'66
("MOV A,H         ", 0,  1, @MOV_A_H) , _		'67
("MOV B,L         ", 0,  1, @MOV_B_L) , _		'68
("MOV C,L         ", 0,  1, @MOV_C_L) , _		'69
("MOV D,L         ", 0,  1, @MOV_D_L) , _		'6A
("MOV E,L         ", 0,  1, @MOV_E_L) , _		'6B
("MOV H,L         ", 0,  1, @MOV_H_L) , _		'6C
("MOV L,L         ", 0,  1, @MOV_L_L) , _		'6D
("MOV (HL),L      ", 0,  2, @MOV_pHL_L) , _		'6E
("MOV A,L         ", 0,  1, @MOV_A_L) , _		'6F
_
("MOV B,(HL)      ", 0,  2, @MOV_B_pHL) , _		'70
("MOV C,(HL)      ", 0,  2, @MOV_C_pHL) , _		'71
("MOV D,(HL)      ", 0,  2, @MOV_D_pHL) , _		'72
("MOV E,(HL)      ", 0,  2, @MOV_E_pHL) , _		'73
("MOV H,(HL)      ", 0,  2, @MOV_H_pHL) , _		'74
("MOV L,(HL)      ", 0,  2, @MOV_L_pHL) , _		'75
("HALT            ", 0,  0, @HALT) , _			'76
("MOV A,(HL)      ", 0,  2, @MOV_A_pHL) , _		'77
("MOV B,A         ", 0,  1, @MOV_B_A) , _		'78
("MOV C,A         ", 0,  1, @MOV_C_A) , _		'79
("MOV D,A         ", 0,  1, @MOV_D_A) , _		'7A
("MOV E,A         ", 0,  1, @MOV_E_A) , _		'7B
("MOV H,A         ", 0,  1, @MOV_H_A) , _		'7C
("MOV L,A         ", 0,  1, @MOV_L_A) , _		'7D
("MOV (HL),A      ", 0,  2, @MOV_pHL_A) , _		'7E
("MOV A,A         ", 0,  1, @MOV_A_A) , _		'7F
_
("ADD B, A        ", 0,  1, @ADD_B_A) , _		'80
("ADD C, A        ", 0,  1, @ADD_C_A) , _		'81
("ADD D, A        ", 0,  1, @ADD_D_A) , _		'82
("ADD E, A        ", 0,  1, @ADD_E_A) , _		'83
("ADD H, A        ", 0,  1, @ADD_H_A) , _		'84
("ADD L, A        ", 0,  1, @ADD_L_A) , _		'85
("ADD (HL), A     ", 0,  2, @ADD_pHL_A) , _		'86
("ADD A, A        ", 0,  1, @ADD_A_A) , _		'87
("ADC B, A        ", 0,  1, @ADC_B_A) , _		'88
("ADC C, A        ", 0,  1, @ADC_C_A) , _		'89
("ADC D, A        ", 0,  1, @ADC_D_A) , _		'8A
("ADC E, A        ", 0,  1, @ADC_E_A) , _		'8B
("ADC H, A        ", 0,  1, @ADC_H_A) , _		'8C
("ADC L, A        ", 0,  1, @ADC_L_A) , _		'8D
("ADC (HL), A     ", 0,  2, @ADC_pHL_A) , _		'8E
("ADC A, A        ", 0,  1, @ADC_A_A) , _		'8F
_
("SUB B, A        ", 0,  1, @SUB_B_A) , _		'90
("SUB C, A        ", 0,  1, @SUB_C_A) , _		'91
("SUB D, A        ", 0,  1, @SUB_D_A) , _		'92
("SUB E, A        ", 0,  1, @SUB_E_A) , _		'93
("SUB H, A        ", 0,  1, @SUB_H_A) , _		'94
("SUB L, A        ", 0,  1, @SUB_L_A) , _		'95
("SUB (HL), A     ", 0,  2, @SUB_pHL_A) , _		'96
("SUB A, A        ", 0,  1, @SUB_A_A) , _		'97
("SBB B, A        ", 0,  1, @SBB_B_A) , _		'98
("SBB C, A        ", 0,  1, @SBB_C_A) , _		'99
("SBB D, A        ", 0,  1, @SBB_D_A) , _		'9A
("SBB E, A        ", 0,  1, @SBB_E_A) , _		'9B
("SBB H, A        ", 0,  1, @SBB_H_A) , _		'9C
("SBB L, A        ", 0,  1, @SBB_L_A) , _		'9D
("SBB (HL), A     ", 0,  2, @SBB_pHL_A) , _		'9E
("SBB A, A        ", 0,  1, @SBB_A_A) , _		'9F
_
("AND B, A        ", 0,  1, @AND_B_A) , _		'A0
("AND C, A        ", 0,  1, @AND_C_A) , _		'A1
("AND D, A        ", 0,  1, @AND_D_A) , _		'A2
("AND E, A        ", 0,  1, @AND_E_A) , _		'A3
("AND H, A        ", 0,  1, @AND_H_A) , _		'A4
("AND L, A        ", 0,  1, @AND_L_A) , _		'A5
("AND (HL), A     ", 0,  2, @AND_pHL_A) , _		'A6
("AND A, A        ", 0,  1, @AND_A_A) , _		'A7
("XOR B, A        ", 0,  1, @XOR_B_A) , _		'A8
("XOR C, A        ", 0,  1, @XOR_C_A) , _		'A9
("XOR D, A        ", 0,  1, @XOR_D_A) , _		'AA
("XOR E, A        ", 0,  1, @XOR_E_A) , _		'AB
("XOR H, A        ", 0,  1, @XOR_H_A) , _		'AC
("XOR L, A        ", 0,  1, @XOR_L_A) , _		'AD
("XOR (HL), A     ", 0,  2, @XOR_pHL_A) , _		'AE
("XOR A, A        ", 0,  1, @XOR_A_A) , _		'AF
_
("OR B, A         ", 0,  1, @OR_B_A) , _		'B0
("OR C, A         ", 0,  1, @OR_C_A) , _		'B1
("OR D, A         ", 0,  1, @OR_D_A) , _		'B2
("OR E, A         ", 0,  1, @OR_E_A) , _		'B3
("OR H, A         ", 0,  1, @OR_H_A) , _		'B4
("OR L, A         ", 0,  1, @OR_L_A) , _		'B5
("OR (HL), A      ", 0,  2, @OR_pHL_A) , _		'B6
("OR A, A         ", 0,  1, @OR_A_A) , _		'B7
("CMP B, A        ", 0,  1, @CMP_B_A) , _		'B8
("CMP C, A        ", 0,  1, @CMP_C_A) , _		'B9
("CMP D, A        ", 0,  1, @CMP_D_A) , _		'BA
("CMP E, A        ", 0,  1, @CMP_E_A) , _		'BB
("CMP H, A        ", 0,  1, @CMP_H_A) , _		'BC
("CMP L, A        ", 0,  1, @CMP_L_A) , _		'BD
("CMP (HL), A     ", 0,  2, @CMP_pHL_A) , _		'BE
("CMP A, A        ", 0,  1, @CMP_A_A) , _		'BF
_
("RET NZ          ", 0,  0, @RET_NZ) , _		'C0
("POP BC          ", 0,  3, @POP_BC) , _		'C1
("JNZ %1          ", 2,  0, @JNZ_A16) , _		'C2
("JMP %1          ", 2,  4, @JMP_A16) , _		'C3
("CALL NZ %1      ", 2,  0, @CALL_NZ_A16) , _	'C4
("PUSH BC         ", 0,  4, @PUSH_BC) , _		'C5
("ADD %0, A       ", 1,  2, @ADD_I8_A) , _		'C6
("RST 0x00        ", 0,  4, @RST_00) , _		'C7
("RET Z           ", 0,  0, @RET_Z) , _			'C8
("RET             ", 0,  4, @RET) , _			'C9
("JZ %1           ", 2,  0, @JZ_A16) , _		'CA
("CB-BIT          ", 1,  2, @CB_BIT_OPS) , _	'CB
("CALL Z %1       ", 2,  0, @CALL_Z_A16) , _	'CC
("CALL %1         ", 2,  6, @CALL_A16) , _		'CD
("ADC %0, A       ", 1,  2, @ADC_I8_A) , _		'CE
("RST 0x08        ", 0,  4, @RST_08) , _		'CF
_
("RET NC          ", 0,  0, @RET_NC) , _		'D0
("POP DE          ", 0,  3, @POP_DE) , _		'D1
("JNC %1          ", 2,  0, @JNC_A16) , _		'D2
("INVALID         ", 0,  0, 0) , _				'D3
("CALL NC %1      ", 2,  0, @CALL_NC_A16) , _	'D4
("PUSH DE         ", 0,  4, @PUSH_DE) , _		'D5
("SUB %0, A       ", 1,  2, @SUB_I8_A) , _		'D6
("RST 0x10        ", 0,  4, @RST_10) , _		'D7
("RET C           ", 0,  0, @RET_C) , _			'D8
("RETI            ", 0,  4, @RETI) , _			'D9
("JC %1           ", 2,  0, @JC_A16) , _		'DA
("INVALID         ", 0,  0, 0) , _				'DB
("CALL C %1       ", 2,  0, @CALL_C_A16) , _	'DC
("INVALID         ", 0,  0, 0) , _				'DD
("SBB %0, A       ", 1,  2, @SBB_I8_A) , _		'DE
("RST 0x18        ", 0,  4, @RST_18) , _		'DF
_
("MOV A, (0xFF+%0)", 1,  3, @MOV_A_A8) , _		'E0
("POP HL          ", 0,  3, @POP_HL) , _		'E1
("MOV A, (0xFF+C) ", 0,  2, @MOV_A_A8C) , _		'E2
("INVALID         ", 0,  0, 0) , _				'E3
("INVALID         ", 0,  0, 0) , _				'E4
("PUSH HL         ", 0,  4, @PUSH_HL) , _		'E5
("AND %0, A       ", 1,  2, @AND_I8_A) , _		'E6
("RST 0x20        ", 0,  4, @RST_20) , _		'E7
("ADD %0, SP      ", 1,  4, @ADD_I8_SP) , _		'E8
("JMP (HL)        ", 0,  1, @JMP_HL) , _		'E9
("MOV A, (%1)     ", 2,  4, @MOV_A_A16) , _		'EA
("INVALID         ", 0,  0, 0) , _				'EB
("INVALID         ", 0,  0, 0) , _				'EC
("INVALID         ", 0,  0, 0) , _				'ED
("XOR %0, A       ", 1,  2, @XOR_I8_A) , _		'EE
("RST 0x28        ", 0,  4, @RST_28) , _		'EF
_
("MOV (0xFF+%0), A", 1,  3, @MOV_A8_A) , _		'F0
("POP AF          ", 0,  3, @POP_AF) , _		'F1
("MOV (0xFF+C), A ", 0,  2, @MOV_A8C_A) , _		'F2
("DI              ", 0,  1, @DIS) , _			'F3
("INVALID         ", 0,  0, 0) , _				'F4
("PUSH AF         ", 0,  4, @PUSH_AF) , _		'F5
("OR %0, A        ", 1,  2, @OR_I8_A) , _		'F6
("RST 0x30        ", 0,  4, @RST_30) , _		'F7
("MOV SP+%0, HL   ", 1,  3, @MOV_SPI8_HL) , _	'F8
("MOV HL, SP      ", 0,  2, @MOV_HL_SP) , _		'F9
("MOV (%1), A     ", 2,  4, @MOV_A16_A) , _		'FA
("EI              ", 0,  1, @EIS) , _			'FB
("INVALID         ", 0,  0, 0) , _				'FC
("INVALID         ", 0,  0, 0) , _				'FD
("CMP %0, A       ", 1,  2, @CMP_I8_A) , _		'FE
("RST 0x38        ", 0,  4, @RST_38) _			'FF
}

#include once "gpu.bas"

sub cpu_start()
	af=&h01B0
	bc=&h0013
	de=&h00D8
	hl=&h014A
	sp=&hFFFE
	pc=&h0100
	
	interrupts_master=1
	stop=0
	zeit=0
	
	speicher(M_TIMA) = 				&h00
	speicher(M_TMA) =				&h00
	speicher(M_TAC) = 				&h00
	speicher(&hFF10) = &h80
	speicher(&hFF11) = &hBF
	speicher(&hFF12) = &hF3
	speicher(&hFF14) = &hBF
	speicher(&hFF16) = &h3F
	speicher(&hFF17) = &h00
	speicher(&hFF19) = &hBF
	speicher(&hFF1A) = &h7A
	speicher(&hFF1B) = &hFF
	speicher(&hFF1C) = &h9F
	speicher(&hFF1E) = &hBF
	speicher(&hFF20) = &hFF
	speicher(&hFF21) = &h00
	speicher(&hFF22) = &h00
	speicher(&hFF23) = &hBF
	speicher(&hFF24) = &h77
	speicher(&hFF25) = &hF3
	speicher(&hFF26) = &hF1
	speicher(M_LCD_CONTROL) = 		&h91
	speicher(M_SCROLLY) = 			&h00
	speicher(M_SCROLLX) = 			&h00
	speicher(M_LYC) = 				&h00
	speicher(M_BGP) =				&hFC
	speicher(M_OBP0) = 				&hFF
	speicher(M_OBP1) = 				&hFF
	speicher(M_WY) = 				&h00
	speicher(M_WX) = 				&h00
	speicher(M_INTERRUPT_ENABLE) = 	&h00
	
	tasten(0) = &h0F
	tasten(1) = &h0F
end sub

sub cpu()
	if stop = 1 then exit sub
	op = opcodes(speicher(pc))

	pc += 1
	zeit = op.zeit
	if op.execute <> 0 then
		op.execute()
		pc += op.laenge
	else
		if speicher(pc-1)=&h10 then
			schreibe_log("[WARNUNG] OP: 0x10 'STOP'")
		else
			schreibe_log("[FEHLER] Unbekannter OP: 0x"+hex(speicher(pc-1),2))
		end if
	end if
	if zeit = 0 then zeit = 1
end sub

sub interrupts()
	if interrupts_master = 1 then
		stop = 0
		if (speicher(M_INTERRUPT_FLAG) and C_VBLANK) > 0 and (speicher(M_INTERRUPT_ENABLE) and C_VBLANK) > 0 then
			interrupts_master = 0
			speicher(M_INTERRUPT_FLAG) -= C_VBLANK
			zeit = 5
			sp -= 2 : write_word(sp,pc) : pc = &h40
		elseif (speicher(M_INTERRUPT_FLAG) and C_LCDSTAT) > 0 and (speicher(M_INTERRUPT_ENABLE) and C_LCDSTAT) > 0 then
			interrupts_master = 0
			speicher(M_INTERRUPT_FLAG) -= C_LCDSTAT
			zeit = 5
			sp -= 2 : write_word(sp,pc) : pc = &h48
		elseif (speicher(M_INTERRUPT_FLAG) and C_TIMER) > 0 and (speicher(M_INTERRUPT_ENABLE) and C_TIMER) > 0 then
			interrupts_master = 0
			speicher(M_INTERRUPT_FLAG) -= C_TIMER
			zeit = 5
			sp -= 2 : write_word(sp,pc) : pc = &h50
		elseif (speicher(M_INTERRUPT_FLAG) and C_SERIAL) > 0 and (speicher(M_INTERRUPT_ENABLE) and C_SERIAL) > 0 then
			interrupts_master = 0
			speicher(M_INTERRUPT_FLAG) -= C_SERIAL
			zeit = 5
			sp -= 2 : write_word(sp,pc) : pc = &h58
		elseif (speicher(M_INTERRUPT_FLAG) and C_JOYPAD) > 0 and (speicher(M_INTERRUPT_ENABLE) and C_JOYPAD) > 0 then
			interrupts_master = 0
			speicher(M_INTERRUPT_FLAG) -= C_JOYPAD
			zeit = 5
			sp -= 2 : write_word(sp,pc) : pc = &h60
		end if
	end if
end sub

sub timers()
	static int32 timer_zeit, timer_zeit2
	timer_zeit += zeit

    while (timer_zeit >= 64)
        timer_zeit -= 64
        speicher(M_DIV) += 1
    wend

	local uint8 tac = speicher(M_TAC)

    if (tac and &h04) > 0 then
        timer_zeit2 += zeit

        local uint32 freq
        select case as const (tac and &h03)
            case 0 : freq = 256
            case 1 : freq = 4
            case 2 : freq = 16
            case 3 : freq = 64
        end select

        while (timer_zeit2 >= freq)
            timer_zeit2 -= freq

            if (speicher(M_TIMA) = &hFF) then
                speicher(M_TIMA) = speicher(M_TMA)
                speicher(M_INTERRUPT_FLAG) = speicher(M_INTERRUPT_FLAG) or C_TIMER
            else
                speicher(M_TIMA) += 1
            end if
        wend
	end if
end sub
