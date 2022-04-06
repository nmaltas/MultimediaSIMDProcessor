module SetSailForFail #(
parameter  WIDTH = 128, SIZE = 8192 , LOGSIZE = 32)
(clk, reset, done);

// INPUT SIGNALS
input logic clk, reset;

// OUTPUT SIGNALS
output logic done;

// INTERNAL SIGNALS
logic WBE, WBO, Wait, Stall, Flush, miss, missback;
logic [0:31] Instruction1;
logic [0:31] Instruction2;
logic [0:127] AE;
logic [0:127] BE;
logic [0:127] CE;
logic [0:127] AO;
logic [0:127] BO;
logic [0:127] CO;
logic [0:127] AXE;
logic [0:127] BXE;
logic [0:127] CXE;
logic [0:127] AXO;
logic [0:127] BXO;
logic [0:127] CXO;
logic [0:127] Input1E;
logic [0:127] Input2E;
logic [0:127] Input3E;
logic [0:127] Input1O;
logic [0:127] Input2O;
logic [0:127] Input3O;
logic [0:6] AddressE;
logic [0:6] AddressO;
logic [0:127] E1;
logic [0:127] E2;
logic [0:127] E3;
logic [0:127] O1;
logic [0:127] O2;
logic [0:127] O3;
logic [0:127] OutputE;
logic [0:127] OutputO;
logic [0:6] AddressEOut;
logic [0:6] AddressOOut;
logic [0:7] CSE;
logic [0:5] CSO;
logic [0:7] CSEIn;
logic [0:7] CSOIn;

logic [0:7] TagE1;
logic [0:7] TagE2;
logic [0:7] TagE3;
logic [0:7] TagE4;
logic [0:7] TagE5;
logic [0:7] TagE6;
logic [0:7] TagE7;

logic [0:7] TagO1;
logic [0:7] TagO2;
logic [0:7] TagO3;
logic [0:7] TagO4;
logic [0:7] TagO5;
logic [0:7] TagO6;
logic [0:7] TagO7;

logic [0:7] CSE1;
logic [0:7] CSE2;
logic [0:7] CSE3;
logic [0:7] CSE4;
logic [0:7] CSE5;
logic [0:7] CSE6;
logic [0:7] CSE7;

logic [0:5] CSO1;
logic [0:5] CSO2;
logic [0:5] CSO3;
logic [0:5] CSO4;
logic [0:5] CSO5;
logic [0:5] CSO6;
logic [0:5] CSO7;

logic [0:6] RAE; 
logic [0:6] RBE; 
logic [0:6] RCE;
logic [0:6] RTE;
logic [0:31] ImmediateE;
logic [0:6] RAO; 
logic [0:6] RBO; 
logic [0:6] RCO;
logic [0:6] RTO;
logic [0:31] ImmediateO;

logic [0:7] CSED;
logic [0:6] RAED;
logic [0:6] RBED;
logic [0:6] RCED;
logic [0:6] RTED;
logic [0:31] ImmediateED;
logic [0:7] CSOD;
logic [0:6] RAOD;
logic [0:6] RBOD;
logic [0:6] RCOD;
logic [0:6] RTOD;
logic [0:31] ImmediateOD;

logic [0:4] ForwardE1;
logic [0:4] ForwardE2;
logic [0:4] ForwardE3;
logic [0:4] ForwardO1;
logic [0:4] ForwardO2;
logic [0:4] ForwardO3;

logic [0:31] PCBranch;
logic [0:31] PCOut;
logic [0:31] PCIn;
logic [0:31] PCD;

logic miss1, miss2, miss3, miss4, miss5, miss6, miss7;
logic [0:9] PCnew0;
logic [0:9] PCnew1;
logic [0:9] PCnew2;
logic [0:9] PCnew3;
logic [0:9] PCnew4;
logic [0:9] PCnew5;
logic [0:9] PCnew6;






////////////////////////////////////////////////
// INSTRUCTION LSR MEMORY SIGNALS
logic [0:31] [0:31] NewBlock;
logic [0:9] PCnew;
logic enable;
logic [ 0 : SIZE-1] [0:31] InstructionMemory;

always_comb begin
enable = miss6;
PCnew = PCnew6;

end
////////////////////////////////////////////////

///////////////////////////////////////////////////
// LSR MEMORY SIGNALS
logic [	0 : WIDTH-1 ] data_in;
logic [ 0 : WIDTH-1] data_out;
logic [ 0 : LOGSIZE-1] addr;
logic wr_en;
logic [ 0 : SIZE-1] [ 0 : WIDTH-1] mem;
/////////////////////////////////////////////////

