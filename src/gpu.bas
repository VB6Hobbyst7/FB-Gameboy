enum gpuMode 
	C_MODE_HBLANK, C_MODE_VBLANK, C_MODE_OAM, C_MODE_VRAM
end enum

#define C_CONTROL_BGENABLE (1 shl 0)
#define C_CONTROL_SPRITEENABLE (1 shl 1)
#define C_CONTROL_SPRITEVDOUBLE (1 shl 2)
#define C_CONTROL_TILEMAP (1 shl 3)
#define C_CONTROL_TILESET (1 shl 4)
#define C_CONTROL_WINDOWENABLE (1 shl 5)

global uint8 gpu_mode = C_MODE_HBLANK
global int32 gpu_zeit

global as single t_offset 

global uint32 buffer_bg(160*144)
global uint32 pk_palette(3) = {&hFFEFFF , &h8CB5F7 , &h9C7384 , &h101018}
global uint32 sw_palette(3) = {&hCDDBE0 , &h949FA8 , &h666B70 , &h262B2B}
global uint32 gr_palette(3) = {&hC2F0C4 , &hA8B95A , &h6E601E , &h001B2D}
global uint32 bl_palette(3) = {&hC2E4FF , &h56A4DC , &h4C60A9 , &h362942}


sub scanline_zeichnen()
	if (speicher(M_LCD_CONTROL) and &h80) = 0 then exit sub	'LCD aus
		
    if (not speicher(M_LCD_CONTROL) and &h01) > 0 then		'Hintergrund deaktiviert -> Weiß machen
		for i in(0,160)
            buffer_bg((speicher(M_SCANLINE) * 160) + i) = 0
        next
        exit sub
    end if
    
    local uint8 bg_pal(3), obp0_pal(3), obp1_pal(3)
    bg_pal(3)=speicher(M_BGP) shr 6
	bg_pal(2)=speicher(M_BGP) shr 4 and &b00000011
	bg_pal(1)=speicher(M_BGP) shr 2 and &b00000011
	bg_pal(0)=speicher(M_BGP) and &b00000011
	obp0_pal(3)=speicher(M_OBP0) shr 6
	obp0_pal(2)=speicher(M_OBP0) shr 4 and &b00000011
	obp0_pal(1)=speicher(M_OBP0) shr 2 and &b00000011
	obp0_pal(0)=speicher(M_OBP0) and &b00000011
	obp1_pal(3)=speicher(M_OBP1) shr 6
	obp1_pal(2)=speicher(M_OBP1) shr 4 and &b00000011
	obp1_pal(1)=speicher(M_OBP1) shr 2 and &b00000011
	obp1_pal(0)=speicher(M_OBP1) and &b00000011
	
	'######## Ebene 0 - Background ########
	
	local int32 MapDaten=iif((speicher(M_LCD_CONTROL) and &h08) > 0,&h9C00,&h9800)	'Pointer auf die Map
	local int32 TileDaten=iif((speicher(M_LCD_CONTROL) and &h10) > 0,&h8000,&h9000)	'Pointer auf die Tile-Grafiken im VRAM
    
	local uint8 TileY = ((speicher(M_SCANLINE) + speicher(M_SCROLLY) - 3.5) / 8) mod 32	'Wieso 3.5?
	local uint8 TileYOffset  = (speicher(M_SCANLINE) + speicher(M_SCROLLY)) mod 8

    for i in(0,159)
		local uint8 TileX = ((speicher(M_SCROLLX) + i - 3.5) / 8) mod 32			'Wieso 3.5?
		local uint8 TileID = speicher(MapDaten + (TileY * 32) + TileX)				'Index des Tiles im VRAM
		local int32 TileDataPtr = iif(TileDaten=&h8000,TileDaten + TileID * 16,TileDaten + cast(byte,TileID) * 16) + (TileYOffset * 2) 
		
        local uint8 BitNummer = 7 - (speicher(M_SCROLLX) + i) mod 8
		local uint8 Farbe = ((speicher(TileDataPtr) shr BitNummer) and 1) or ((speicher(TileDataPtr + 1) shr BitNummer) and 1) shl 1
		buffer_bg((speicher(M_SCANLINE) * 160) + i) = bg_pal(Farbe)
	next
	
	'######## Ebene 1 - Window ########
	
	if (speicher(M_LCD_CONTROL) and &h20) > 0 and speicher(M_SCANLINE) >= speicher(M_WY) then	'Wird die Ebene benutzt?
		local int32 MapDaten=iif((speicher(M_LCD_CONTROL) and &h40) > 0,&h9C00,&h9800)
		local int32 TileDaten=iif((speicher(M_LCD_CONTROL) and &h10) > 0,&h8000,&h9000)
		
		local uint8 TileY = ((speicher(M_SCANLINE) - speicher(M_WY) - 3.5) / 8)
		local uint8 TileYOffset  = (speicher(M_SCANLINE) - speicher(M_WY)) mod 8

		for i in(0,159)
			if (speicher(M_WX) + i) < 7 then : continue for
			elseif (speicher(M_WX) + i) > 166 then : exit for : end if
			local uint8 TileX = ((i - 3.5) / 8)
			local uint8 TileID = speicher(MapDaten + (TileY * 32) + TileX)		
			local int32 TileDataPtr = iif(TileDaten=&h8000,TileDaten + TileID * 16,TileDaten + cast(byte,TileID) * 16) + (TileYOffset * 2) 
			
			local uint8 BitNummer = 7 - i mod 8
			local uint8 Farbe = ((speicher(TileDataPtr) shr BitNummer) and 1) or ((speicher(TileDataPtr + 1) shr BitNummer) and 1) shl 1
			buffer_bg(speicher(M_WX) - 7 + (speicher(M_SCANLINE) * 160) + i) = bg_pal(Farbe)
		next
	end if
	
	'######## Ebene 2 - Sprites ########
	
	if (speicher(M_LCD_CONTROL) and &h02) > 0 then	'Wird die Ebene benutzt?
		local uint8 SpriteGroesse = iif((speicher(M_LCD_CONTROL) and &h04) > 0,16,8)
	
		for index in(0,39)	'40 Sprites in OAM
			local uint8 SpriteX = speicher(M_OAM + index * 4 + 1) - 8, SpriteY = speicher(M_OAM + index * 4) - 16
			local uint8 TileID = speicher(M_OAM + index * 4 + 2), Flags = speicher(M_OAM + index * 4 + 3)
			if SpriteGroesse = 16 then TileID and= &hFE

			if speicher(M_SCANLINE) >= SpriteY and speicher(M_SCANLINE) < SpriteY + SpriteGroesse then
				local int32 SpiegelY = (speicher(M_SCANLINE) - (SpriteY)) * 2 mod SpriteGroesse * 2
				if bit(Flags,6) = true then SpiegelY = SpriteGroesse * 2 - 2 - (speicher(M_SCANLINE) - (SpriteY)) * 2 mod SpriteGroesse * 2
				local int32 TileDataPtr = M_VRAM + TileID * 16 + SpiegelY
				
				for i in(0,7) 
					if SpriteX + i < 0 then : continue for
					elseif SpriteX + i > 159 then : exit for : end if

					if bit(Flags,7) = true and buffer_bg(SpriteX + i + speicher(M_SCANLINE) * 160) > 0 then continue for

					local uint8 BitNummer = iif(bit(Flags,5) = true, i mod 8, 7 - i mod 8) 
					local uint8 Farbe = ((speicher(TileDataPtr) shr BitNummer) and 1) or (((speicher(TileDataPtr + 1) shr BitNummer) and 1) shl 1)
					if Farbe <> 0 then buffer_bg(SpriteX + i + speicher(M_SCANLINE) * 160) = iif(bit(Flags,4) = true, obp1_pal(Farbe),obp0_pal(Farbe))
				next
			end if
		next
	end if
