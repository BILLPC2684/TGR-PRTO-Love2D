ROM = {						--vPC line for command exec.
 0x01,0x01,0x00,0x00,0x01,	--00 LOAD A,0x0001
 0x01,0x01,0x01,0x00,0x00,	--05 LOAD B,0x0000
 0x01,0x01,0x02,0xB5,0x1F,	--10 LOAD C,0xB51F
 
 0x02,0x00,0x01,			--15 ADD A,B
 0x0C,0x00,					--18 PRINT A
 0x1F,0x02,0x00,0x02,0x25,	--20 CMP(IF) A == C,37
 
 0x02,0x01,0x00,			--25 ADD B,A
 0x0C,0x01,					--28 PRINT B
 0x1F,0x02,0x01,0x02,0x25,	--30 CMP(IF) B == C,37
 
 0x0B,0x0F,					--35 JMP 15
 
 0x0D,						--37 HALT
 --Length: 38
}