/////////////////////////////////////////////////
// INSTRUCTION CACHE MEMORY SIGNALS
logic [0:31] Instruction1i;
logic [0:31] Instruction2i;
logic [0:31] PC1;
logic [0:31] PC2;
logic [0:9] BlockHere;
logic [0:33] [0:31] Block;
////////////////////////////////////////////////



// MODULE INSTANTIATION

// INSTRUCTION FETCH
InstructionFetch InstructionFetch (clk, Wait, Stall, Flush, reset, Instruction1i, Instruction2i, Instruction1, Instruction2, PC1, PC2, PCBranch, miss7, PCnew0, done, miss, BlockHere);
// DECODE STAGE
DecodeStage DecodeStage (clk, Flush, Instruction1, Instruction2, PC1, PCD, RAED, RBED, RCED, RTED, CSED, ImmediateED, RAOD, RBOD, RCOD, RTOD, CSOD, ImmediateOD, Wait, Stall, done, miss);
// DEPENDENCE
Dependence Dependence (clk, Flush, Stall, PCD, PCIn,
CSED, RAED, RBED, RCED, RTED, ImmediateED, CSE, RAE, RBE, RCE, RTE, ImmediateE, ForwardE1, ForwardE2, ForwardE3, AddressEOut, TagE1, TagE2, TagE3, TagE4, TagE5, TagE6, TagE7,
CSE, CSE1, CSE2, CSE3, CSE4, CSE5, CSE6, CSE7,
CSOD, RAOD, RBOD, RCOD, RTOD, ImmediateOD, CSO, RAO, RBO, RCO, RTO, ImmediateO, ForwardO1, ForwardO2, ForwardO3, AddressOOut, TagO1, TagO2, TagO3, TagO4, TagO5, TagO6, 
TagO7, CSO, CSO1, CSO2, CSO3, CSO4, CSO5, CSO6, CSO7);
// REGISTER FILE
RegisterFile RegisterFile (clk, Flush, WBE, WBO,  PCIn, PCOut,
AddressE,  E1, E2, E3, CSEIn, CSE, RAE, RBE, RCE, RTE, OutputE, AddressEOut, ImmediateE, ForwardE1, ForwardE2, ForwardE3,
AddressO, O1, O2, O3, CSOIn, CSO, RAO, RBO, RCO, RTO, OutputO, AddressOOut, ImmediateO, ForwardO1, ForwardO2, ForwardO3);
// EVEN PIPE
EvenPipe EvenPipe (clk, Flush, Input1E, Input2E, Input3E, OutputE, CSE, AddressE, AddressEOut, WBE, ForwardE1[1:4], ForwardE2[1:4], ForwardE3[1:4], AE, BE, CE, 
ForwardO1[1:4], ForwardO2[1:4], ForwardO3[1:4], AXE, BXE, CXE, TagE1, TagE2, TagE3, TagE4, TagE5, TagE6, TagE7, CSE1, CSE2, CSE3, CSE4, CSE5, CSE6, CSE7);
// ODD PIPE
OddPipe OddPipe (clk, Flush, Input1O, Input2O, Input3O, OutputO, PCOut, PCBranch, CSO, AddressO, AddressOOut, WBO, ForwardO1[1:4], ForwardO2[1:4], ForwardO3[1:4], AO, BO, CO, 
ForwardE1[1:4], ForwardE2[1:4], ForwardE3[1:4], AXO, BXO, CXO, TagO1,TagO2,TagO3,TagO4,TagO5,TagO6,TagO7, CSO1, CSO2, CSO3, CSO4, CSO5, CSO6, CSO7,
data_in, data_out, addr, wr_en);



// FORWARDING MODULE
always_comb begin

// FORWARDING E1
case (ForwardE1)
// NO FORWARDING
	5'b00000 : Input1E = E1;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input1E = AE;

//  EVEN STAGE 3 
	5'b00010 : Input1E = AE;
	
//  EVEN STAGE 4 
	5'b00011 : Input1E = AE;	

// EVEN STAGE 5p
	5'b00100 : Input1E = AE;
	
// EVEN STAGE 6
	5'b00101 : Input1E = AE;
	
// EVEN STAGE 7
	5'b00110 : Input1E = AE;
	
// DIRECT FX2Out
	5'b00111 : Input1E = AE;
	
