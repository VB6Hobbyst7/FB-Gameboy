#macro MBC1()
	if adresse <= &h1FFF then		'RAM aktivieren
		ram_an = 0
		if (wert and &h0F) = &h0A then ram_an = 1
	elseif adresse <= &h3FFF then	'Banknummer		
		wert = wert and &h1F
		if wert = 0 then wert = 1	'Es gibt keine Bank 0
		rom_bank = (rom_bank and &h60) or wert
		local uint32 offset = ((rom_bank - 1) and (anzahl_rom_banks - 1)) shl 14
		for i in(0,&h3FFF)
			speicher(&h4000 + i) = rom_speicher(&h4000 + i + offset)
		next
	elseif adresse <= &h5FFF then	'Banknummer ODER RAM-Bank
		if rom_bank_modus = 0 then	'ROM-Bank
			rom_bank = (wert and &h1F) or (rom_bank and &h60)
			local uint32 offset = ((rom_bank - 1) and (anzahl_rom_banks - 1)) shl 14
			for i in(0,&h3FFF)
				speicher(&h4000 + i) = rom_speicher(&h4000 + i + offset)
			next	
		else						'RAM-Bank
			local uint32 offset = ((rom_ram_bank - 1) and (anzahl_rom_banks - 1)) shl 13
			rom_ram_bank = wert and &h03
			for i in(0,&h1FFF)
				speicher(&hA000 + i) = rom_ram_speicher(i + offset)
			next
		end if
	elseif adresse <= &h7FFF then		'ROM/RAM Modus auswählen
		rom_bank_modus = wert and &h01
	end if
#endmacro

#macro MBC5()
	if adresse <= &h1FFF then		'RAM aktivieren
		ram_an = 0
		if (wert and &h0F) = &h0A then ram_an = 1
	elseif adresse <= &h2FFF then	'Banknummer (untere 8bits)
		rom_bank = ((rom_bank and &hFF00) or wert)
		local int32 offset = ((rom_bank - 1) and (anzahl_rom_banks - 1)) shl 14
		for i in(0,&h3FFF)
			speicher(&h4000 + i) = rom_speicher(&h4000 + i + offset)
		next
	elseif adresse <= &h3FFF then	'Banknummer (oberer, einzelner Bit)
		rom_bank = ((rom_bank and &h00FF) or ((wert and &h01) shl 8))
		local int32 offset = ((rom_bank - 1) and (anzahl_rom_banks - 1)) shl 14
		for i in(0,&h3FFF)
			speicher(&h4000 + i) = rom_speicher(&h4000 + i + offset)
		next
	elseif adresse <= &h5FFF then	'RAM Banknummer
		local uint32 offset = ((rom_ram_bank - 1) and (anzahl_rom_banks - 1)) shl 13
		rom_ram_bank = wert and &h0F
		offset = ((rom_ram_bank - 1) and (anzahl_rom_banks - 1)) shl 13
		for i in(0,&h1FFF)
			speicher(&hA000 + i) = rom_ram_speicher(i + offset)
		next
	end if
#endmacro
