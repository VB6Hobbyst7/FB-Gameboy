sub savegame_laden(check uint16)
	var ff = freefile
	open "saves/c"+hex(check,4)+".sav" for binary as #ff
		get #ff,,af
		get #ff,,bc
		get #ff,,de
		get #ff,,hl
		get #ff,,sp
		get #ff,,pc
		get #ff,,interrupts_master
		get #ff,,stop
		get #ff,,zeit
		get #ff,,rom_bank
		get #ff,,rom_ram_bank
		for i in(&h7FFF,&hFFFF)
			get #ff,,speicher(i)
		next
		for i in(0,500000)
			get #ff,,rom_ram_speicher(i)
		next
	close #ff
	
	tasten(0) = &h0F
	tasten(1) = &h0F
end sub

sub savegame_speichern(check uint16)
	var ff = freefile
	open "saves/c"+hex(check,4)+".sav" for binary as #ff
		put #ff,,af
		put #ff,,bc
		put #ff,,de
		put #ff,,hl
		put #ff,,sp
		put #ff,,pc
		put #ff,,interrupts_master
		put #ff,,stop
		put #ff,,zeit
		put #ff,,rom_bank
		put #ff,,rom_ram_bank
		for i in(&h7FFF,&hFFFF)
			put #ff,,speicher(i)
		next
		for i in(0,500000)
			put #ff,,rom_ram_speicher(i)
		next
	close #ff
end sub
