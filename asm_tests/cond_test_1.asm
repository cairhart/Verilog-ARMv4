MOV R0, #1
MOV R1, #1
MOV R3, #13
MOV R4, #7
CMP R0, #0 ; compare a with 0
CMPNE R1, #1 ; if a is not 0, compare b to 1
ADDEQ R2, R3, R4 ; if either was true c = d + e
MRS R0, CPSR
