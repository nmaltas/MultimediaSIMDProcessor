module Dependence 
(clk, Flush, Stall, PCi, PC,
CSEi, RAEi, RBEi, RCEi, RTEi, ImmediateEi, CSE, RAE, RBE, RCE, RTE, ImmediateE, ForwardE1, ForwardE2, ForwardE3, TagE0, TagE1, TagE2, TagE3, TagE4, TagE5, TagE6, TagE7,
CSERF, CSE1, CSE2, CSE3, CSE4, CSE5, CSE6, CSE7,
CSOi, RAOi, RBOi, RCOi, RTOi, ImmediateOi, CSO, RAO, RBO, RCO, RTO, ImmediateO, ForwardO1, ForwardO2, ForwardO3, TagO0, TagO1, TagO2, TagO3, TagO4, TagO5, TagO6, 
TagO7, CSORF, CSO1, CSO2, CSO3, CSO4, CSO5, CSO6, CSO7);

// INPUT SIGNALS
input logic clk, Flush;

input logic [0:6] RAEi;
input logic [0:6] RBEi;
input logic [0:6] RCEi;
input logic [0:6] RTEi;
input logic [0:31] ImmediateEi;
input logic [0:7] CSEi;

input logic [0:6] RAOi;
input logic [0:6] RBOi;
input logic [0:6] RCOi;
input logic [0:6] RTOi;
input logic [0:31] ImmediateOi;
input logic [0:7] CSOi;
input logic [0:31] PCi;

input logic [0:6] TagE0;
input logic [0:7] TagE1;
input logic [0:7] TagE2;
input logic [0:7] TagE3;
input logic [0:7] TagE4;
input logic [0:7] TagE5;
input logic [0:7] TagE6;
input logic [0:7] TagE7;

input logic [0:6] TagO0;
input logic [0:7] TagO1;
input logic [0:7] TagO2;
input logic [0:7] TagO3;
input logic [0:7] TagO4;
input logic [0:7] TagO5;
input logic [0:7] TagO6;
input logic [0:7] TagO7;

input logic [0:5] CSORF;
input logic [0:5] CSO1;
input logic [0:5] CSO2;
input logic [0:5] CSO3;
input logic [0:5] CSO4;
input logic [0:5] CSO5;
input logic [0:5] CSO6;
input logic [0:5] CSO7;

input logic [0:7] CSERF;
input logic [0:7] CSE1;
input logic [0:7] CSE2;
input logic [0:7] CSE3;
input logic [0:7] CSE4;
input logic [0:7] CSE5;
input logic [0:7] CSE6;
input logic [0:7] CSE7;

// OUTPUT SIGNALS
output logic Stall;
output logic [0:6] RAE;
output logic [0:6] RBE;
output logic [0:6] RCE;
output logic [0:6] RTE;
output logic [0:31] ImmediateE;
output logic [0:7] CSE;

output logic [0:6] RAO;
output logic [0:6] RBO;
output logic [0:6] RCO;
output logic [0:6] RTO;
output logic [0:31] ImmediateO;
output logic [0:7] CSO;
output logic [0:31] PC;

output logic [0:4] ForwardE1;
output logic [0:4] ForwardE2;
output logic [0:4] ForwardE3;
output logic [0:4] ForwardO1;
output logic [0:4] ForwardO2;
output logic [0:4] ForwardO3;

// INTERNAL SIGNALS
logic [0:4] ForwardE10;
logic [0:4] ForwardE20;
logic [0:4] ForwardE30;
logic [0:4] ForwardO10;
logic [0:4] ForwardO20;
logic [0:4] ForwardO30;



// DATAPATH MODULE
always_ff @(posedge clk) begin
if (Flush == 1) begin
	RAE <= 0;
	RBE <= 0;
	RCE <= 0;
	RTE <= 0;
	ImmediateE <= 0;
	CSE <= 8'b00000000;
	
	RAO <= 0;
	RBO <= 0;
	RCO <= 0;
	RTO <= 0;
	ImmediateO <= 0;
	CSO <= 8'b00000000;
	PC <= PC;