// DIRECT ByteOut
	5'b01000 : Input1E = AE;
	
// DIRECT OutputF
	5'b01001 : Input1E = AE;
		
// ODD STAGE  5 
	5'b10010 : Input1E = AXO;
	
// ODD STAGE  6 
	5'b10011 : Input1E = AXO;
	
// ODD STAGE  7 
	5'b10100 : Input1E = AXO;
	
// DIRECT PermuteOut
	5'b10101 : Input1E = AXO;

// DIRECT OutputLS
	5'b10110 : Input1E = AXO;

// DIRECT BranchOut
	5'b10111 : Input1E = AXO;
	
	default : 	Input1E = E1;

endcase

// FORWARDING E2
case (ForwardE2)
// NO FORWARDING
	5'b00000 : Input2E = E2;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input2E = BE;

//  EVEN STAGE 3 
	5'b00010 : Input2E = BE;
	
//  EVEN STAGE 4 
	5'b00011 : Input2E = BE;
	
// EVEN STAGE 5
	5'b00100 : Input2E = BE;

// EVEN STAGE 6
	5'b00101 : Input2E = BE;
	
// EVEN STAGE 7
	5'b00110 : Input2E = BE;

// DIRECT FX2Out
	5'b00111 : Input2E = BE;
	
// DIRECT ByteOut
	5'b01000 : Input2E = BE;
	
// DIRECT OutputF
	5'b01001 : Input2E = BE;
	
// ODD STAGE  5 
	5'b10010 : Input2E = BXO;
	
// ODD STAGE  6 
	5'b10011 : Input2E = BXO;
	
// ODD STAGE  7 
	5'b10100 : Input2E = BXO;
	
// DIRECT PermuteOut
	5'b10101 : Input2E = BXO;
	
// DIRECT OutputLS
	5'b10110 : Input2E = BXO;
	
// DIRECT BranchOut
	5'b10111 : Input2E = BXO;
	
	default : Input2E = E2;

endcase

// FORWARDING E3
case (ForwardE3)
// NO FORWARDING
	5'b00000 : Input3E = E3;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input3E = CE;

//  EVEN STAGE 3 
	5'b00010 : Input3E = CE;
	
//  EVEN STAGE 4 
	5'b00011 : Input3E = CE;
	
// EVEN STAGE 5
	5'b00100 : Input3E = CE;
	
// EVEN STAGE 6
	5'b00101 : Input3E = CE;
	
// EVEN STAGE 7
	5'b00110 : Input3E = CE;
	
// DIRECT FX2Out
	5'b00111 : Input3E = CE;
	
// DIRECT ByteOut
	5'b01000 : Input3E = CE;
	
// DIRECT OutputF
	5'b01001 : Input3E = CE;
	
// ODD STAGE  5 
	5'b10010 : Input3E = CXO;
	
// ODD STAGE  6 
	5'b10011 : Input3E = CXO;
	
// ODD STAGE  7 
	5'b10100 : Input3E = CXO;
	
// DIRECT PermuteOut
	5'b10101 : Input3E = CXO;
	
// DIRECT OutputLS
	5'b10110 : Input3E = CXO;
	
// DIRECT BranchOut
	5'b10111 : Input3E = CXO;
	
	default : Input3E = E3;
	
endcase

// FORWARDING O1
case (ForwardO1)
// NO FORWARDING
	5'b00000 : Input1O = O1;

// ODD STAGE  5 
	5'b10010 : Input1O = AO;
	
// ODD STAGE  6 
	5'b10011 : Input1O = AO;
	
// ODD STAGE  7 
	5'b10100 : Input1O = AO;
	
// DIRECT PermuteOut
	5'b10101 : Input1O = AO;
	
// DIRECT OutputLS
	5'b10110 : Input1O = AO;
	
// DIRECT BranchOut
	5'b10111 : Input1O = AO;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input1O = AXE;
	
// EVEN STAGE 3 
	5'b00010 : Input1O = AXE;
	
// EVEN STAGE 4 
	5'b00011 : Input1O = AXE;
	
// EVEN STAGE 5
	5'b00100 : Input1O = AXE;
	
// EVEN STAGE 6
	5'b00101 : Input1O = AXE;
	
// EVEN STAGE 7
	5'b00110 : Input1O = AXE;
	
// DIRECT FX2Out
	5'b00111 : Input1O = AXE;
	
// DIRECT ByteOut
	5'b01000 : Input1O = AXE;
	
