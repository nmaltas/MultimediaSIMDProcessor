module EvenPipe (clk, reset, Input1, Input2, Input3, Output, CSEIn, AddressIn, AddressOut, WEEOut, ForwardA, ForwardB, ForwardC, A, B, C, 
ForwardAO, ForwardBO, ForwardCO, AO, BO, CO, TagE1, TagE2, TagE3, TagE4, TagE5, TagE6, TagE7, CSE1, CSE2, CSE3, CSE4, CSE5, CSE6, CSE7);

//INPUT SIGNALS
input logic clk, reset;
input logic [0:127] Input1;
input logic [0:127] Input2;
input logic [0:127] Input3;
input logic [0:7] CSEIn;
input logic [0:6] AddressIn;
input logic [0:3] ForwardA; // 6 SFX1 x 3, 3 direct outputs x 2 for the other subpipes + 1 for not fowrarding
input logic [0:3] ForwardB;
input logic [0:3] ForwardC;
input logic [0:3] ForwardAO;
input logic [0:3] ForwardBO;
input logic [0:3] ForwardCO;

//OUTPUT SIGNALS
output logic [0:127] Output;
output logic [0:6] AddressOut;
output logic WEEOut;
output logic [0:127] A;
output logic [0:127] B;
output logic [0:127] C;
output logic [0:127] AO;
output logic [0:127] BO;
output logic [0:127] CO;

output logic [0:7] TagE1;
output logic [0:7] TagE2;
output logic [0:7] TagE3;
output logic [0:7] TagE4;
output logic [0:7] TagE5;
output logic [0:7] TagE6;
output logic [0:7] TagE7;

output logic [0:7] CSE1;
output logic [0:7] CSE2;
output logic [0:7] CSE3;
output logic [0:7] CSE4;
output logic [0:7] CSE5;
output logic [0:7] CSE6;
output logic [0:7] CSE7;

//INTERNAL SIGNALS
logic [0:127] Stage3;
logic [0:127] Stage4;
logic [0:127] Stage5;
logic [0:127] Stage6;
logic [0:127] Stage7;

logic [0:3] CSEB;
logic [0:4] CSEFX1;
logic [0:3] CSEFX2;
logic [0:3] CSEFP;

logic [0:6] Address0;
logic [0:6] Address1;
logic [0:6] Address2;
logic [0:6] Address3;
logic [0:6] Address4;
logic [0:6] Address5;
logic [0:6] Address6;
logic [0:6] Address7;

logic WEE0;
logic WEE1;
logic WEE2;
logic WEE3;
logic WEE4;
logic WEE5;
logic WEE6;
logic WEE7;

logic [0:7] CSE;
logic [0:127] FX1Out;
logic [0:127] ByteOut;
logic [0:127] FX2Out;
logic [0:127] OutputF;

//SUBPIPE INSTANTIATION
// CSE [1:2] = 00
BytesPipe Bytes (clk, reset, Input1, Input2, ByteOut, CSEB);
// CSE [1:2] = 01
SimpleFixed1Pipe FX1 (clk, reset, Input1, Input2, Input3, FX1Out, CSEFX1);
 // CSE [1:2] = 10
SimpleFixed2Pipe FX2 (clk, reset, Input1, Input2, Input3, FX2Out, CSEFX2);
// CSE [1:2] = 11
FloatPipe FP (clk, reset, Input1, Input2, Input3, OutputF, CSEFP);



// FORWARDING MULTIPLEXING MODULE
always_comb begin
// FORWARDING FOR A
case (ForwardA)
// NO FORWARDING
	4'b0000 : begin
	A = 0;
	end
	
// DIRECT FX1 OUTPUT
	4'b0001 : begin
	A = FX1Out;
	end

//  STAGE 3 
	4'b0010 : begin
	A = Stage3;
	end
	
//  STAGE 4 
	4'b0011 : begin
	A = Stage4;
	end
	
// STAGE 5
	4'b0100 : begin
	A = Stage5;
	end

// STAGE 6
	4'b0101 : begin
	A = Stage6;
	end
	
// STAGE 7
	4'b0110 : begin
	A = Stage7;
	end

// DIRECT FX2Out
	4'b0111 : begin
	A = FX2Out;
	end
	
// DIRECT ByteOut
	4'b1000 : begin
	A = ByteOut;
	end
	
// DIRECT OutputF
	4'b1001 : begin
	A = OutputF;
	end
	
	default : begin
	A = 0;
	end
endcase

// FORWARDING FOR B
case (ForwardB)
// NO FORWARDING
	4'b0000 : begin
	B = 0;
	end
	
