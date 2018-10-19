global uint8 speicher(&hFFFF)
global uint8 attribut(&hFFFF)	'Wenn 1, dann kaputt

'32*32 tiles werden gezeichnet, allerdings nur 10*9 angezeigt

print hex(&hA001+16384)

'0000-8000	= Code & Daten		(32 KB)
'8001-A000	= RAM				( 8 KB)



'Nur 200 nehmen, dafür aber 16 Farben??
'Oder doch Paletten?

'BAFF-FBFF	= Tilesetdaten 		(16 KB)

'FB00-FF00	= VRAM 	32*32 Tiles  (1 KB)
'FFFD		= ScrollX
'FFFE		= ScrollY
'FFFF		= Joypad-Register (8 Bits für 8 Tasten)
