#define set_zero() f = f or &h80
#define clear_zero() f = f and &h7F

#define set_carry() f = f or &h10
#define clear_carry() f = f and &hEF

sub nop()
	
end sub

sub halt()
	stop = 1
end sub

sub mov_spi8_hl()
	local int32 value = read_byte(pc)
	if value > &h7F then value = (-((value xor &hFF) and &hFF) - 1)
	local int32 value2 = (value + sp) 
	hl = value2
	value = sp xor value xor value2
	f = 0
	if (value and &h100) > 0 then set_carry()
	if (value and &h10) > 0 then f = f or &h20
end sub

sub mov_i16_bc()
	bc=read_word(pc)
end sub

sub mov_i16_de()
	de=read_word(pc)
end sub

sub mov_i16_hl()
	hl=read_word(pc)
end sub

sub mov_i16_sp()
	sp=read_word(pc)
end sub

sub mov_hl_sp()
	sp=hl
end sub

sub mov_i8_phl()
	write_byte(hl,read_byte(pc))
end sub

sub mov_a_a16()
	write_byte(read_word(pc),a)
end sub

sub mov_a16_a()
	a=read_byte(read_word(pc))
end sub

sub mov_i8_a()
	a=read_byte(pc)
end sub

sub mov_i8_b()
	b=read_byte(pc)
end sub

sub mov_i8_c()
	c=read_byte(pc)
end sub

sub mov_i8_d()
	d=read_byte(pc)
end sub

sub mov_i8_e()
	e=read_byte(pc)
end sub

sub mov_i8_h()
	h=read_byte(pc)
end sub

sub mov_i8_l()
	l=read_byte(pc)
end sub

sub mov_a_pbc()
	write_byte(bc,a)
end sub

sub mov_a_hla()
	write_byte(hl,a)
	hl+=1
end sub

sub mov_a_hls()
	write_byte(hl,a)
	hl-=1
end sub

sub mov_hla_a()
	a=read_byte(hl)
	hl+=1
end sub

sub mov_hls_a()
	a=read_byte(hl)
	hl-=1
end sub

sub inc_bc()
	bc+=1
end sub

sub inc_de()
	de+=1
end sub

sub inc_hl()
	hl+=1
end sub

sub inc_sp()
	sp+=1
end sub

sub dec_bc()
	bc-=1
end sub

sub dec_de()
	de-=1
end sub

sub dec_hl()
	hl-=1
end sub

sub dec_sp()
	sp-=1
end sub

