module OddPipe #(
parameter  WIDTH = 128, SIZE = 16384 , LOGSIZE = 32)
(clk, reset, Input1, Input2, Input3, Output, PCIn, PCOut, CSOIn, AddressIn, AddressOut, WEOOut, ForwardA, ForwardB, ForwardC, A, B, C,
ForwardAE, ForwardBE, ForwardCE, AE, BE, CE, TagO1,TagO2,TagO3,TagO4,TagO5,TagO6,TagO7, CSO1, CSO2, CSO3, CSO4, CSO5, CSO6, CSO7,
data_in, data_out, addr, wr_en);

// INPUT SIGNALS
input logic clk;
input logic [0:127] Input1;
input logic [0:127] Input2;
input logic [0:127] Input3;
input logic [0:5] CSOIn;
input logic [0:6] AddressIn;
input logic [0:31] PCIn;
input logic [0:3] ForwardA; // 3 stages x 2 inputs + 2 direct outputs x2 + branch output + no forwarding
input logic [0:3] ForwardB;
input logic [0:3] ForwardC;
input logic [0:3] ForwardAE;
input logic [0:3] ForwardBE;
input logic [0:3] ForwardCE;

// OUTPUT SIGNALS
output logic [0:127] Output;
output logic [0:6] AddressOut;
output logic [0:31] PCOut;
output logic WEOOut;
output logic reset;
output logic [0:127] A;
output logic [0:127] B;
output logic [0:127] C;
output logic [0:127] AE;
output logic [0:127] BE;
output logic [0:127] CE;

output logic [0:7] TagO1;
output logic [0:7] TagO2;
output logic [0:7] TagO3;
output logic [0:7] TagO4;
output logic [0:7] TagO5;
output logic [0:7] TagO6;
output logic [0:7] TagO7;

output logic [0:5] CSO1;
output logic [0:5] CSO2;
output logic [0:5] CSO3;
output logic [0:5] CSO4;
output logic [0:5] CSO5;
output logic [0:5] CSO6;
output logic [0:5] CSO7;

// INTERNAL SIGNALS
logic [0:127] Stage5;
logic [0:127] Stage6;
logic [0:127] Stage7;

logic [0:5] CSO;
logic [0:3] CSOBR;
logic [0:3] CSOLS;
logic [0:3] CSOP;

logic [0:6] Address0;
logic [0:6] Address1;
logic [0:6] Address2;
logic [0:6] Address3;
logic [0:6] Address4;
logic [0:6] Address5;
logic [0:6] Address6;
logic [0:6] Address7;

logic WEO0;
logic WEO1;
logic WEO2;
logic WEO3;
logic WEO4;
logic WEO5;
logic WEO6;
logic WEO7;

logic [0:31] PCBranch;
logic [0:31] PC5;
logic [0:31] PC6;
logic [0:31] PC7;

logic [0:127] PermuteOut;
logic [0:127] BranchOut;
logic [0:127] OutputLS;

logic flush;

///////////////////////////////////////////////////
// MEMORY SIGNALS
output logic [	WIDTH-1 : 0] data_in;
output logic [	WIDTH-1 : 0] data_out;
output logic [LOGSIZE-1 : 0] addr;
output logic wr_en;
//logic [SIZE-1:0] [WIDTH-1:0] mem;
/////////////////////////////////////////////////




//SUBPIPE INSTANTIATION
// CSO [0:1] = 00
//LNOP
// CSO [0:1] = 01
PermutePipe  Permute (clk, flush, Input1, Input2, Input3, PermuteOut, CSOP);
 // CSO [0:1] = 10
BranchPipe BR (clk, flush, Input1, Input2, PCIn, BranchOut, PCBranch, CSOBR); // PCIn = Input3
// CSO [0:1] = 11
LoadStorePipe  LS (clk, flush, Input1, Input2, Input3, OutputLS, CSOLS, data_in, data_out, addr, wr_en);



// FORWARDING MULTIPLEXING MODULE
always_comb begin

// FORWARDING A
case(ForwardA)
// NO FORWARDING
	4'b0000 : begin
	A = 0;
	end

// STAGE  5 
	4'b0010 : begin
	A = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	A = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	A = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	A = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	A = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	A = BranchOut;
	end

	default : begin
	A = 0;
	end
endcase

// FORWARDING B
case(ForwardB)
// NO FORWARDING
	4'b0000 : begin
	B = 0;
	end

// STAGE  5 
	4'b0010 : begin
	B = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	B = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	B = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	B = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	B = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	B = BranchOut;
	end

	default : begin
	B = 0;
	end
endcase

// FORWARDING C
case(ForwardC)
// NO FORWARDING
	4'b0000 : begin
	C = 0;
	end

// STAGE  5 
	4'b0010 : begin
	C = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	C = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	C = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	C = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	C = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	C = BranchOut;
	end

	default : begin
	C = 0;
	end
endcase

// FORWARDING AE
case(ForwardAE)
// NO FORWARDING
	4'b0000 : begin
	AE = 0;
	end

// STAGE  5 
	4'b0010 : begin
	AE = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	AE = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	AE = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	AE = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	AE = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	AE = BranchOut;
	end

	default : begin
	AE = 0;
	end
