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
else
	print "ROM '"+command(1)+"' nicht gefunden!"
	print "./fbgb [ROM].gb"
	end
end if
'open "roms/tetris.gb" for binary as #ff
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

screenres_gtk(160 * zoom, 144 * zoom, "GB")
	
lade_font()
speicher_img = imagecreate(xmax, ymax, 0)
cpu_img = imagecreate(xmax, ymax, 0)
cpu_start()

function main(datas gptr)bool
	if win->has_toplevel_focus = 1 then 	
		tasten(0) = &h0F
		tasten(1) = &h0F
		if keydown = 119 then			'W	=	Hoch
			tasten(1) and= &h0B
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if keydown = 115 then	'S	=	Runter
			tasten(1) and= &h07
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if keydown = 97 then		'A	=	Links
			tasten(1) and= &h0D
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if keydown = 100 then	'D	=	Rechts
			tasten(1) and= &h0E
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
			
		end if:if keydown = 113 then	'Q	=	A
			tasten(0) and= &h0E
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if keydown = 101 then	'E	=	B
			tasten(0) and= &h0D
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if  keydown = 65507 then	'Strg =	Select
			tasten(0) and= &h0B
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if:if  keydown = 32 then	'Leer =	Start
			tasten(0) and= &h07
			stop = 0 : speicher(M_INTERRUPT_FLAG) or= C_JOYPAD
		end if
		
		if keydown = 65363 then t_offset += 1
		if keydown = 65361 then t_offset -= 1
		
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
	
	return true
end function 

g_timeout_add(2,cast(any ptr,@main),0)
fps_alt = timer
gtk_main()
imagedestroy cpu_img
imagedestroy speicher_img
end