// DIRECT FX1 OUTPUT
	4'b0001 : begin
	B = FX1Out;
	end

//  STAGE 3 
	4'b0010 : begin
	B = Stage3;
	end
	
//  STAGE 4 
	4'b0011 : begin
	B = Stage4;
	end
	
// STAGE 5 
	4'b0100 : begin
	B = Stage5;
	end

// STAGE 6
	4'b0101 : begin
	B = Stage6;
	end
	
// STAGE 7
	4'b0110 : begin
	B = Stage7;
	end

// DIRECT FX2Out
	4'b0111 : begin
	B = FX2Out;
	end
	
// DIRECT ByteOut
	4'b1000 : begin
	B = ByteOut;
	end
	
// DIRECT OutputF
	4'b1001 : begin
	B = OutputF;
	end
	
	default : begin
	B = 0;
	end
endcase

// FORWARDING FOR C
case (ForwardC)
// NO FORWARDING
	4'b0000 : begin
	C = 0;
	end
	
// DIRECT FX1 OUTPUT TO A
	4'b0001 : begin
	C = FX1Out;
	end

//  STAGE 3  TO A
	4'b0010 : begin
	C = Stage3;
	end
	
//  STAGE 4  TO A
	4'b0011 : begin
	C = Stage4;
	end
	
// STAGE 5  TO A
	4'b0100 : begin
	C = Stage5;
	end

// STAGE 6  TO A
	4'b0101 : begin
	C = Stage6;
	end
	
// STAGE 7  TO A
	4'b0110 : begin
	C = Stage7;
	end

// DIRECT FX2Out TO A
	4'b0111 : begin
	C = FX2Out;
	end
	
// DIRECT ByteOut TO A
	4'b1000 : begin
	C = ByteOut;
	end
	
// DIRECT OutputF TO A
	4'b1001 : begin
	C = OutputF;
	end
	
	default : begin
	C = 0;
	end
endcase

// FORWARDING FOR AO
case (ForwardAO)
// NO FORWARDING
	4'b0000 : begin
	AO = 0;
	end
	
// DIRECT FX1 OUTPUT
	4'b0001 : begin
	AO = FX1Out;
	end

//  STAGE 3 
	4'b0010 : begin
	AO = Stage3;
	end
	
//  STAGE 4 
	4'b0011 : begin
	AO = Stage4;
	end
	
// STAGE 5
	4'b0100 : begin
	AO = Stage5;
	end

// STAGE 6
	4'b0101 : begin
	AO = Stage6;
	end
	
// STAGE 7
	4'b0110 : begin
	AO = Stage7;
	end

// DIRECT FX2Out
	4'b0111 : begin
	AO = FX2Out;
	end
	
// DIRECT ByteOut
	4'b1000 : begin
	AO = ByteOut;
	end
	
// DIRECT OutputF
	4'b1001 : begin
	AO = OutputF;
	end
	
	default : begin
	AO = 0;
	end
endcase

// FORWARDING FOR BO
case (ForwardBO)
// NO FORWARDING
	4'b0000 : begin
	BO = 0;
	end
	
// DIRECT FX1 OUTPUT
	4'b0001 : begin
	BO = FX1Out;
	end

//  STAGE 3 
	4'b0010 : begin
	BO = Stage3;
	end
	
//  STAGE 4 
	4'b0011 : begin
	BO = Stage4;
	end
	
// STAGE 5 
	4'b0100 : begin
	BO = Stage5;
	end

// STAGE 6
	4'b0101 : begin
	BO = Stage6;
	end
	
// STAGE 7
	4'b0110 : begin
	BO = Stage7;
	end

// DIRECT FX2Out
	4'b0111 : begin
	BO = FX2Out;
	end
	
// DIRECT ByteOut
	4'b1000 : begin
	BO = ByteOut;
	end
	
// DIRECT OutputF
	4'b1001 : begin
	BO = OutputF;
	end
	
	default : begin
	BO = 0;
	end
endcase

// FORWARDING FOR CO
case (ForwardCO)
// NO FORWARDING
	4'b0000 : begin
	CO = 0;
	end
	
// DIRECT FX1 OUTPUT TO A
	4'b0001 : begin
	CO = FX1Out;
	end

//  STAGE 3  TO A
	4'b0010 : begin
	CO = Stage3;
	end
	
//  STAGE 4  TO A
	4'b0011 : begin
	CO = Stage4;
	end
	
// STAGE 5  TO A
	4'b0100 : begin
	CO = Stage5;
	end

