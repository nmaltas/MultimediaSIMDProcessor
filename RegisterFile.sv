module RegisterFile #(
parameter  WIDTH = 128, SIZE =  128, LOGSIZE = 7
)
(clk, Flush, WBE, WBO,  PCIn, PCOut,
AddressE,  E1, E2, E3, CSEI, CSE, RAE, RBE, RCE, RTE, DataE, AddressEi, ImmediateE, ForwardE1, ForwardE2, ForwardE3,
AddressO, O1, O2, O3, CSOI, CSO, RAO, RBO, RCO, RTO, DataO, AddressOi, ImmediateO, ForwardO1, ForwardO2, ForwardO3);

// INPUT SIGNALS
input logic clk, Flush, WBE, WBO;
input logic [0:6] RAE;
input logic [0:6] RBE;
input logic [0:6] RCE;
input logic [0:6] RTE;
input logic [0:6] RAO;
input logic [0:6] RBO;
input logic [0:6] RCO;
input logic [0:6] RTO;
input logic [0:7] CSEI;
input logic [0:7] CSOI;
input logic [0:31] ImmediateE;
input logic [0:31] ImmediateO;
input logic [0:31] PCIn;
input logic [0:6] AddressEi;
input logic [0:6] AddressOi;
input logic [0:127] DataE;
input logic [0:127] DataO;
input logic [0:4] ForwardE1;
input logic [0:4] ForwardE2;
input logic [0:4] ForwardE3;
input logic [0:4] ForwardO1;
input logic [0:4] ForwardO2;
input logic [0:4] ForwardO3;

// OUTPUT SIGNALS
output logic [0:6] AddressE;
output logic [0:6] AddressO;
output logic [0:7] CSE;
output logic [0:5] CSO;
output logic [0:127] E1;
output logic [0:127] E2;
output logic [0:127] E3;
output logic [0:127] O1;
output logic [0:127] O2;
output logic [0:127] O3;
output logic [0:31] PCOut;

// INTERNAL SIGNALS
logic [0:127] E01;
logic [0:127] E02;
logic [0:127] E03;
logic [0:127] O01;
logic [0:127] O02;
logic [0:127] O03;



///////////////////////////////////////////////////
// MEMORY SIGNALS
logic [0: WIDTH-1] data_outE1;
logic [0:WIDTH-1] data_outE2;
logic [0:WIDTH-1] data_outE3;
logic [0:WIDTH-1] data_outO1;
logic [0:WIDTH-1] data_outO2;
logic [0:WIDTH-1] data_outO3;
logic [0:SIZE-1] [0:WIDTH-1] mem;
//////////////////////////////////////////////////

// OUTPUT X-ROAD INTERFACING 
always_comb begin

// SELECTING IMMEDIATES
// ODD PIPE MULTIPLEXING
casex (CSO)
	// BRANCH RELATIVE
	6'b100100 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;
	end
	
	// BRANCH ABSOLUTE
	6'b100101 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end

	// BRANCH IF ZERO
	6'b100110 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;		
	end

	// BRANCH IF NOT ZERO
	6'b100111 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;
	end

	// BRANCH RELATIVE AND SET LINK
	6'b101001 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// BRANCH RELATIVE AND SET LINK
	6'b101000 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// IMMEDIATE LOAD ADDRESS
	6'b110010 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// IMMEDIATE LOAD WORD
	6'b110001 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// LOAD QUADWORD A-FORM
	6'b110011 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// LOAD QUADWORD D-FORM
	6'b110100 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// STORE QUADWORD D-FORM
	6'b110111 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// STORE QUADWORD A-FORM
	6'b110110 : begin
	O01 = {4{ImmediateO}};
	O02 = data_outO2;
	O03 = data_outO3;	
	end
	
	// SHIFT LEFT QUADWORD BY BITS IMMEDIATE
	6'b01x010 : begin
	O01 = data_outO1;
	O02 = {4{ImmediateO}};
	O03 = data_outO3;	
	end
	
	// ROTATE QUADWORD BY BITS IMMEDIATE
	6'b01x100 : begin
	O01 = data_outO1;
	O02 = {4{ImmediateO}};
	O03 = data_outO3;
	end
	
	default : begin
	O01 = data_outO1;
	O02 = data_outO2;
	O03 = data_outO3;	
	end
