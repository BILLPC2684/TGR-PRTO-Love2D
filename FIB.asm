'FIB program

'allowcating simple CPU vars
load a,0x01   'a
load b,0x00   'b
load c,0xB51F 'c

'program
-vjmp loop 'set var-jump "loop"

add a,b 'a = a + b
print a

add b,a 'b = b + a
print b

if a > c
-halt 'halts CPU

if b > c
-halt 'halts CPU

vjmp loop 'goto var-jump "loop"
-end 'end of script