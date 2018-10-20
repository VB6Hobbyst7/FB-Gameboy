#define FARBEN			65470	'F1
#define TEMPO_DEBUG		65471	'F2
#define SPEICHER_DEBUG 	65472	'F3
#define CPU_DEBUG		65473	'F4
#define LOG_DEBUG		65474	'F5

#include once "alex-macros.bas"
#include once "file.bi"

declare sub tiles_zeichnen()
declare sub schreibe_log(texts varchar)

global as single zoom = 2
global as single zoom_half : zoom_half = zoom / 2
global uint8 tempo = 100
global imgptr speicher_img, cpu_img
global float fps_alt, fps_jetzt, delta
global varchar logs(32)
#undef palette
global uint8 palette

#include once "ui.bas"
#include once "mbc.bas"
#include once "cpu.bas"
#include once "debug.bas"

local uint8 tmpbyte
local uint32 position

var ff=freefile
if fileexists(command(1)) then
	open command(1) for binary as #ff
	screenres_gtk(160 * zoom, 144 * zoom, "GB")
else
	screenres_gtk(160 * zoom, 144 * zoom, "GB")
	open datei_oeffnen() for binary as #ff
end if
'open "roms/flappyboy.gb" for binary as #ff
'open "gb-test-roms-master/cpu_instrs/cpu_instrs.gb" for binary as #ff
'open "mooneye-gb_hwtests/emulator-only/mbc1/ram_64Kb.gb" for binary as #ff
anzahl_rom_banks = lof(ff) shr 14
do
	get #ff,,tmpbyte
	rom_speicher(position)=tmpbyte
	position += 1
loop until eof(ff)
close #ff

for i in (0,&hFFFF / 2)
	speicher(i) = rom_speicher(i)
next
	
lade_font()
speicher_img = imagecreate(xmax, ymax, 0)
cpu_img = imagecreate(xmax, ymax, 0)
cpu_start()

function main(datas gptr)bool
	if win->has_toplevel_focus = 1 then 	
		if keyup = 119 then : tasten(1) or= &h04
		elseif keyup = 115 then : tasten(1) or= &h08
		elseif keyup = 97 then : tasten(1) or= &h02
		elseif keyup = 100 then : tasten(1) or= &h01
			
		elseif keyup = 113 then : tasten(0) or= &h01
		elseif keyup = 101 then : tasten(0) or= &h02
		elseif keyup = 65507 then : tasten(0) or= &h04
		elseif keyup = 32 then : tasten(0) or= &h08
		end if
		
		if keydown = 119 then			'W	=	Hoch
			tasten(1) and= &h0B
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif keydown = 115 then		'S	=	Runter
			tasten(1) and= &h07
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif keydown = 97 then		'A	=	Links
			tasten(1) and= &h0D
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif keydown = 100 then		'D	=	Rechts
			tasten(1) and= &h0E
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
			
		elseif keydown = 113 then		'Q	=	A
			tasten(0) and= &h0E
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif keydown = 101 then		'E	=	B
			tasten(0) and= &h0D
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif  keydown = 65507 then	'Strg =	Select
			tasten(0) and= &h0B
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		elseif  keydown = 32 then		'Leer =	Start
			tasten(0) and= &h07
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if
		
		if keyup <> 0 then keyup = 0
		
		gtk_widget_get_pointer(fb_img, @mx, @my)
		
		local uint32 zyklen
		fps_jetzt = timer
		delta = (fps_jetzt - fps_alt)
		if delta >= 1 / (60 * (tempo / 100)) then	'FPS-Limit auf 60		Wieso funktioniert tempo = 200 nicht?
			do
				cpu()
				timers()
				gpu()
				interrupts()
				zyklen += zeit
				if ende = true then exit do
			loop until zyklen > 17556
			fps_alt = fps_jetzt
		end if
		
		if keydown = SPEICHER_DEBUG then	'F3	-> Speicher anzeigen
			frame_zeichnen()
			debug_speicher()
		elseif keydown = CPU_DEBUG then		'F4 -> CPU anzeigen (OPcodes)
			frame_zeichnen()
			debug_cpu()
		elseif keydown = LOG_DEBUG then		'F5 -> Log und ROM-Infos
			frame_zeichnen()
			debug_log()
		end if
	end if
	
	if ende = true then gtk_main_quit()
	
	return true
end function 

g_timeout_add(10,cast(any ptr,@main),0)
fps_alt = timer
gtk_main()
imagedestroy cpu_img
imagedestroy speicher_img
end
