MOV R0, #1 ; Move zero to R0
MOV R3, #0 ;
ADD R3, R3, #1 ; Add one to the value of register 3
MOV R4, #0xffff ;
BIC R4, R4, #0xff00 ; Clear bits 8-15 of R8 and store in R9
MRS R0, CPSR
