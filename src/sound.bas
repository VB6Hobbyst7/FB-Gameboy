'#include once "bass.bi"

'BASS_Init(-1, 44100, 0, 0, 0)

'global as HSAMPLE sample_kanal_1, sample_kanal_2, sample_kanal_3, sample_kanal_4
'global as HCHANNEL buffer_kanal_1, buffer_kanal_2, buffer_kanal_3, buffer_kanal_4

'buffer_kanal_1 = BASS_SampleGetChannel(sample_kanal_1, 0)
'buffer_kanal_2 = BASS_SampleGetChannel(sample_kanal_2, 0)
'buffer_kanal_3 = BASS_SampleGetChannel(sample_kanal_3, 0)
'buffer_kanal_4 = BASS_SampleGetChannel(sample_kanal_4, 0)

sub kanal_1()
	
end sub

sub kanal_2()

end sub

sub kanal_3()
	
end sub

sub kanal_4()

end sub

sub sound()
	if (speicher(M_NR52) and &h80) = 0 then exit sub	'Wenn Sound nicht benutzt wird
	
end sub
