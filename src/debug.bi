#macro debug_speicher()
	local uint32 x,y,index
		
	line speicher_img,(0,0)-(win_xmax,win_ymax),0,bf
	
	x=0:y=0
	for i in(0,&hFFFF)
		line speicher_img,(x*zoom_half,y*zoom_half)-(x*zoom_half+zoom_half,y*zoom_half+zoom_half),rgb(speicher(i),speicher(i),speicher(i)),bf	
		if mx > x * zoom_half and my > y * zoom_half then index = i
		x += 1
		if x >= 320 then
			x = 0
			y += 1
		end if
	next
	
	x = 0
	y *= zoom_half
	y += zoom_half * 2
	
	put (0,0),speicher_img,alpha,200
	if index >= &hFFFF - 100 then index = &hFFFF - 100
	
	for i2 in (0,9)
		text (2, y, hex(index,4), &hC0C0C0)
		for i in(0,9)
			if speicher(index) = 0 then
				text((40 + i * 20) * zoom_half, y, hex(speicher(index), 2), &hC0C0C0)
			else
				text((40 + i * 20) * zoom_half, y, hex(speicher(index), 2))
			end if
			select case as const speicher(index)
				case 33 to 126 : text((239 + i * 8) * zoom_half, y, chr(speicher(index)), &h00FFFF)
				case else : text((239 + i * 8) * zoom_half, y, ".", &hC0C0C0)
			end select
			index += 1
		next
		y += 8 * zoom_half
	next
	
	gdk_draw_rgb_32_image(fb_img->window, fb_img->style->fg_gc(GTK_STATE_NORMAL), 0, 0, xmax, ymax, GDK_RGB_DITHER_MAX, screenptr, xmax * 4)
#endmacro

#macro debug_cpu()	
	put (0,0),cpu_img,alpha,200
	
	local as opcode debug_op
	local uint16 debug_pc = pc
	local varchar opcode, hexi
	
	for i2 in(0,30)
		opcode="":hexi=""
		debug_op = opcodes(speicher(debug_pc))
		for i in (0,15)
			if debug_op.nam[i]=asc("%") then
				opcode += "0x"
				if debug_op.nam[i+1]=asc("1") then
					opcode += hex(speicher(debug_pc+2),2)
					opcode += hex(speicher(debug_pc+1),2)
				else
					opcode += hex(speicher(debug_pc+1),2)
				end if
				i += 1
			else
				opcode += chr(debug_op.nam[i])
			end if
		next
		for i in (0,debug_op.laenge)
			hexi += hex(speicher(debug_pc + i),2)+" "
		next
		if i2 = 0 then
			text(10, 10 + i2 * (8 * zoom_half),hex(debug_pc,4),&h00C0C0)
			text(10 + 50 * zoom_half ,10 + i2 * (8 * zoom_half),opcode,&h00FFFF)
			text(10 + 230 * zoom_half ,10 + i2 * (8 * zoom_half),hexi,&h00C0C0)
		else	
			text(10, 10 + i2 * (8 * zoom_half),hex(debug_pc,4),&hC0C0C0)
			text(10 + 50 * zoom_half ,10 + i2 * (8 * zoom_half),opcode)
			text(10 + 230 * zoom_half ,10 + i2 * (8 * zoom_half),hexi,&hC0C0C0)
		end if
		debug_pc += debug_op.laenge + 1
	next
	local varchar tmp="A "+hex(A,2)
	tmp+="  BC "+hex(BC,4)
	tmp+="  DE "+hex(DE,4)
	tmp+="  HL "+hex(HL,4)
	text(10,265 * zoom_half,tmp)
	if (f and &h80) > 0 then 
		text(10, 275 * zoom_half,"ZERO",&h0030FF)
	else
		text(10, 275 * zoom_half,"ZERO",&hC0C0C0)
	end if
	if (f and &h10) > 0 then 
		text(10 + 50 * zoom_half,275 * zoom_half,"CARRY",&h0030FF)
	else
		text(10 + 50 * zoom_half,275 * zoom_half,"CARRY",&hC0C0C0)
	end if
	if (f and &h20) > 0 then 
		text(10 + 110 * zoom_half,275 * zoom_half,"HALF",&h0030FF)
	else
		text(10 + 110 * zoom_half,275 * zoom_half,"HALF",&hC0C0C0)
	end if
	if (f and &h40) > 0 then 
		text(10 + 160 * zoom_half,275 * zoom_half,"SUB",&h0030FF)
	else
		text(10 + 160 * zoom_half,275 * zoom_half,"SUB",&hC0C0C0)
	end if
	if interrupts_master = 1 then
		text(10 + 200 * zoom_half,275 * zoom_half,"INTERRUPT",&h0030FF)
	else
		text(10 + 200 * zoom_half,275 * zoom_half,"INTERRUPT",&hC0C0C0)
	end if
	
	gdk_draw_rgb_32_image(fb_img->window, fb_img->style->fg_gc(GTK_STATE_NORMAL), 0, 0, xmax, ymax, GDK_RGB_DITHER_MAX, screenptr, xmax * 4)