end sub

sub frame_zeichnen()
	if (speicher(M_LCD_CONTROL) and &h80) = 0 then exit sub
	
	local int32 x,y
	cls	
	for i in(0,160 * 144 - 1)
		select case as const palette
			case 0 : line (x * zoom,y * zoom)-(x * zoom + zoom,y * zoom + zoom),pk_palette(buffer_bg(i)),bf
			case 1 : line (x * zoom,y * zoom)-(x * zoom + zoom,y * zoom + zoom),sw_palette(buffer_bg(i)),bf
			case 2 : line (x * zoom,y * zoom)-(x * zoom + zoom,y * zoom + zoom),gr_palette(buffer_bg(i)),bf
			case 3 : line (x * zoom,y * zoom)-(x * zoom + zoom,y * zoom + zoom),bl_palette(buffer_bg(i)),bf
		end select
		x += 1
		if x >= 160 then 
			x = 0
			y += 1
		end if
	next
end sub

sub gpu()
	gpu_zeit += zeit
	
	select case as const gpu_mode
		case C_MODE_HBLANK
			if gpu_zeit >= 51 then
				
				if speicher(M_SCANLINE) = 143 then	
					speicher(M_INTERRUPT_FLAG) = speicher(M_INTERRUPT_FLAG) or C_VBLANK		
					frame_zeichnen()
					if keydown<SPEICHER_DEBUG then gdk_draw_rgb_32_image(fb_img->window, fb_img->style->fg_gc(GTK_STATE_NORMAL), 0, 0, xmax, ymax, GDK_RGB_DITHER_MAX, screenptr, xmax * 4)
					gpu_mode = C_MODE_VBLANK
				else
					gpu_mode = C_MODE_OAM
				end if
				
				speicher(M_SCANLINE) += 1
				gpu_zeit -= 51
				if (speicher(M_LCD_STATUS) and &h08) = 1 then speicher(M_INTERRUPT_FLAG) = speicher(M_INTERRUPT_FLAG) or &h02	'LCD Stat
			end if
			
		case C_MODE_VBLANK
			if gpu_zeit >= 114 then
				speicher(M_SCANLINE) += 1
				if speicher(M_SCANLINE) > 153 then
					speicher(M_SCANLINE) = 0
					gpu_mode = C_MODE_OAM
				end if
				gpu_zeit -= 114
			end if
			
		case C_MODE_OAM
			if gpu_zeit >= 20 then
				gpu_mode = C_MODE_VRAM
				gpu_zeit -= 20	
			end if
		
		case C_MODE_VRAM
			if gpu_zeit >= 43 then
				gpu_mode = C_MODE_HBLANK
				scanline_zeichnen()
				gpu_zeit -= 43
			end if	
		
	end select
	
	speicher(M_LCD_STATUS) = (speicher(M_LCD_STATUS) and &b11111100) + gpu_mode
	
	if (speicher(M_LCD_STATUS) and &h40) > 0 and speicher(M_SCANLINE) = speicher(M_LYC) then speicher(M_INTERRUPT_FLAG) = speicher(M_INTERRUPT_FLAG) or &h02 'Interrupt
end sub