// DIRECT OutputF
	5'b01001 : Input1O = AXE;
	
	default : Input1O = O1;
	
endcase

// FORWARDING O2
case (ForwardO2)
// NO FORWARDING
	5'b00000 : Input2O = O2;
	
// ODD STAGE  5 
	5'b10010 : Input2O = BO;
	
// ODD STAGE  6 
	5'b10011 : Input2O = BO;
	
// ODD STAGE  7 
	5'b10100 : Input2O = BO;
	
// DIRECT PermuteOut
	5'b10101 : Input2O = BO;
	
// DIRECT OutputLS
	5'b10110 : Input2O = BO;
	
// DIRECT BranchOut
	5'b10111 : Input2O = BO;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input2O = BXE;
	
// EVEN STAGE 3 
	5'b00010 : Input2O = BXE;
	
// EVEN STAGE 4 
	5'b00011 : Input2O = BXE;
	
// EVEN STAGE 5
	5'b00100 : Input2O = BXE;
	
// EVEN STAGE 6
	5'b00101 : Input2O = BXE;
	
// EVEN STAGE 7
	5'b00110 : Input2O = BXE;
	
// DIRECT FX2Out
	5'b00111 : Input2O = BXE;
	
// DIRECT ByteOut
	5'b01000 : Input2O = BXE;
	
// DIRECT OutputF
	5'b01001 : Input2O = BXE;
	
default : Input2O = O2;

endcase

// FORWARDING O3
case (ForwardO3)
// NO FORWARDING
	5'b00000 : Input3O = O3;

// ODD STAGE  5 
	5'b10010 : Input3O = CO;
	
// ODD STAGE  6 
	5'b10011 : Input3O = CO;
	
// ODD STAGE  7 
	5'b10100 : Input3O = CO;
	
// DIRECT PermuteOut
	5'b10101 : Input3O = CO;
	
// DIRECT OutputLS
	5'b10110 : Input3O = CO;
	
// DIRECT BranchOut
	5'b10111 : Input3O = CO;
	
// DIRECT FX1 OUTPUT
	5'b00001 : Input3O = CXE;
	
// EVEN STAGE 3 
	5'b00010 : Input3O = CXE;
	
// EVEN STAGE 4 
	5'b00011 : Input3O = CXE;
	
// EVEN STAGE 5
	5'b00100 : Input3O = CXE;
	
// EVEN STAGE 6
	5'b00101 : Input3O = CXE;
	
// EVEN STAGE 7
	5'b00110 : Input3O = CXE;
	
// DIRECT FX2Out
	5'b00111 : Input3O = CXE;
	
// DIRECT ByteOut
	5'b01000 : Input3O = CXE;
	
// DIRECT OutputF
	5'b01001 : Input3O = CXE;
	
default : Input3O = O3;

endcase

end

// INOUT INTERFACING MODULE
always_comb begin


end

// IMISS PIPE
always_ff @(posedge clk) begin
// 1ST STAGE
miss1 <= miss;
PCnew1 <= PCnew0;
// 2ND STAGE
miss2 <= miss1;
PCnew2 <= PCnew1;
// 3RD STAGE
miss3 <= miss2;
PCnew3 <= PCnew2;
// 4TH STAGE
miss4 <= miss3;
PCnew4 <= PCnew3;
// 5TH STAGE
miss5 <= miss4;
PCnew5 <= PCnew4;
// 6TH STAGE
miss6 <= miss5;
PCnew6 <= PCnew5;
// FETCHING STAGE
miss7 <= miss6;
BlockHere <= PCnew6;
end

// INSTRUCTION CACHE
always_ff @(posedge clk) begin

Instruction1i <= Block[PC1[25:29]];
Instruction2i <= Block[PC2[25:29]];

if ((miss7 == 1) & ( miss == 1) & (PCnew0 == BlockHere)) begin
	Block [0:31] <= NewBlock;
end
else begin
	Block <= Block;
end
end

// LSR
always_ff @(posedge clk) begin
	data_out <= mem[addr];
if (wr_en) begin
	mem[addr[15:27]] <= data_in;
end
end

// LSR FOR INSTRUCTIONS 
always_ff @(posedge clk) begin
if ( enable == 1) begin
	NewBlock <= InstructionMemory[{17'd0,PCnew,5'b00000}:{17'd0,PCnew,5'b11111}];
end
else begin
	NewBlock <= NewBlock;
end
end


endmodule