end
else begin
	if (Stall == 1) begin
		RAE <= 0;
		RBE <= 0;
		RCE <= 0;
		RTE <= 0;
		ImmediateE <= 0;
		CSE <= 8'b00000000;
		
		RAO <= 0;
		RBO <= 0;
		RCO <= 0;
		RTO <= 0;
		ImmediateO <= 0;
		CSO <= 8'b00000000;
		PC <= PCi;
	end
	else begin
		RAE <= RAEi;
		RBE <= RBEi;
		RCE <= RCEi;
		RTE <= RTEi;
		ImmediateE <= ImmediateEi;
		CSE <= CSEi;
	
		RAO <= RAOi;
		RBO <= RBOi;
		RCO <= RCOi;
		RTO <= RTOi;
		ImmediateO <= ImmediateOi;
		CSO <= CSOi;
		PC <= PCi;
	end
end
end

// STALL ASSERTION MODULE
always_comb begin
	if ( Flush == 1) begin
		Stall = 0;
	end

	else begin
		// CHECKING FOR HAZARDS IN REGISTER FILE STAGE
		// EVEN
		if ( RAEi == TagE0 | RBEi == TagE0 | RCEi == TagE0 | 
		((RAEi == TagO0 | RBEi == TagO0 | RCEi == TagO0) & ((CSORF[0:1] == 01) | (CSORF[0:4] == 5'b10100) | (CSORF == 6'b110001) | (CSORF == 6'b110010) | (CSORF == 6'b110011) | (CSORF == 6'b110100) | (CSORF == 6'b110101))) ) begin
			Stall = 1;
		end
		// ODD
		else if (RAOi == TagE0 | RBOi == TagE0 | RCOi == TagE0 |
		((RAOi == TagO0 | RBOi == TagO0 | RCOi == TagO0) & ((CSORF[0:1] == 01) | (CSORF[0:4] == 5'b10100) | (CSORF == 6'b110001) | (CSORF == 6'b110010) | (CSORF == 6'b110011) | (CSORF == 6'b110100) | (CSORF == 6'b110101))) ) begin
			Stall = 1;
		end
		// CHECKING FOR HAZARDS IN PIPES
		// STAGE 1
		// EVEN
		else if ( ((({1,RAEi} == TagE1) | ({1,RBEi} == TagE1) | ({1,RCEi} == TagE1)) & (CSE1[0:2] != 3'b101)) |
		(( {1,RAEi} == TagO1 | {1,RBEi} == TagO1 | {1,RCEi} == TagO1) & ((CSO1[0:1] == 01) | (CSO1[0:4] == 5'b10100) | (CSO1 == 6'b110001) | (CSO1 == 6'b110010) | (CSO1 == 6'b110011) | (CSO1 == 6'b110100) | (CSO1 == 6'b110101))) ) begin
			Stall = 1;
		end
		// ODD
		else if ( ((({1,RAOi} == TagE1) | ({1,RBOi} == TagE1) | ({1,RCOi} == TagE1)) & (CSE1[0:2] != 3'b101)) |
		(({1,RAOi} == TagO1 | {1,RBOi} == TagO1 | {1,RCOi} == TagO1) & ((CSO1[0:1] == 01) | (CSO1[0:4] == 5'b10100) | (CSO1 == 6'b110001) | (CSO1 == 6'b110010) | (CSO1 == 6'b110011) | (CSO1 == 6'b110100) | (CSO1 == 6'b110101))) ) begin
			Stall = 1;
		end
		// STAGE 2
		// EVEN
		else if ( ((({1,RAEi} == TagE2) | ({1,RBEi} == TagE2) | ({1,RCEi} == TagE2)) & (CSE2[0:2] != 3'b101)) |
		(({1,RAEi} == TagO2 | {1,RBEi} == TagO2 | {1,RCEi} == TagO2) & ((CSO2[0:1] == 01) | (CSO2[0:4] == 5'b10100) | (CSO2 == 6'b110001) | (CSO2 == 6'b110010) | (CSO2 == 6'b110011) | (CSO2 == 6'b110100) | (CSO2 == 6'b110101))) ) begin
			Stall = 1;
		end
		// ODD
		else if ( (({1,RAOi} == TagE2 | {1,RBOi} == TagE2 | {1,RCOi} == TagE2) & CSE2[0:2] != 101) |
		(({1,RAOi} == TagO2 | {1,RBOi} == TagO2 | {1,RCOi} == TagO2) & ((CSO2[0:1] == 01) | (CSO2[0:4] == 5'b10100) | (CSO2 == 6'b110001) | (CSO2 == 6'b110010) | (CSO2 == 6'b110011) | (CSO2 == 6'b110100) | (CSO2 == 6'b110101))) ) begin
			Stall = 1;
		end
		// STAGE 3
		// EVEN
		else if ( ((({1,RAEi} == TagE3) | ({1,RBEi} == TagE3) | ({1,RCEi} == TagE3)) & (CSE3[0:2] == 3'b111)) | 
		(({1,RAEi} == TagO3 | {1,RBEi} == TagO3 | {1,RCEi} == TagO3) & ((CSO3 == 6'b110001) | (CSO3 == 6'b110010) | (CSO3 == 6'b110011) | (CSO3 == 6'b110100) | (CSO3 == 6'b110101))) ) begin
			Stall = 1;
		end
		// ODD
		else if ( ((({1,RAOi} == TagE3) | ({1,RBOi} == TagE3) | ({1,RCOi} == TagE3)) & (CSE3[0:2] == 3'b111) ) |
		(({1,RAOi} == TagO3 | {1,RBOi} == TagO3 | {1,RCOi} == TagO3) & ((CSO3 == 6'b110001) | (CSO3 == 6'b110010) | (CSO3 == 6'b110011) | (CSO3 == 6'b110100) | (CSO3 == 6'b110101))) ) begin
			Stall = 1;
		end
		// STAGE 4
		// EVEN
		else if ( ((({1,RAEi} == TagE4) | ({1,RBEi} == TagE4) | ({1,RCEi} == TagE4)) & (CSE4[0:2] == 3'b111)) |
		(({1,RAEi} == TagO4 | {1,RBEi} == TagO4 | {1,RCEi} == TagO4) & ((CSO4 == 6'b110001) | (CSO4 == 6'b110010) | (CSO4 == 6'b110011) | (CSO4 == 6'b110100) | (CSO4 == 6'b110101))) ) begin
			Stall = 1;
		end
		// ODD
		else if ( ((({1,RAOi} == TagE4) | ({1,RBOi} == TagE4) | ({1,RCOi} == TagE4)) & (CSE4[0:2] == 3'b111)) |
		(( {1,RAOi} == TagO4 | {1,RBOi} == TagO4 | {1,RCOi} == TagO4) & ((CSO4 == 6'b110001) | (CSO4 == 6'b110010) | (CSO4 == 6'b110011) | (CSO4 == 6'b110100) | (CSO4 == 6'b110101))) ) begin
			Stall = 1;
		end
		// STAGE 5
		// EVEN
		else if ( ((({1,RAEi} == TagE5) | ({1,RBEi} == TagE5) | ({1,RCEi} == TagE5)) & (CSE5[0:2] == 3'b111) )) begin
			Stall = 1;
		end
		// ODD
		else if ( ((({1,RAOi} == TagE5) | ({1,RBOi} == TagE5) | ({1,RCOi} == TagE5)) & (CSE5[0:2] == 3'b111)) ) begin
			Stall = 1;
		end
		// STAGE 6 AND BEYOND
		else begin
			Stall = 0;
		end
	end
	end

// FORWARDING ASSERTION MODULE
always_ff @(posedge clk) begin
if (Flush == 1) begin
ForwardE10 <= 5'b00000;
ForwardE20 <= 5'b00000;
ForwardE30 <= 5'b00000;
ForwardO10 <= 5'b00000;
ForwardO20 <= 5'b00000;
ForwardO30 <= 5'b00000;
end
else begin

// FORWARDING FOR E1
case ({1,RAEi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardE10 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardE10 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardE10 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardE10 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardE10 <= 5'b00111;
end
else begin
	ForwardE10 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 2'b01 ) begin
	ForwardE10 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 2'b10 ) begin
	ForwardE10 <= 5'b10111;
end
else begin
	ForwardE10 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardE10 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardE10 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardE10 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 2'b11 ) begin
	ForwardE10 <= 5'b10011;
end
// LS
else begin
	ForwardE10 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 3'b111 ) begin
	ForwardE10 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 3'b100 | CSE6[0:2] == 3'b101 | CSE6[0:2] == 3'b110 ) begin
	ForwardE10 <= 5'b00110;
end
else begin
	ForwardE10 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardE10 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardE10 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardE10 <= 5'b11000;
end


default : begin
	ForwardE10 <= 5'b00000;
end
endcase

// FORWARDING FOR E2
case ({1,RBEi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardE20 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardE20 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardE20 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardE20 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardE20 <= 5'b00111;
end
else begin
	ForwardE20 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 2'b01 ) begin
	ForwardE20 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 2'b10 ) begin
	ForwardE20 <= 5'b10111;
end
else begin
	ForwardE20 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardE20 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardE20 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardE20 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 11 ) begin
	ForwardE20 <= 5'b10011;
end
// LS
else begin
	ForwardE20 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 111 ) begin
	ForwardE20 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 100 | CSE6[0:2] == 101 | CSE6[0:2] == 110 ) begin
	ForwardE20 <= 5'b00110;
end
else begin
	ForwardE20 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardE20 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardE20 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardE20 <= 5'b11000;
end


default : begin
	ForwardE20 <= 5'b00000;
end
endcase

// FORWARDING FOR E3
case ({1,RCEi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardE30 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardE30 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardE30 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardE30 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardE30 <= 5'b00111;
end
else begin
	ForwardE30 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 2'b01 ) begin
	ForwardE30 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 2'b10 ) begin
	ForwardE30 <= 5'b10111;
end
else begin
	ForwardE30 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardE30 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardE30 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardE30 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 2'b11 ) begin
	ForwardE30 <= 5'b10011;
end
// LS
else begin
	ForwardE30 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 3'b111 ) begin
	ForwardE30 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 100 | CSE6[0:2] == 101 | CSE6[0:2] == 110 ) begin
	ForwardE30 <= 5'b00110;
end
else begin
	ForwardE30 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardE30 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardE30 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardE30 <= 5'b11000;
end


default : begin
	ForwardE30 <= 5'b00000;
end
endcase

// FORWARDING FOR O1
case ({1,RAOi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardO10 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardO10 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardO10 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardO10 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardO10 <= 5'b00111;
end
else begin
	ForwardO10 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 01 ) begin
	ForwardO10 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 10 ) begin
	ForwardO10 <= 5'b10111;
end
else begin
	ForwardO10 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardO10 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardO10 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardO10 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 2'b11 ) begin
	ForwardO10 <= 5'b10011;
end
// LS
else begin
	ForwardO10 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 3'b111 ) begin
	ForwardO10 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 3'b100 | CSE6[0:2] == 3'b101 | CSE6[0:2] == 3'b110 ) begin
	ForwardO10 <= 5'b00110;
end
else begin
	ForwardO10 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardO10 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardO10 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardO10 <= 5'b11000;
end


default : begin
	ForwardO10 <= 5'b00000;
end
endcase

// FORWARDING FOR E2
case ({1,RBOi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardO20 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardO20 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardO20 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardO20 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardO20 <= 5'b00111;
end
else begin
	ForwardO20 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 2'b01 ) begin
	ForwardO20 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 2'b10 ) begin
	ForwardO20 <= 5'b10111;
end
else begin
	ForwardO20 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardO20 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardO20 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardO20 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 11 ) begin
	ForwardO20 <= 5'b10011;
end
// LS
else begin
	ForwardO20 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 3'b111 ) begin
	ForwardO20 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 3'b100 | CSE6[0:2] == 3'b101 | CSE6[0:2] == 3'b110 ) begin
	ForwardO20 <= 5'b00110;
end
else begin
	ForwardO20 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardO20 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardO20 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardO20 <= 5'b11000;
end


default : begin
	ForwardO20 <= 5'b00000;
end
endcase

// FORWARDING FOR O3
case ({1,RCOi})

// DIRECT FX1 OUTPUT
TagE1 : begin
ForwardO30 <= 5'b00001;
end

//  EVEN STAGE 3 
TagE2 : begin
ForwardO30 <= 5'b00010;
end

// EVEN STAGE 4 / BYTES / FX2
TagE3 : begin
// STAGE 4
if ( CSE3[0:2] == 3'b101 ) begin
	ForwardO30 <= 5'b00011;
end
// BYTES
else if ( CSE3[0:2] == 3'b100 ) begin
	ForwardO30 <= 5'b01000;
end
// FX2
else if ( CSE3[0:2] == 3'b110 ) begin
	ForwardO30 <= 5'b00111;
end
else begin
	ForwardO30 <= 5'b00000;
end
end

// ODD STAGE 4 / PERMUTE / BRANCH
TagO3 : begin
// PERMUTE
if ( CSO3[0:1] == 01 ) begin
	ForwardO30 <= 5'b10101;
end
// BRANCH
else if ( CSO3[0:1] == 10 ) begin
	ForwardO30 <= 5'b10111;
end
else begin
	ForwardO30 <= 5'b00000;
end
end

// EVEN STAGE 5
TagE4 : begin
	ForwardO30 <= 5'b00100;
end

// EVEN STAGE 5
TagO4 : begin
	ForwardO30 <= 5'b10010;
end

// EVEN STAGE 6
TagE5 : begin
	ForwardO30 <= 5'b00101;
end

// ODD STAGE 6 / LS
TagO5 : begin
// STAGE 6
if ( CSO5[0:1] != 11 ) begin
	ForwardO30 <= 5'b10011;
end
// LS
else begin
	ForwardO30 <= 5'b10110;
end
end

// EVEN STAGE 7 / FP
TagE6 : begin
// FP
if ( CSE6[0:2] == 3'b111 ) begin
	ForwardO30 <= 5'b01001;
end
// STAGE 7
else if ( CSE6[0:2] == 3'b100 | CSE6[0:2] == 3'b101 | CSE6[0:2] == 3'b110 ) begin
	ForwardO30 <= 5'b00110;
end
else begin
	ForwardO30 <= 0;
end
end

// ODD STAGE 7
TagO6 : begin
	ForwardO30 <= 5'b10100;
end

// WB DATAE
TagE7 : begin
	ForwardO30 <= 5'b01010;
end

// WB DATAO
TagO7 : begin
	ForwardO30 <= 5'b11000;
end


default : begin
	ForwardO30 <= 5'b00000;
end
endcase

end

// FORWARDING SIGNAL PROPAGATION
ForwardE1 <= ForwardE10;
ForwardE2 <= ForwardE20;
ForwardE3 <= ForwardE30;
ForwardO1 <= ForwardO10;
ForwardO2 <= ForwardO20;
ForwardO3 <= ForwardO30;

end




endmodule