// STAGE 6  TO A
	4'b0101 : begin
	CO = Stage6;
	end
	
// STAGE 7  TO A
	4'b0110 : begin
	CO = Stage7;
	end

// DIRECT FX2Out TO A
	4'b0111 : begin
	CO = FX2Out;
	end
	
// DIRECT ByteOut TO A
	4'b1000 : begin
	CO = ByteOut;
	end
	
// DIRECT OutputF TO A
	4'b1001 : begin
	CO = OutputF;
	end
	
	default : begin
	CO = 0;
	end
endcase

end




always_comb begin
CSE = CSEIn;
Address0 = AddressIn;
AddressOut = Address7;
WEEOut = WEE7;

TagE1 = {WEE1,Address1};
TagE2 = {WEE2,Address2};
TagE3 = {WEE3,Address3};
TagE4 = {WEE4,Address4};
TagE5 = {WEE5,Address5};
TagE6 = {WEE6,Address6};
TagE7 = {WEE7,Address7};


// INSTRUCTION DISTRIBUTION MODULE
case (CSE[0:2]) 

// INSTRUCTIONS FOR BYTES
3'b100 : begin
CSEB = CSE[4:7];
CSEFX1 = 5'b00000;
CSEFX2 = 4'b0000;
CSEFP = 4'b0000;
WEE0 = 1;
end

// INSTRUCTIONS FOR FXP1
3'b101 : begin
CSEB = 4'b0000;
CSEFX1 = CSE[3:7];
CSEFX2 = 4'b0000;
CSEFP = 4'b0000;
WEE0 = 1;
end

// INSTRUCTIONS FOR FXP2
3'b110 : begin
CSEB = 4'b0000;
CSEFX1 = 5'b00000;
CSEFX2 = CSE[4:7];
CSEFP = 4'b0000;
WEE0 = 1;
end

// INSTRUCTIONS FOR FP
3'b111 : begin
CSEB = 4'b0000;
CSEFX1 = 5'b00000;
CSEFX2 = 4'b0000;
CSEFP = CSE[4:7];
WEE0 = 1;
end

// NOPS ALL THE WAY
default : begin
CSEB = 4'b0000;
CSEFX1 = 5'b00000;
CSEFX2 = 4'b0000;
CSEFP = 4'b0000;
WEE0 = 0;
end

endcase


// CONTROLLING THE OUTPUT X-ROAD
case (CSE6[1:2])

2'b11 : begin
Output = OutputF;
end

default : begin
Output = Stage7;
end

endcase



end


always_ff @(posedge clk) begin
if (reset == 1) begin
Stage3 <= 0;
Stage4 <= 0;

Address1 <= 0;
Address2 <= 0;
Address3 <= 0;
Address4 <= 0;

WEE1 <= 0;
WEE2 <= 0;
WEE3 <= 0;
WEE4 <= 0;

CSE1 <= 0;
CSE2 <= 0;
CSE3 <= 0;
CSE4 <= 0;
end
else begin
// 1ST STAGE OF THE PIPE
CSE1 <= CSE;
Address1 <= Address0;
WEE1 <= WEE0;

// 2ND STAGE OF THE PIPE
CSE2 <= CSE1;
Address2 <= Address1;
WEE2 <= WEE1;

// 3RD STAGE OF THE PIPE
CSE3 <= CSE2;
Address3 <= Address2;
WEE3 <= WEE2;
Stage3 <= FX1Out;

// 4TH STAGE OF THE PIPE
CSE4 <= CSE3;
Address4 <= Address3;
WEE4 <= WEE3;
Stage4 <= Stage3;

// 5TH STAGE OF THE PIPE
CSE5 <= CSE4;
Address5 <= Address4;
WEE5 <= WEE4;
//////////////////////////////////////////////////////
// CONTROLLING STAGE 5 X-ROAD
case (CSE4[0:2])
// Value from the BytePipe is valid
3'b100 : begin 
Stage5 <= ByteOut;
end
// Value from the FXP2
3'b110 : begin 
Stage5 <= FX2Out;
end
// Value from Stage4 gets passed down
3'b101 : begin
Stage5 <= Stage4;
end
// Don't Care
default : Stage5 <= Stage4;
endcase
////////////////////////////////////////////////////////

// 6TH STAGE OF THE PIPE
CSE6 <= CSE5;
Address6 <= Address5;
WEE6 <= WEE5;
Stage6 <= Stage5;

// 7TH STAGE OF THE PIPE
CSE7 <= CSE6;
Address7 <= Address6;
WEE7 <= WEE6;
Stage7 <= Stage6;

end
end
endmodule