#endmacro

sub schreibe_log(texts varchar)
	for i in(30,0) step -1
		logs(i+1)=logs(i)
	next
	logs(0)=texts
end sub

#macro debug_log()
	put (0,0),cpu_img,alpha,200
	
	local varchar spielname
	
	for i in(&h0134,&h0143)
		spielname += chr(speicher(i))
	next
	
	text(10, 10 * zoom_half, spielname)
	
	select case as const speicher(M_MBC)
		case &h00:text(160*zoom_half, 10*zoom_half, "Kein MBC("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h01:text(160*zoom_half, 10*zoom_half, "MBC1("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h02:text(160*zoom_half, 10*zoom_half, "MBC1+RAM("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h03:text(160*zoom_half, 10*zoom_half, "MBC1+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h05:text(160*zoom_half, 10*zoom_half, "MBC2("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h06:text(160*zoom_half, 10*zoom_half, "MBC2+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h0B:text(160*zoom_half, 10*zoom_half, "MMM01("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h0C:text(160*zoom_half, 10*zoom_half, "MMM01+RAM("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h0D:text(160*zoom_half, 10*zoom_half, "MMM01+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h0F:text(160*zoom_half, 10*zoom_half, "MBC3+TIMER+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h10:text(160*zoom_half, 10*zoom_half, "MBC3+T+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h11:text(160*zoom_half, 10*zoom_half, "MBC3("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h12:text(160*zoom_half, 10*zoom_half, "MBC3+RAM("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h13:text(160*zoom_half, 10*zoom_half, "MBC3+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h15:text(160*zoom_half, 10*zoom_half, "MBC4("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h16:text(160*zoom_half, 10*zoom_half, "MBC4+RAM("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h17:text(160*zoom_half, 10*zoom_half, "MBC4+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case &h19:text(160*zoom_half, 10*zoom_half, "MBC5("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h1A:text(160*zoom_half, 10*zoom_half, "MBC5+RAM("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h1B:text(160*zoom_half, 10*zoom_half, "MBC5+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h1C:text(160*zoom_half, 10*zoom_half, "MBC5("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h1D:text(160*zoom_half, 10*zoom_half, "MBC5+RAM("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &h1E:text(160*zoom_half, 10*zoom_half, "MBC5+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h00FF00)
		case &hFF:text(160*zoom_half, 10*zoom_half, "HuC1+RAM+BAT("+hex(speicher(M_MBC),2)+")",&h0030FF)
		case else:text(160*zoom_half, 10*zoom_half, "Unbekannt("+hex(speicher(M_MBC),2)+")",&h0030FF)
	end select
	
	'select case as const speicher(M_GBC)
		'case &hC0:text(290*zoom_half, 10*zoom_half, "GBC",&h0030FF)
		'case &h80:text(290*zoom_half, 10*zoom_half, "GB/",&h00FFFF)
		'case else:text(290*zoom_half, 10*zoom_half, "GB",&h00FF00)
	'end select
	
	for i in(0,31)
		if len(logs(i))=0 then exit for
		if logs(i)[1]=asc("F") then			'Fehler
			text(10,(28+i*8)*zoom_half,logs(i),&h0030FF)
		elseif logs(i)[1]=asc("W") then		'Warnung
			text(10,(28+i*8)*zoom_half,logs(i),&h00FFFF)
		else
			text(10,(28+i*8)*zoom_half,logs(i))
		end if
	next
	
	gdk_draw_rgb_32_image(fb_img->window, fb_img->style->fg_gc(GTK_STATE_NORMAL), 0, 0, xmax, ymax, GDK_RGB_DITHER_MAX, screenptr, xmax * 4)
#endmacro