sub inc_a()
	a+=1
	clear_zero()
	if a = 0 then set_zero()
	if (a and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_a()
	a-=1
	clear_zero()
	if a = 0 then set_zero()
	if (a and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_b()
	b+=1
	clear_zero()
	if b = 0 then set_zero()
	if (b and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_b()
	b-=1
	clear_zero()
	if b = 0 then set_zero()
	if (b and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_c()
	c+=1
	clear_zero()
	if c = 0 then set_zero()
	if (c and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_c()
	c-=1
	clear_zero()
	if c = 0 then set_zero()
	if (c and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_d()
	d+=1
	clear_zero()
	if d = 0 then set_zero()
	if (d and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_d()
	d-=1
	clear_zero()
	if d = 0 then set_zero()
	if (d and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_e()
	e+=1
	clear_zero()
	if e = 0 then set_zero()
	if (e and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_e()
	e-=1
	clear_zero()
	if e = 0 then set_zero()
	if (e and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_h()
	h+=1
	clear_zero()
	if h = 0 then set_zero()
	if (h and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_h()
	h-=1
	clear_zero()
	if h = 0 then set_zero()
	if (h and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_l()
	l+=1
	clear_zero()
	if l = 0 then set_zero()
	if (l and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_l()
	l-=1
	clear_zero()
	if l = 0 then set_zero()
	if (l and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub inc_phl()
	write_byte(hl,read_byte(hl)+1)
	clear_zero()
	if read_byte(hl) = 0 then set_zero()
	if (read_byte(hl) and &h0F) = 0 then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF
end sub

sub dec_phl()
	write_byte(hl,read_byte(hl)-1)
	clear_zero()
	if read_byte(hl) = 0 then set_zero()
	if (read_byte(hl) and &h0F) = &h0F then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f or &h40
end sub

sub jmp_a16()
	pc = read_word(pc) - op.laenge
end sub

sub jmp_hl()
	pc=hl - op.laenge
end sub

sub jz_a16()
	local uint8 pchtmp, pcltmp
	if (f and &h80) > 0 then
		pc = read_word(pc) - op.laenge
		zeit=4
	else
		zeit=3
	end if
end sub

sub jnz_a16()
	local uint8 pchtmp, pcltmp
	if (not f and &h80) > 0 then
		pc = read_word(pc) - op.laenge
		zeit=4
	else
		zeit=3
	end if
end sub

sub jc_a16()
	local uint8 pchtmp, pcltmp
	if (f and &h10) > 0 then
		pc = read_word(pc) - op.laenge
		zeit=4
	else
		zeit=3
	end if
end sub

sub jnc_a16()
	local uint8 pchtmp, pcltmp
	if (not f and &h10) > 0 then
		pc = read_word(pc) - op.laenge
		zeit=4
	else
		zeit=3
	end if
end sub

sub rst_00()
	sp -= 2
	write_word(sp, pc)
	pc=&h00
end sub

sub rst_08()
	sp -= 2
	write_word(sp, pc)
	pc=&h08
end sub

sub rst_10()
	sp -= 2
	write_word(sp, pc)
	pc=&h10
end sub

sub rst_18()
	sp -= 2
	write_word(sp, pc)
	pc=&h18
end sub

sub rst_20()
	sp -= 2
	write_word(sp, pc)
	pc=&h20
end sub

sub rst_28()
	sp -= 2
	write_word(sp, pc)
	pc=&h28
end sub

sub rst_30()
	sp -= 2
	write_word(sp, pc)
	pc=&h30
end sub

sub rst_38()
	sp -= 2
	write_word(sp, pc)
	pc=&h38
end sub

sub call_a16()
	sp -= 2
	write_word(sp, pc+2)
	pc = read_word(pc) - op.laenge
end sub

sub call_z_a16()
	if (f and &h80) > 0 then
		sp -= 2
		write_word(sp, pc+2)
		pc = read_word(pc) - op.laenge
		zeit=6
	else
		zeit=3
	end if
end sub

sub call_nz_a16()
	if (not f and &h80) > 0 then
		sp -= 2
		write_word(sp, pc+2)
		pc = read_word(pc) - op.laenge
		zeit=6
	else
		zeit=3
	end if
end sub

sub call_c_a16()
	if (f and &h10) > 0 then
		sp -= 2
		write_word(sp, pc+2)
		pc = read_word(pc) - op.laenge
		zeit=6
	else
		zeit=3
	end if
end sub

sub call_nc_a16()
	if (not f and &h10) > 0 then
		sp -= 2
		write_word(sp, pc+2)
		pc = read_word(pc) - op.laenge
		zeit=6
	else
		zeit=3
	end if
end sub

sub push_bc()
	sp-=1:write_byte(sp,b)
	sp-=1:write_byte(sp,c)
end sub

sub push_de()
	sp-=1:write_byte(sp,d)
	sp-=1:write_byte(sp,e)
end sub

sub push_hl()
	sp-=1:write_byte(sp,h)
	sp-=1:write_byte(sp,l)
end sub

sub push_af()
	sp-=1:write_byte(sp,a)
	sp-=1:write_byte(sp,f)
end sub

sub pop_bc()
	c=read_byte(sp):sp+=1
	b=read_byte(sp):sp+=1
end sub

sub pop_de()
	e=read_byte(sp):sp+=1
	d=read_byte(sp):sp+=1
end sub

sub pop_hl()
	l=read_byte(sp):sp+=1
	h=read_byte(sp):sp+=1
end sub

sub pop_af()
	f=read_byte(sp) and &hF0:sp+=1
	a=read_byte(sp):sp+=1
end sub

sub ret()
	pcl=read_byte(sp):sp+=1
	pch=read_byte(sp):sp+=1
end sub

sub reti()
	pcl=read_byte(sp):sp+=1
	pch=read_byte(sp):sp+=1
	interrupts_master=1
end sub

sub ret_z()
	if (f and &h80) > 0 then
		pcl=read_byte(sp):sp+=1
		pch=read_byte(sp):sp+=1
		zeit=5
	else
		zeit=2
	end if
end sub

sub ret_nz()
	if (not f and &h80) > 0 then
		pcl=read_byte(sp):sp+=1
		pch=read_byte(sp):sp+=1
		zeit=5
	else
		zeit=2
	end if
end sub

sub ret_c()
	if (f and &h10) > 0 then
		pcl=read_byte(sp):sp+=1
		pch=read_byte(sp):sp+=1
		zeit=5
	else
		zeit=2
	end if
end sub

sub ret_nc()
	if (not f and &h10) > 0 then
		pcl=read_byte(sp):sp+=1
		pch=read_byte(sp):sp+=1
		zeit=5
	else
		zeit=2
	end if
end sub

sub dis()
	interrupts_master=0
	schreibe_log("[DI] Interrupts aus")
end sub

sub eis()
	interrupts_master=1
	schreibe_log("[EI] Interrupts an")
end sub

sub rcl_a()
	local uint8 add
	f = 0
	if (a and &h80) > 0 then
		set_carry()
		add = 1
	end if
	a = ((a shl 1) + add)
end sub

sub rcr_a()
	local uint8 add
	f = 0
	if (a and 1) > 0 then
		set_carry()
		add = &h80
	end if
	a = ((a shr 1) + add)
end sub

sub rol_a()
	local uint8 add
	if (f and &h10) > 0 then add = 1
	f = 0
	if (a and &h80) > 0 then set_carry()
	a = ((a shl 1) + add)
end sub

sub ror_a()	
	local uint8 add
	if (f and &h10) > 0 then add = &h80
	f = 0
	if (a and &h01) > 0 then set_carry()
	a = ((a shr 1) + add)
end sub

sub mov_sp_a16()
	write_word(read_word(pc),sp)
end sub

sub jmp_r8()
	pc+=cast(byte,read_byte(pc))
	pc-=op.laenge-1
end sub

sub jnz_r8()
	if (not f and &h80) > 0 then
		pc+=cast(byte,read_byte(pc))
		pc-=op.laenge-1
		zeit=3
	else
		zeit=2
	end if
end sub

sub jz_r8()
	if (f and &h80) > 0 then
		pc+=cast(byte,read_byte(pc))
		pc-=op.laenge-1
		zeit=3
	else
		zeit=2
	end if
end sub

sub jnc_r8()
	if (not f and &h10) > 0 then
		pc+=cast(byte,read_byte(pc))
		pc-=op.laenge-1
		zeit=3
	else
		zeit=2
	end if
end sub

sub jc_r8()
	if (f and &h10) > 0 then
		pc+=cast(byte,read_byte(pc))
		pc-=op.laenge-1
		zeit=3
	else
		zeit=2
	end if
end sub

sub add_i8_sp()
	local int32 value, value2
	value2 = read_byte(pc)
	if value2 > &h7F then value2 = (-((value2 xor &hFF) and &hFF)-1)
	value = (sp + value2) and &hFFFF
	value2 = sp xor value2 xor value
	sp = value
	f = 0
	if (value2 and &h100) = &h100 then set_carry()
	if (value2 and &h10) = &h10 then f = f or &h20
end sub

sub add_bc_hl()
	local int32 add1=hl, add2=bc
	local int32 value = hl + bc
	hl = value
	if value > &hFFFF then
		set_carry()	
	else 
		f = f and &hEF
	end if
	if (&h0FFF - (add1 and &h0FFF)) < (add2 and &h0FFF)then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF	
end sub

sub add_de_hl()
	local int32 add1=hl, add2=de
	local int32 value = hl + de
	hl = value
	if value > &hFFFF then
		set_carry()	
	else 
		f = f and &hEF
	end if
	if (&h0FFF - (add1 and &h0FFF)) < (add2 and &h0FFF)then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF	
end sub

sub add_hl_hl()
	local int32 add1=hl, add2=hl
	local int32 value = hl + hl
	hl = value
	if value > &hFFFF then
		set_carry()	
	else 
		f = f and &hEF
	end if
	if (&h0FFF - (add1 and &h0FFF)) < (add2 and &h0FFF)then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF	
end sub

sub add_sp_hl()
	local int32 add1=hl, add2=sp
	local int32 value = hl + sp
	hl = value
	if value > &hFFFF then
		set_carry()	
	else 
		f = f and &hEF
	end if
	if (&h0FFF - (add1 and &h0FFF)) < (add2 and &h0FFF)then
		f = f or &h20
	else
		f = f and &hDF
	end if
	f = f and &hBF	
end sub

sub mov_pbc_a()
	a=read_byte(bc)
end sub

sub mov_pde_a()
	a=read_byte(de)
end sub

sub mov_a_pde()
	write_byte(de,a)
end sub

sub cpl()
	a=not a
	f=f or &h60
end sub

sub scf()
	set_carry()
	f = f and &h9F
end sub

sub ccf()
	if (f and &h10) > 0 then
		f = f and &hEF
	else
		set_carry()
	end if
	f = f and &h9F
end sub

sub mov_a_b()
	b=a
end sub

sub mov_b_b()
	b=b
end sub

sub mov_c_b()
	b=c
end sub

sub mov_d_b()
	b=d
end sub

sub mov_e_b()
	b=e
end sub

sub mov_h_b()
	b=h
end sub

sub mov_l_b()
	b=l
end sub

sub mov_phl_b()
	b=read_byte(hl)
end sub

sub mov_a_c()
	c=a
end sub

sub mov_b_c()
	c=b
end sub

sub mov_c_c()
	c=c
end sub

sub mov_d_c()
	c=d
end sub

sub mov_e_c()
	c=e
end sub

sub mov_h_c()
	c=h
end sub

sub mov_l_c()
	c=l
end sub

sub mov_phl_c()
	c=read_byte(hl)
end sub

sub mov_a_d()
	d=a
end sub

sub mov_b_d()
	d=b
end sub

sub mov_c_d()
	d=c
end sub

sub mov_d_d()
	d=d
end sub

sub mov_e_d()
	d=e
end sub

sub mov_h_d()
	d=h
end sub

sub mov_l_d()
	d=l
end sub

sub mov_phl_d()
	d=read_byte(hl)
end sub

sub mov_a_e()
	e=a
end sub

sub mov_b_e()
	e=b
end sub

sub mov_c_e()
	e=c
end sub

sub mov_d_e()
	e=d
end sub

sub mov_e_e()
	e=e
end sub

sub mov_h_e()
	e=h
end sub

sub mov_l_e()
	e=l
end sub

sub mov_phl_e()
	e=read_byte(hl)
end sub

sub mov_a_h()
	h=a
end sub

sub mov_b_h()
	h=b
end sub

sub mov_c_h()
	h=c
end sub

sub mov_d_h()
	h=d
end sub

sub mov_e_h()
	h=e
end sub

sub mov_h_h()
	h=h
end sub

sub mov_l_h()
	h=l
end sub

sub mov_phl_h()
	h=read_byte(hl)
end sub

sub mov_a_l()
	l=a
end sub

sub mov_b_l()
	l=b
end sub

sub mov_c_l()
	l=c
end sub

sub mov_d_l()
	l=d
end sub

sub mov_e_l()
	l=e
end sub

sub mov_h_l()
	l=h
end sub

sub mov_l_l()
	l=l
end sub

sub mov_phl_l()
	l=read_byte(hl)
end sub

sub mov_a_a8()
	write_byte(&hFF00+read_byte(pc),a)
end sub

sub mov_a_a8c()
	write_byte(&hFF00+c,a)
end sub

sub mov_a8_a()
	a=read_byte(&hFF00+read_byte(pc))
end sub

sub mov_a8c_a()
	a=read_byte(&hFF00+c)
end sub

sub mov_a_a()
	a=a
end sub

sub mov_b_a()
	a=b
end sub

sub mov_c_a()
	a=c
end sub

sub mov_d_a()
	a=d
end sub

sub mov_e_a()
	a=e
end sub

sub mov_h_a()
	a=h
end sub

sub mov_l_a()
	a=l
end sub

sub mov_phl_a()
	a=read_byte(hl) 
end sub

sub mov_a_phl()
	write_byte(hl,a)
end sub

sub mov_b_phl()
	write_byte(hl,b)
end sub

sub mov_c_phl()
	write_byte(hl,c) 
end sub

sub mov_d_phl()
	write_byte(hl,d)
end sub

sub mov_e_phl()
	write_byte(hl,e)
end sub

sub mov_h_phl()
	write_byte(hl,h)
end sub

sub mov_l_phl()
	write_byte(hl,l)
end sub

sub add_i8_a()
	local int32 value = a + read_byte(pc)
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (read_byte(pc) and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub adc_i8_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = read_byte(pc)
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub sub_i8_a()	
	f=&h40
	local int32 value = a - read_byte(pc)
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sbb_i8_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - read_byte(pc) - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((read_byte(pc) and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub and_i8_a()
	a=a and read_byte(pc)
	f=&h20
	if a = 0 then set_zero()
end sub

sub xor_i8_a()
	a=a xor read_byte(pc)
	f=0
	if a = 0 then set_zero()
end sub

sub or_i8_a()
	a=a or read_byte(pc)
	f=0
	if a = 0 then set_zero()
end sub

sub cmp_i8_a()
	local int32 value = a - read_byte(pc)
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub add_b_a()
	local int32 value = a + b
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (b and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_c_a()
	local int32 value = a + c
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (c and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_d_a()
	local int32 value = a + d
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (d and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_e_a()
	local int32 value = a + e
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (e and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_h_a()
	local int32 value = a + h
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (h and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_l_a()
	local int32 value = a + l
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (l and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_phl_a()
	local int32 value = a + read_byte(hl)
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (read_byte(hl) and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub add_a_a()
	local int32 value = a + a
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (a and &h0F)) and &h10) = &h10 then f = f or &h20
	a = value 
end sub

sub adc_b_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = b
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_c_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = c
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_d_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = d
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_e_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = e
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_h_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = h
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_l_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = l
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_phl_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = read_byte(hl)
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub adc_a_a()
	local int32 fc, value, add
	if (f and &h10) > 0 then fc = 1
	add = a
	value = a + add + fc
	f = 0
	if (value and &hFF) = 0 then set_zero()
	if (value - &hFF) > 0 then set_carry()
	if (((a and &h0F) + (add and &h0F) + fc) and &h10) = &h10 then f = f or &h20
	a = value
end sub

sub sub_b_a()
	f=&h40
	local int32 value = a - b
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_c_a()
	f=&h40
	local int32 value = a - c
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_d_a()
	f=&h40
	local int32 value = a - d
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_e_a()
	f=&h40
	local int32 value = a - e
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_h_a()
	f=&h40
	local int32 value = a - h
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_l_a()
	f=&h40
	local int32 value = a - l
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_phl_a()
	f=&h40
	local int32 value = a - read_byte(hl)
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sub_a_a()
	f=&h40
	local int32 value = a - a
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
	a = value
end sub

sub sbb_b_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - b - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((b and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_c_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - c - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((c and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_d_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - d - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((d and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_e_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - e - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((e and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_h_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - h - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((h and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_l_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - l - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((l and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_phl_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - read_byte(hl) - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((read_byte(hl) and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub sbb_a_a()
	local int32 flag_c, value
	if (f and &h10) > 0 then flag_c = 1
	value = a - a - flag_c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value<0 then set_carry()
	if (a and &h0F) < ((a and &h0F) + flag_c) then f = f or &h20
	a = value
end sub

sub and_b_a()
	a=a and b
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_c_a()
	a=a and c
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_d_a()
	a=a and d
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_e_a()
	a=a and e
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_h_a()
	a=a and h
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_l_a()
	a=a and l
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_phl_a()
	a=a and read_byte(hl)
	f=&h20
	if a = 0 then set_zero()
end sub

sub and_a_a()
	a=a and a
	f=&h20
	if a = 0 then set_zero()
end sub

sub xor_b_a()
	a=a xor b
	f=0
	if a = 0 then set_zero()
end sub

sub xor_c_a()
	a=a xor c
	f=0
	if a = 0 then set_zero()
end sub

sub xor_d_a()
	a=a xor d
	f=0
	if a = 0 then set_zero()
end sub

sub xor_e_a()
	a=a xor e
	f=0
	if a = 0 then set_zero()
end sub

sub xor_h_a()
	a=a xor h
	f=0
	if a = 0 then set_zero()
end sub

sub xor_l_a()
	a=a xor l
	f=0
	if a = 0 then set_zero()
end sub

sub xor_phl_a()
	a=a xor read_byte(hl)
	f=0
	if a = 0 then set_zero()
end sub

sub xor_a_a()
	a=a xor a
	f=0
	if a = 0 then set_zero()
end sub

sub or_b_a()
	a=a or b
	f=0
	if a = 0 then set_zero()
end sub

sub or_c_a()
	a=a or c
	f=0
	if a = 0 then set_zero()
end sub

sub or_d_a()
	a=a or d
	f=0
	if a = 0 then set_zero()
end sub

sub or_e_a()
	a=a or e
	f=0
	if a = 0 then set_zero()
end sub

sub or_h_a()
	a=a or h
	f=0
	if a = 0 then set_zero()
end sub

sub or_l_a()
	a=a or l
	f=0
	if a = 0 then set_zero()
end sub

sub or_phl_a()
	a=a or read_byte(hl)
	f=0
	if a = 0 then set_zero()
end sub

sub or_a_a()
	a=a or a
	f=0
	if a = 0 then set_zero()
end sub

sub cmp_b_a()
	local int32 value = a - b
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_c_a()
	local int32 value = a - c
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_d_a()
	local int32 value = a - d
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_e_a()
	local int32 value = a - e
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_h_a()
	local int32 value = a - h
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_l_a()
	local int32 value = a - l
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_phl_a()
	local int32 value = a - read_byte(hl)
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cmp_a_a()
	local int32 value = a - a
	f = &h40
	if (value and &hFF) = 0 then set_zero()
	if value < 0 then set_carry()
	if (a and &h0F) < (value and &h0F) then f = f or &h20
end sub

sub cb_bit_ops()
	select case as const read_byte(pc)
		case &h00		'RLC
			local int32 add
			f=0
			if (b and &h80) > 0 then
				add = 1
				f = &h10
			end if
			b = (b shl 1) + add
			if b = 0 then set_zero()
		case &h01
			local int32 add
			f=0
			if (c and &h80) > 0 then
				add = 1
				f = &h10
			end if
			c = (c shl 1) + add
			if c = 0 then set_zero()
		case &h02
			local int32 add
			f=0
			if (d and &h80) > 0 then
				add = 1
				f = &h10
			end if
			d = (d shl 1) + add
			if d = 0 then set_zero()
		case &h03
			local int32 add
			f=0
			if (e and &h80) > 0 then
				add = 1
				f = &h10
			end if
			e = (e shl 1) + add
			if e = 0 then set_zero()
		case &h04
			local int32 add
			f=0
			if (h and &h80) > 0 then
				add = 1
				f = &h10
			end if
			h = (h shl 1) + add
			if h = 0 then set_zero()
		case &h05
			local int32 add
			f=0
			if (l and &h80) > 0 then
				add = 1
				f = &h10
			end if
			l = (l shl 1) + add
			if l = 0 then set_zero()
		case &h06
			local int32 add
			f=0
			if (read_byte(hl) and &h80) > 0 then
				add = 1
				f = &h10
			end if
			write_byte(hl, (read_byte(hl) shl 1) + add)
			zeit = 4
			if read_byte(hl) = 0 then set_zero()
		case &h07
			local int32 add
			f=0
			if (a and &h80) > 0 then
				add = 1
				f = &h10
			end if
			a = (a shl 1) + add
			if a = 0 then set_zero()
			
		case &h08		'RRC
			local int32 add
			f=0
			if (b and 1) > 0 then
				add = &h80
				f = &h10
			end if
			b = (b shr 1) + add
			if b = 0 then set_zero()
		case &h09
			local int32 add
			f=0
			if (c and 1) > 0 then
				add = &h80
				f = &h10
			end if
			c = (c shr 1) + add
			if c = 0 then set_zero()
		case &h0A
			local int32 add
			f=0
			if (d and 1) > 0 then
				add = &h80
				f = &h10
			end if
			d = (d shr 1) + add
			if d = 0 then set_zero()
		case &h0B
			local int32 add
			f=0
			if (e and 1) > 0 then
				add = &h80
				f = &h10
			end if
			e = (e shr 1) + add
			if e = 0 then set_zero()
		case &h0C
			local int32 add
			f=0
			if (h and 1) > 0 then
				add = &h80
				f = &h10
			end if
			h = (h shr 1) + add
			if h = 0 then set_zero()
		case &h0D
			local int32 add
			f=0
			if (l and 1) > 0 then
				add = &h80
				f = &h10
			end if
			l = (l shr 1) + add
			if l = 0 then set_zero()
		case &h0E
			local int32 add
			f=0
			if (read_byte(hl) and 1) > 0 then
				add = &h80
				f = &h10
			end if
			write_byte(hl, (read_byte(hl) shr 1) + add)
			if read_byte(hl) = 0 then set_zero()
			zeit = 4
		case &h0F
			local int32 add
			f=0
			if (a and 1) > 0 then
				add = &h80
				f = &h10
			end if
			a = (a shr 1) + add
			if a = 0 then set_zero()
			
		case &h10		'RL
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (b and &h80) > 10 then co = &h10
			b = (b shl 1) + ci
			f = 0
			if b = 0 then set_zero()
			f = f or co
		case &h11		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (c and &h80) > 10 then co = &h10
			c = (c shl 1) + ci
			f = 0
			if c = 0 then set_zero()
			f = f or co
		case &h12		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (d and &h80) > 10 then co = &h10
			d = (d shl 1) + ci
			f = 0
			if d = 0 then set_zero()
			f = f or co
		case &h13		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (e and &h80) > 10 then co = &h10
			e = (e shl 1) + ci
			f = 0
			if e = 0 then set_zero()
			f = f or co
		case &h14		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (h and &h80) > 10 then co = &h10
			h = (h shl 1) + ci
			f = 0
			if h = 0 then set_zero()
			f = f or co
		case &h15		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (l and &h80) > 10 then co = &h10
			l = (l shl 1) + ci
			f = 0
			if l = 0 then set_zero()
			f = f or co
		case &h16		
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (read_byte(hl) and &h80) > 10 then co = &h10
			write_byte(hl, (read_byte(hl) shl 1) + ci)
			f = 0
			if read_byte(hl) = 0 then set_zero()
			f = f or co
			zeit = 4
		case &h17
			local int32 ci, co
			if (f and &h10) > 0 then ci = 1
			if (a and &h80) > 10 then co = &h10
			a = (a shl 1) + ci
			f = 0
			if a = 0 then set_zero()
			f = f or co
			
		case &h18		'RR	a
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (b and &h01) > 0 then co = &h10
			b = ((b shr 1) + ci) 
			f = 0
			if b = 0 then set_zero()
			f = f or co
		case &h19	
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (c and &h01) > 0 then co = &h10
			c = ((c shr 1) + ci) 
			f = 0
			if c = 0 then set_zero()
			f = f or co
		case &h1A		
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (d and &h01) > 0 then co = &h10
			d = ((d shr 1) + ci) 
			f = 0
			if d = 0 then set_zero()
			f = f or co
		case &h1B		
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (e and &h01) > 0 then co = &h10
			e = ((e shr 1) + ci) 
			f = 0
			if e = 0 then set_zero()
			f = f or co
		case &h1C		
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (h and &h01) > 0 then co = &h10
			h = ((h shr 1) + ci) 
			f = 0
			if h = 0 then set_zero()
			f = f or co
		case &h1D		
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (l and &h01) > 0 then co = &h10
			l = ((l shr 1) + ci) 
			f = 0
			if l = 0 then set_zero()
			f = f or co
		case &h1E		
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (read_byte(hl) and &h01) > 0 then co = &h10
			write_byte(hl, (read_byte(hl) shr 1) + ci)
			f = 0
			if read_byte(hl) = 0 then set_zero()
			f = f or co
			zeit = 4
		case &h1F
			local uint8 ci, co
			if (f and &h10) > 0 then ci = &h80
			if (a and &h01) > 0 then co = &h10
			a = ((a shr 1) + ci) 
			f = 0
			if a = 0 then set_zero()
			f = f or co
			
		case &h20		'SLA
			f=0
			if (b and &h80)>0 then set_carry()
			b = b shl 1
			if b = 0 then set_zero()
		case &h21
			f=0
			if (c and &h80)>0 then set_carry()
			c = c shl 1
			if c = 0 then set_zero()
		case &h22
			f=0
			if (d and &h80)>0 then set_carry()
			d = d shl 1
			if d = 0 then set_zero()
		case &h23
			f=0
			if (e and &h80)>0 then set_carry()
			e = e shl 1
			if e = 0 then set_zero()
		case &h24
			f=0
			if (h and &h80)>0 then set_carry()
			h = h shl 1
			if h = 0 then set_zero()
		case &h25
			f=0
			if (l and &h80)>0 then set_carry()
			l = l shl 1
			if l = 0 then set_zero()
		case &h26
			f=0
			if (read_byte(hl) and &h80)>0 then set_carry()
			write_byte(hl, read_byte(hl) shl 1)
			if read_byte(hl) = 0 then set_zero()
			zeit = 4
		case &h27
			f=0
			if (a and &h80)>0 then set_carry()
			a = a shl 1
			if a = 0 then set_zero()
		
		case &h28		'SRA
			f=0
			local uint8 add = b and &h80
			local uint8 carry = b and &h01
			if carry > 0  then set_carry()
			b = (b shr 1) + add
			if b = 0 then set_zero()
		case &h29
			f=0
			local uint8 add = c and &h80
			local uint8 carry = c and &h01
			if carry > 0  then set_carry()
			c = (c shr 1) + add
			if c = 0 then set_zero()
		case &h2A
			f=0
			local uint8 add = d and &h80
			local uint8 carry = d and &h01
			if carry > 0  then set_carry()
			d = (d shr 1) + add
			if d = 0 then set_zero()
		case &h2B
			f=0
			local uint8 add = e and &h80
			local uint8 carry = e and &h01
			if carry > 0  then set_carry()
			e = (e shr 1) + add
			if e = 0 then set_zero()
		case &h2C
			f=0
			local uint8 add = h and &h80
			local uint8 carry = h and &h01
			if carry > 0  then set_carry()
			h = (h shr 1) + add
			if h = 0 then set_zero()
		case &h2D
			f=0
			local uint8 add = l and &h80
			local uint8 carry = l and &h01
			if carry > 0  then set_carry()
			l = (l shr 1) + add
			if l = 0 then set_zero()
		case &h2E
			f=0
			local uint8 add = read_byte(hl) and &h80
			local uint8 carry = read_byte(hl) and &h01
			if carry > 0  then set_carry()
			write_byte(hl, (read_byte(hl) shr 1) + add)
			if read_byte(hl) = 0 then set_zero()
			zeit = 4
		case &h2F
			f=0
			local uint8 add = a and &h80
			local uint8 carry = a and &h01
			if carry > 0  then set_carry()
			a = (a shr 1) + add
			if a = 0 then set_zero()
			
		case &h30		'SWAP
			local int32 value = b and &h0F
			b = b shr 4 or (value shl 4)
			f = 0
			if b = 0 then set_zero()
		case &h31		
			local int32 value = c and &h0F
			c = c shr 4 or (value shl 4)
			f = 0
			if c = 0 then set_zero()	
		case &h32		
			local int32 value = d and &h0F
			d = d shr 4 or (value shl 4)
			f = 0
			if d = 0 then set_zero()	
		case &h33		
			local int32 value = e and &h0F
			e = e shr 4 or (value shl 4)
			f = 0
			if e = 0 then set_zero()
		case &h34		
			local int32 value = h and &h0F
			h = h shr 4 or (value shl 4)
			f = 0
			if h = 0 then set_zero()
		case &h35		
			local int32 value = l and &h0F
			l = l shr 4 or (value shl 4)
			f = 0
			if l = 0 then set_zero()
		case &h36		
			local int32 value = read_byte(hl) and &h0F
			write_byte(hl, read_byte(hl) shr 4 or (value shl 4))
			f = 0
			if read_byte(hl) = 0 then set_zero()
			zeit = 4
		case &h37		
			local int32 value = a and &h0F
			a = a shr 4 or (value shl 4)
			f = 0
			if a = 0 then set_zero()
			
		case &h38		'SRL
			f=0
			local uint8 carry = b and &h01
			if carry > 0  then set_carry()
			b = b shr 1
			if b = 0 then set_zero()
		case &h39
			f=0
			local uint8 carry = c and &h01
			if carry > 0  then set_carry()
			c = c shr 1
			if c = 0 then set_zero()
		case &h3A
			f=0
			local uint8 carry = d and &h01
			if carry > 0  then set_carry()
			d = d shr 1
			if d = 0 then set_zero()
		case &h3B
			f=0
			local uint8 carry = e and &h01
			if carry > 0  then set_carry()
			e = e shr 1
			if e = 0 then set_zero()
		case &h3C
			f=0
			local uint8 carry = h and &h01
			if carry > 0  then set_carry()
			h = h shr 1
			if h = 0 then set_zero()
		case &h3D
			f=0
			local uint8 carry = l and &h01
			if carry > 0  then set_carry()
			l = l shr 1
			if l = 0 then set_zero()
		case &h3E
			f=0
			local uint8 carry = read_byte(hl) and &h01
			if carry > 0  then set_carry()
			'speicher(hl) = speicher(hl) shr 1
			write_byte(hl, read_byte(hl) shr 1)
			if read_byte(hl) = 0 then set_zero()
			zeit = 4
		case &h3F
			f=0
			local uint8 carry = a and &h01
			if carry > 0  then set_carry()
			a = a shr 1
			if a = 0 then set_zero()
			
		case &h40:f=f and &h1F or &h20:if (b and &h01)=0 then set_zero()	'BIT 0
		case &h41:f=f and &h1F or &h20:if (c and &h01)=0 then set_zero()
		case &h42:f=f and &h1F or &h20:if (d and &h01)=0 then set_zero()
		case &h43:f=f and &h1F or &h20:if (e and &h01)=0 then set_zero()
		case &h44:f=f and &h1F or &h20:if (h and &h01)=0 then set_zero()
		case &h45:f=f and &h1F or &h20:if (l and &h01)=0 then set_zero()
		case &h46:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h01)=0 then set_zero()
		case &h47:f=f and &h1F or &h20:if (a and &h01)=0 then set_zero()
		case &h48:f=f and &h1F or &h20:if (b and &h02)=0 then set_zero()	'BIT 1
		case &h49:f=f and &h1F or &h20:if (c and &h02)=0 then set_zero()
		case &h4A:f=f and &h1F or &h20:if (d and &h02)=0 then set_zero()
		case &h4B:f=f and &h1F or &h20:if (e and &h02)=0 then set_zero()
		case &h4C:f=f and &h1F or &h20:if (h and &h02)=0 then set_zero()
		case &h4D:f=f and &h1F or &h20:if (l and &h02)=0 then set_zero()
		case &h4E:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h02)=0 then set_zero()
		case &h4F:f=f and &h1F or &h20:if (a and &h02)=0 then set_zero()
		case &h50:f=f and &h1F or &h20:if (b and &h04)=0 then set_zero()	'BIT 2
		case &h51:f=f and &h1F or &h20:if (c and &h04)=0 then set_zero()
		case &h52:f=f and &h1F or &h20:if (d and &h04)=0 then set_zero()
		case &h53:f=f and &h1F or &h20:if (e and &h04)=0 then set_zero()
		case &h54:f=f and &h1F or &h20:if (h and &h04)=0 then set_zero()
		case &h55:f=f and &h1F or &h20:if (l and &h04)=0 then set_zero()
		case &h56:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h04)=0 then set_zero()
		case &h57:f=f and &h1F or &h20:if (a and &h04)=0 then set_zero()
		case &h58:f=f and &h1F or &h20:if (b and &h08)=0 then set_zero()	'BIT 3
		case &h59:f=f and &h1F or &h20:if (c and &h08)=0 then set_zero()
		case &h5A:f=f and &h1F or &h20:if (d and &h08)=0 then set_zero()
		case &h5B:f=f and &h1F or &h20:if (e and &h08)=0 then set_zero()
		case &h5C:f=f and &h1F or &h20:if (h and &h08)=0 then set_zero()
		case &h5D:f=f and &h1F or &h20:if (l and &h08)=0 then set_zero()
		case &h5E:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h08)=0 then set_zero()
		case &h5F:f=f and &h1F or &h20:if (a and &h08)=0 then set_zero()
		case &h60:f=f and &h1F or &h20:if (b and &h10)=0 then set_zero()	'BIT 4
		case &h61:f=f and &h1F or &h20:if (c and &h10)=0 then set_zero()
		case &h62:f=f and &h1F or &h20:if (d and &h10)=0 then set_zero()
		case &h63:f=f and &h1F or &h20:if (e and &h10)=0 then set_zero()
		case &h64:f=f and &h1F or &h20:if (h and &h10)=0 then set_zero()
		case &h65:f=f and &h1F or &h20:if (l and &h10)=0 then set_zero()
		case &h66:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h10)=0 then set_zero()
		case &h67:f=f and &h1F or &h20:if (a and &h10)=0 then set_zero()
		case &h68:f=f and &h1F or &h20:if (b and &h20)=0 then set_zero()	'BIT 5
		case &h69:f=f and &h1F or &h20:if (c and &h20)=0 then set_zero()
		case &h6A:f=f and &h1F or &h20:if (d and &h20)=0 then set_zero()
		case &h6B:f=f and &h1F or &h20:if (e and &h20)=0 then set_zero()
		case &h6C:f=f and &h1F or &h20:if (h and &h20)=0 then set_zero()
		case &h6D:f=f and &h1F or &h20:if (l and &h20)=0 then set_zero()
		case &h6E:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h20)=0 then set_zero()
		case &h6F:f=f and &h1F or &h20:if (a and &h20)=0 then set_zero()
		case &h70:f=f and &h1F or &h20:if (b and &h40)=0 then set_zero()	'BIT 6
		case &h71:f=f and &h1F or &h20:if (c and &h40)=0 then set_zero()
		case &h72:f=f and &h1F or &h20:if (d and &h40)=0 then set_zero()
		case &h73:f=f and &h1F or &h20:if (e and &h40)=0 then set_zero()
		case &h74:f=f and &h1F or &h20:if (h and &h40)=0 then set_zero()
		case &h75:f=f and &h1F or &h20:if (l and &h40)=0 then set_zero()
		case &h76:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h40)=0 then set_zero()
		case &h77:f=f and &h1F or &h20:if (a and &h40)=0 then set_zero()
		case &h78:f=f and &h1F or &h20:if (b and &h80)=0 then set_zero()	'BIT 7
		case &h79:f=f and &h1F or &h20:if (c and &h80)=0 then set_zero()
		case &h7A:f=f and &h1F or &h20:if (d and &h80)=0 then set_zero()
		case &h7B:f=f and &h1F or &h20:if (e and &h80)=0 then set_zero()
		case &h7C:f=f and &h1F or &h20:if (h and &h80)=0 then set_zero()
		case &h7D:f=f and &h1F or &h20:if (l and &h80)=0 then set_zero()
		case &h7E:f=f and &h1F or &h20:zeit = 3:if (read_byte(hl) and &h80)=0 then set_zero()
		case &h7F:f=f and &h1F or &h20:if (a and &h80)=0 then set_zero()
			
		case &h80:b and= &hFE	'RES 0
		case &h81:c and= &hFE
		case &h82:d and= &hFE
		case &h83:e and= &hFE
		case &h84:h and= &hFE
		case &h85:l and= &hFE
		case &h86:write_byte(hl, read_byte(hl) and &hFE):zeit = 4 
		case &h87:a and= &hFE		
		case &h88:b and= &hFD	'RES 1
		case &h89:c and= &hFD
		case &h8A:d and= &hFD
		case &h8B:e and= &hFD
		case &h8C:h and= &hFD
		case &h8D:l and= &hFD
		case &h8E:write_byte(hl, read_byte(hl) and &hFD):zeit = 4
		case &h8F:a and= &hFD		
		case &h90:b and= &hFB	'RES 2
		case &h91:c and= &hFB
		case &h92:d and= &hFB
		case &h93:e and= &hFB
		case &h94:h and= &hFB
		case &h95:l and= &hFB
		case &h96:write_byte(hl, read_byte(hl) and &hFB):zeit = 4
		case &h97:a and= &hFB			   
		case &h98:b and= &hF7	'RES 3
		case &h99:c and= &hF7
		case &h9A:d and= &hF7
		case &h9B:e and= &hF7
		case &h9C:h and= &hF7
		case &h9D:l and= &hF7
		case &h9E:write_byte(hl, read_byte(hl) and &hF7):zeit = 4
		case &h9F:a and= &hF7		
		case &hA0:b and= &hEF	'RES 4
		case &hA1:c and= &hEF
		case &hA2:d and= &hEF
		case &hA3:e and= &hEF
		case &hA4:h and= &hEF
		case &hA5:l and= &hEF
		case &hA6:write_byte(hl, read_byte(hl) and &hEF):zeit = 4
		case &hA7:a and= &hEF			   
		case &hA8:b and= &hDF	'RES 5
		case &hA9:c and= &hDF
		case &hAA:d and= &hDF
		case &hAB:e and= &hDF
		case &hAC:h and= &hDF
		case &hAD:l and= &hDF
		case &hAE:write_byte(hl, read_byte(hl) and &hDF):zeit = 4
		case &hAF:a and= &hDF		
		case &hB0:b and= &hBF	'RES 6
		case &hB1:c and= &hBF
		case &hB2:d and= &hBF
		case &hB3:e and= &hBF
		case &hB4:h and= &hBF
		case &hB5:l and= &hBF
		case &hB6:write_byte(hl, read_byte(hl) and &hBF):zeit = 4
		case &hB7:a and= &hBF			   
		case &hB8:b and= &h7F	'RES 7
		case &hB9:c and= &h7F
		case &hBA:d and= &h7F
		case &hBB:e and= &h7F
		case &hBC:h and= &h7F
		case &hBD:l and= &h7F
		case &hBE:write_byte(hl, read_byte(hl) and &h7F):zeit = 4
		case &hBF:a and= &h7F
		
		case &hC0:b or=&h01		'SET 0
		case &hC1:c or=&h01	
		case &hC2:d or=&h01	
		case &hC3:e or=&h01	
		case &hC4:h or=&h01	
		case &hC5:l or=&h01	
		case &hC6:write_byte(hl, read_byte(hl) or &h01):zeit = 4
		case &hC7:a or=&h01	
		case &hC8:b or=&h02		'SET 1
		case &hC9:c or=&h02	
		case &hCA:d or=&h02	
		case &hCB:e or=&h02	
		case &hCC:h or=&h02	
		case &hCD:l or=&h02	
		case &hCE:write_byte(hl, read_byte(hl) or &h02):zeit = 4
		case &hCF:a or=&h02
		case &hD0:b or=&h04		'SET 2
		case &hD1:c or=&h04	
		case &hD2:d or=&h04	
		case &hD3:e or=&h04	
		case &hD4:h or=&h04	
		case &hD5:l or=&h04	
		case &hD6:write_byte(hl, read_byte(hl) or &h04):zeit = 4
		case &hD7:a or=&h04
		case &hD8:b or=&h08		'SET 3
		case &hD9:c or=&h08	
		case &hDA:d or=&h08	
		case &hDB:e or=&h08	
		case &hDC:h or=&h08	
		case &hDD:l or=&h08	
		case &hDE:write_byte(hl, read_byte(hl) or &h08):zeit = 4
		case &hDF:a or=&h08
		case &hE0:b or=&h10		'SET 4
		case &hE1:c or=&h10	
		case &hE2:d or=&h10	
		case &hE3:e or=&h10	
		case &hE4:h or=&h10	
		case &hE5:l or=&h10	
		case &hE6:write_byte(hl, read_byte(hl) or &h10):zeit = 4
		case &hE7:a or=&h10
		case &hE8:b or=&h20		'SET 5
		case &hE9:c or=&h20	
		case &hEA:d or=&h20	
		case &hEB:e or=&h20	
		case &hEC:h or=&h20	
		case &hED:l or=&h20	
		case &hEE:write_byte(hl, read_byte(hl) or &h20):zeit = 4
		case &hEF:a or=&h20
		case &hF0:b or=&h40		'SET 6
		case &hF1:c or=&h40	
		case &hF2:d or=&h40	
		case &hF3:e or=&h40	
		case &hF4:h or=&h40	
		case &hF5:l or=&h40	
		case &hF6:write_byte(hl, read_byte(hl) or &h40):zeit = 4
		case &hF7:a or=&h40	
		case &hF8:b or=&h80		'SET 7
		case &hF9:c or=&h80	
		case &hFA:d or=&h80	
		case &hFB:e or=&h80	
		case &hFC:h or=&h80	
		case &hFD:l or=&h80	
		case &hFE:write_byte(hl, read_byte(hl) or &h80):zeit = 4
		case &hFF:a or=&h80
	end select
end sub

sub daa()
	local int32 value = a		
	if (f and &h40) = 0 then
		if (f and &h20) > 0 or (value and &h0F) > 9 then value += &h06
		if (f and &h10) > 0 or value > &h9F then value += &h60
	else
		if (f and &h20) > 0 then value = (value - &h06) and &hFF
		if (f and &h10) > 0 then value = value - &h60
	end if
	
	f = f and &h5F
	if (value and &h100) = &h100 then set_carry()
	
	value = value and &hFF
	if value = 0 then
		set_zero()
	else
		clear_zero()
	end if
	
	a = value
	
	schreibe_log("[WARNUNG] DAA")
end sub