endcase

// EVEN PIPE MULTIPLEXING
casex (CSE)
// AND BYTES IMMEDIATE
	8'b100x0001 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
	
// OR BYTES IMMEDIATE
	8'b100x0010 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// XOR BYTES IMMEDIATE
	8'b100x0011 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// COMPARE EQUAL BYTES IMMEDIATE
	8'b100x1100 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// COMPARE GREATER THAN BYTES IMMEDIATE
	8'b100x1101 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// ADD WORD IMMEDIATE
	8'b10100010 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
		
// AND WORD IMMEDIATE
	8'b10101100 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
		
// COMPARE EQUAL IMMEDIATE
	8'b10110010 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// COMPARE GREATER THAN IMMEDIATE
	8'b10110100 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// OR WORD IMMEDIATE
	8'b10101110 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
	
// XOR WORD IMMEDIATE
	8'b10101111 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
	
// MULTIPLY WORD IMMEDIATE
	8'b1010111 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end	

// SUBTRACT WORD FROM IMMEDIATE
	8'b10100111 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end

// SHIFT LEFT WORD IMMEDIATE
	8'b110x0100 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
	
// ROTATE WORD IMMEDIATE
	8'b110x0010 : begin
	E01 = data_outE1;
	E02 = {4{ImmediateE}};
	E03 = data_outE3;
	end
	
	default : begin
	E01 = data_outE1;
	E02 = data_outE2;
	E03 = data_outE3;
	end
endcase

// FORWARDING MULTIPLEXING MODULE
// FORWARDING FOR E1
case (ForwardE1)
// FORWARDING DATAE
	5'b01010 : E1 = DataE;
	
// FORWARDING DATAO
	5'b11000 : E1 = DataO;
	
	default : E1 = E01;
	
endcase

// FORWARDING FOR E2
case (ForwardE2)
// FORWARDING DATAE
	5'b01010 : E2 = DataE;

// FORWARDING DATAO
	5'b11000 : E2 = DataO;
	
	default : E2 = E02;
	
endcase

// FORWARDING FOR E3
case (ForwardE3)
// FORWARDING DATAE
	5'b01010 : E3 = DataE;

// FORWARDING DATAO
	5'b11000 : E3 = DataO;
	
	default : E3 = E03;
	
endcase

// FORWARDING FOR O1
case (ForwardO1)
// FORWARDING DATAE
	5'b01010 : O1 = DataE;

// FORWARDING DATAO
	5'b11000 : O1 = DataO;
	
	default : O1 = O01;
	
endcase

// FORWARDING FOR O2
case (ForwardO2)
// FORWARDING DATAE
	5'b01010 : O2 = DataE;

// FORWARDING DATAO
	5'b11000 : O2 = DataO;
	
	default : O2 = O02;
	
endcase

// FORWARDING FOR O3
case (ForwardO3)
// FORWARDING DATAE
	5'b01010 : O3 = DataE;

// FORWARDING DATAO
	5'b11000 : O3 = DataO;
	
	default : O3 = O03;
	
endcase


end

// REGISTER MEMORY
always_ff @(posedge clk) begin
data_outE1 <= mem[RAE];
data_outE2 <= mem[RBE];
data_outE3 <= mem[RCE];
data_outO1 <= mem[RAO];
data_outO2 <= mem[RBO];
data_outO3 <= mem[RCO];
if (WBE) begin
mem[AddressEi] <= DataE;
end
if (WBO) begin
mem[AddressOi] <= DataO;
end
end


// SECONDARY SIGNAL PROPAGATION
always_ff @(posedge clk) begin
if (Flush == 1) begin
	CSO <= 8'b00000000;
	CSE <= 6'b000000;
	
	PCOut <= 0;
	
	AddressE <= 0;
	AddressO <= 0;
end
else begin
	CSO <= CSOI[2:7];
	CSE <= CSEI;

	PCOut <= PCIn;

	AddressE <= RTE;
	AddressO <= RTO;
end
end



endmodule