endcase

// FORWARDING BE
case(ForwardBE)
// NO FORWARDING
	4'b0000 : begin
	BE = 0;
	end
	
// STAGE  5 
	4'b0010 : begin
	BE = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	BE = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	BE = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	BE = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	BE = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	BE = BranchOut;
	end

	default : begin
	BE = 0;
	end
endcase

// FORWARDING CE
case(ForwardCE)
// NO FORWARDING
	4'b0000 : begin
	CE = 0;
	end

// STAGE  5 
	4'b0010 : begin
	CE = Stage5;
	end

// STAGE  6 
	4'b0011 : begin
	CE = Stage6;
	end

// STAGE  7 
	4'b0100 : begin
	CE = Stage7;
	end
	
// DIRECT PermuteOut
	4'b0101 : begin
	CE = PermuteOut;
	end

// DIRECT OutputLS
	4'b0110 : begin
	CE = OutputLS;
	end

// DIRECT BranchOut
	4'b0111 : begin
	CE = BranchOut;
	end

	default : begin
	CE = 0;
	end
endcase


end






always_comb begin
CSO = CSOIn;
Address0 = AddressIn;
AddressOut = Address7;
WEOOut = WEO7;
PCOut = PCBranch;
Output = Stage7;

TagO1 = {WEO1,Address1};
TagO2 = {WEO2,Address2};
TagO3 = {WEO3,Address3};
TagO4 = {WEO4,Address4};
TagO5 = {WEO5,Address5};
TagO6 = {WEO6,Address6};
TagO7 = {WEO7,Address7};

// INSTRUCTION DISTRIBUTION MODULE
case (CSO[0:1]) 

// LNOPS ALL THE WAY
2'b00 : begin
CSOP = 4'b0000;
CSOBR = 4'b0000;
CSOLS = 4'b0000;
WEO0 = 0;
end

// INSTRUCTIONS FOR  PERMUTE
2'b01 : begin
CSOP = CSO[3:5];
CSOBR = 4'b0000;
CSOLS = 4'b0000;
WEO0 = 1;
end

// INSTRUCTIONS FOR BRANCH
2'b10 : begin
CSOP = 4'b0000;
CSOBR = CSO[2:5];
CSOLS = 4'b0000;
if ((CSO[2:5] == 1000) | (CSO[2:5] == 1001)) begin
	WEO0 = 1;
end
else begin
	WEO0 = 0;
end
end

// INSTRUCTIONS FOR LOAD/STORE
2'b11 : begin
CSOP = 4'b0000;
CSOBR = 4'b0000;
CSOLS = CSO[2:5];
if ((CSO[2:5] == 0001) | (CSO[2:5] == 0010) | (CSO[2:5] == 0011) | (CSO[2:5] == 0100) | (CSO[2:5] == 0101)) begin
	WEO0 = 1;
end
else begin
	WEO0 = 0;
end
end
endcase


end

always_ff @(posedge clk) begin
if (flush == 1) begin
Address1 <= 0;
Address2 <= 0;
Address3 <= 0;
Address4 <= 0;

WEO1 <= 0;
WEO2 <= 0;
WEO3 <= 0;
WEO4 <= 0;

CSO1 <= 0;
CSO2 <= 0;
CSO3 <= 0;
CSO4 <= 0;
end
else begin
// 1ST STAGE OF THE PIPE
CSO1 <= CSO;
Address1 <= Address0;
WEO1 <= WEO0;

// 2ND STAGE OF THE PIPE
WEO2 <= WEO1;
CSO2 <= CSO1;
Address2 <= Address1;

// 3RD STAGE OF THE PIPE
WEO3 <= WEO2;
CSO3 <= CSO2;
Address3 <= Address2;

// 4TH STAGE OF THE PIPE
WEO4 <= WEO3;
CSO4 <= CSO3;
Address4 <= Address3;

// 5TH STAGE OF THE PIPE
WEO5 <= WEO4;
PC5 <= PCBranch;
CSO5 <= CSO4;
Address5 <= Address4;

//////////////////////////////////////////////////////
// CONTROLLING STAGE 5 X-ROAD
case (CSO4[0:1])
// LNOP
2'b00 : begin 
Stage5 <= 0;
end
// Value from the PermutePipe
2'b01 : begin 
Stage5 <= PermuteOut;
end
// Value from BranchPipe
2'b10 : begin
Stage5 <= BranchOut;
end
// Don't Care
default : Stage5 <= 0;
endcase
////////////////////////////////////////////////////////

// 6TH STAGE OF THE PIPE
WEO6 <= WEO5;
PC6 <= PC5;
CSO6 <= CSO5;
Address6 <= Address5;
Stage6 <= Stage5;

// 7TH STAGE OF THE PIPE
WEO7 <= WEO6;
PC7 <= PC6;
CSO7 <= CSO6;
Address7 <= Address6;

//////////////////////////////////////////////////////
// CONTROLLING THE OUTPUT X-ROAD
case (CSO6[0:1])
2'b11 : begin
Stage7 <= OutputLS;
end

default : begin
Stage7 <= Stage6;
end

endcase
/////////////////////////////////////////////////////////

//Stage7 <= Stage6;

end
end

endmodule