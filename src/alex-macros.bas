#undef local
#undef pointer
#undef class
#define class type
#define local dim
#define global dim shared

#define int64 as integer
#define uint64 as uinteger
#define int32 as long
#define uint32 as ulong
#define int16 as short
#define uint16 as ushort
#define int8 as byte
#define uint8 as ubyte
#define char as ubyte
#define varchar as string
#define float as double
#define bool as boolean
#define imgptr as any ptr
#define threadptr as any ptr
#define ui as GTKWidget
#define gptr as gpointer

#define in(start,end) as integer=start to end

#define rgb2bgr(in) rgb(in and 255,in shr 8 and 255,in shr 16 and 255)

#define rgba_r(c) (cuint(c) shr 16 and 255)
#define rgba_g(c) (cuint(c) shr  8 and 255)
#define rgba_b(c) (cuint(c)        and 255)
#define rgba_a(c) (cuint(c) shr 24        )
#define lodword(in) cast(uinteger,in) shl 32 shr 32

global uint32 __of

class t_Stack
	private:
		varchar __stack(any)
		int32 __stack_pointer
		int32 __real_ubound
	
	public:
		declare sub push(topush varchar)
		declare function pop()varchar
		declare function popredo()varchar
		declare sub reset()
		declare sub erase()
		declare sub output()
		declare property get_pointer()int32
		declare property get_ubound()int32
end class

sub t_Stack.push(topush varchar)
	if __stack_pointer>ubound(__stack) then redim preserve __stack(0 to ubound(__stack)+64)
	if __stack_pointer=256 then
		for i as integer=1 to __stack_pointer-1
			__stack(i-1) = __stack(i)
		next
		__stack_pointer-=1
		__real_ubound-=1
	end if
	__stack(__stack_pointer)=topush
	__real_ubound+=1
	__stack_pointer+=1
end sub

function t_Stack.pop()varchar
	if __stack_pointer<1 then return ""
	__stack_pointer-=1
	return __stack(__stack_pointer)
end function

function t_Stack.popredo()varchar
	local varchar ret
	ret=__stack(__stack_pointer)
	__stack_pointer+=1
	return ret
end function

sub t_Stack.reset()
	__stack_pointer=__real_ubound
end sub

sub t_Stack.erase()
	__stack_pointer=0
	__real_ubound=0
	redim __stack(0)
end sub

sub t_Stack.output()
	for i in(0,__real_ubound-1)
		if __stack_pointer-1=i then print ">";
		print #__of,str(i)+": "+__stack(i)
	next
end sub

property t_Stack.get_pointer()int32
	return __stack_pointer
end property

property t_Stack.get_ubound()int32
	return __real_ubound
end property

global uint32 time_high, time_low
global uint64 start_time, end_time

#macro start_mess()
   asm
      "CPUID\n" _
      "RDTSC\n" _
      "mov %%edx, %0\n" _
      "mov %%eax, %1\n\t": "=r" (time_high), "=r" (time_low):: "%rax", "%rbx", "%rcx", "%rdx"
   end asm
   start_time = (culngint(time_high) shl 32) or time_low
#endmacro

#macro end_mess(strin)
   asm
      "RDTSCP\n" _
      "mov %%edx, %0\n" _
      "mov %%eax, %1\n" _
      "CPUID\n\t": "=r" (time_high), "=r" (time_low):: "%rax", "%rbx", "%rcx", "%rdx"
   end asm
   end_time = (culngint(time_high) shl 32) or time_low
   print strin;
   print end_time - start_time
#endmacro
