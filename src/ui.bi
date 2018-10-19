#include once "gtk/gtk.bi"

global uint64 xmax,ymax
global uint32 win_xmax, win_ymax, keydown, keyhit, keyrelease
global ui ptr fb_img
global varchar fenster_titel
global as _GtkWindow ptr win

class t_font
	uint8 data(9,9)
end class
global as t_font font(120)

#macro screenres_gtk(x,y,titel)
	fenster_titel = titel
	screencontrol 3, xmax, ymax
	gtk_init( NULL, NULL)
	win = gtk_window_new( GTK_WINDOW_TOPLEVEL)
	gtk_window_set_title( GTK_WINDOW(win), titel)
	
	fb_img = gtk_drawing_area_new()
	gtk_widget_set_size_request(fb_img, x, y)
	gtk_container_add( GTK_CONTAINER(win),fb_img)
	gtk_signal_connect( GTK_OBJECT(fb_img), "expose-event", GTK_SIGNAL_FUNC(@skalieren), NULL )
	
	g_signal_connect(win, "key-press-event", G_CALLBACK(@taste_unten), NULL)
	g_signal_connect(win, "key-release-event", G_CALLBACK(@taste_oben), NULL)
	
	gtk_widget_show_all(cast(GTKWidget ptr,win))
	
	screenres xmax, ymax, 24,,-1 or &h40
#endmacro

function skalieren cdecl(widget ui ptr, event as GdkEventExpose ptr, userdata as gpointer)bool
    gtk_window_get_size(win, @win_xmax, @win_ymax)
    if win_xmax < win_ymax + zoom * 16 then
		zoom = win_xmax / 160
	else
		zoom = win_ymax / 144	
	end if
    zoom_half = zoom / 2
    gdk_draw_rgb_32_image(widget->window, widget->style->fg_gc(GTK_STATE_NORMAL), 0, 0, xmax, ymax, GDK_RGB_DITHER_MAX, screenptr, xmax * 4 )
    'gtk_window_resize(win, 160 * zoom, 144 * zoom)
    return true
end function

function taste_unten(widget ui ptr, event as GdkEventKey ptr)bool
	if event->keyval <> 0 then keydown = event->keyval
	return true
end function

function taste_oben(widget ui ptr, event as GdkEventKey ptr)bool
	if event->keyval <> 0 then keyhit = event->keyval
	if event->keyval = keydown then 
		if keyhit = TEMPO_DEBUG then		'Geschwindigkeit ändern, von 0% - 100%
			select case as const tempo
				case 100:tempo = 0
				case 0:tempo = 1
				case 1:tempo = 5
				case 5:tempo = 50
				case 50:tempo = 100
			end select
			gtk_window_set_title( GTK_WINDOW(win), fenster_titel + " " + str(tempo) + "%" + " PAL" + str(palette))
		elseif keyhit = FARBEN then			'Farbpalette ändern, S/W und Grün
			select case as const palette
				case 0 : palette = 1
				case 1 : palette = 2
				case 2 : palette = 3
				case 3 : palette = 0
			end select
			gtk_window_set_title( GTK_WINDOW(win), fenster_titel + " " + str(tempo) + "%" + " PAL" + str(palette))
		end if
		keydown=0
	end if
	return true
end function

sub text(x uint32, y uint32, text2 varchar, farbe uint32=&hFFFFFF)
	local uint32 curx = x
	for i in(0,len(text2) - 1)
		select case as const text2[i]
			case 33 to 126
				for x2 in(0,8)
					for y2 in(0,8)
						if font(text2[i] - 33).data(x2,y2) <> 0 then
							'pset (x+i*8+x2,y+y2),&hFFFFFF
							line (curx,y + y2 * zoom_half)-(curx + zoom_half - 0.4,y + y2 * zoom_half + zoom_half - 1),farbe,bf
						end if
					next
					curx += zoom_half
				next
			case else
				curx += 8 * zoom_half
		end select
	next
end sub

#macro lade_font()
	local imgptr abc=imagecreate(855,9), tmp_char=imagecreate(9,9)
	bload "abc.bmp",abc

	for i in(0,120)
		line tmp_char,(0,0)-(8,8),0,bf
		get abc,(i * 9,0)-(i * 9 + 8,8),tmp_char
		for x in(0,8)
			for y in(0,8)
				local uint32 clr = point(x,y,tmp_char)
				if clr <> &hFF000000 then font(i).data(x,y) = 1
			next
		next
	next

	imagedestroy abc
	imagedestroy tmp_char
#endmacro
