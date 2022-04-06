module DecodeStage (clk, Flush, Instruction1, Instruction2, PCIn, PC, RAE, RBE, RCE, RTE, CSE, ImmediateE, RAO, RBO, RCO, RTO, CSO, ImmediateO, Wait, Stall, done);

// INPUT SIGNALS
input logic clk, Flush, Stall, done;
input logic [0:31] Instruction1;
input logic [0:31] Instruction2;
input logic [0:31] PCIn;

// OUTPOUT SIGNALS
output logic [0:6] RAE;
output logic [0:6] RBE;
output logic [0:6] RCE;
output logic [0:6] RTE;
output logic [0:7] CSE;
output logic [0:31] ImmediateE;
	
output logic [0:6] RAO;
output logic [0:6] RBO;
output logic [0:6] RCO;
output logic [0:6] RTO;
output logic [0:7] CSO;
output logic [0:31] ImmediateO;

output logic [0:31] PC;
output logic Wait;


// INTERNAL SIGNALS
logic miss1, miss2, stop1, stop2, check;
logic [0:1] OneTwo;
logic [0:1] State;
logic [0:31] PC0;

logic [0:6] RA1;
logic [0:6] RB1;
logic [0:6] RC1;
logic [0:6] RT1;
logic [0:8] CS1;
logic [0:31] Immediate1;

logic [0:6] RA2;
logic [0:6] RB2;
logic [0:6] RC2;
logic [0:6] RT2;
logic [0:8] CS2;
logic [0:31] Immediate2;

logic [0:6] RAE0;
logic [0:6] RBE0;
logic [0:6] RCE0;
logic [0:6] RTE0;
logic [0:7] CSE0;
logic [0:31] ImmediateE0;

logic [0:6] RAO0;
logic [0:6] RBO0;
logic [0:6] RCO0;
logic [0:6] RTO0;
logic [0:7] CSO0;
logic [0:31] ImmediateO0;

logic [0:6] RAW;
logic [0:6] RBW;
logic [0:6] RCW;
logic [0:6] RTW;
logic [0:7] CSW;
logic [0:31] ImmediateW;



// DECODE MODULE INSTANTIATION
DecodeModule Decode1 (Instruction1, RA1, RB1, RC1, RT1, CS1, Immediate1, stop1, miss1);
DecodeModule Decode2 (Instruction2, RA2, RB2, RC2, RT2, CS2, Immediate2, stop2, miss2);



// OUTPUT ASSERTION
always_comb begin
RAE = RAE0;
RBE = RBE0;
RCE = RCE0;
RTE = RTE0;
//CSE = CSE0;
ImmediateE = ImmediateE0;
	
RAO = RAO0;
RBO = RBO0;
RCO = RCO0;
RTO = RTO0;
//CSO = CSO0;
ImmediateO = ImmediateO0;

PC = PC0;

// MISS/STOP IMPLICATION
if (miss1 == 1 | stop1 ==1) begin
	CSE = CSE0;
	CSO = 9'b000000000;
end
else if ( (miss2 ==1 | stop2 ==1 ) & ( check ==0) ) begin
	CSE = CSE0;
	CSO = CSO0;
end
else if ( (miss2 ==1 | stop2 ==1 ) & ( check ==1) ) begin
	CSE = 9'b000000000;
	CSO = CSO0;
end
else begin
	CSE = CSE0;
	CSO = CSO0;
end

end

//MISS/STOP CHECKING MODULE
always_ff @(posedge clk) begin
if (miss2 ==1 | stop2 ==1 )  begin
	check <= 1;
end
else begin
	check <= 0;
end
end


// ODD - EVEN INSTRUCTION DIFFERENTIATION
always_comb begin
if (CS1[0] == 0) begin
		OneTwo[0] <= 0;
	end
	else begin
		OneTwo[0] <= 1;
	end
	
	if (CS2[0] == 0) begin
		OneTwo[1] <= 0;
	end
else begin
		OneTwo[1] <= 1;
end
end


// FSM FOR ODD-EVEN INSTRUCTION ASSIGNMENT AND WAIT ASSERTION (WAW IS TAKEN CARE ALSO HERE)
always_ff @(posedge clk) begin

if (done == 1) begin
	State <= 2'b11;
	Wait <= 0;
	
	RAE0 <= 0;
	RBE0 <= 0;
	RCE0 <= 0;
	RTE0 <= 0;
	CSE0 <= 8'b00000000;
	ImmediateE0 <=  0;
		
	RAO0 <= 0;
	RBO0 <= 0;
	RCO0 <= 0;
	RTO0 <= 0;
	CSO0 <= 8'b00000000;
	ImmediateO0 <=  0;
		
	RAW <= 0;
	RBW <= 0;
	RCW <= 0;
	RTW <= 0;
	CSW <= 8'b00000000;
	ImmediateW <=  0;
	
	PC0 <= 0;
end
else if (Flush == 1) begin
	State <= 2'b11;
	Wait <= 0;
	
	RAE0 <= 0;
	RBE0 <= 0;
	RCE0 <= 0;
	RTE0 <= 0;
	CSE0 <= 8'b00000000;
	ImmediateE0 <=  0;
		
	RAO0 <= 0;
	RBO0 <= 0;
	RCO0 <= 0;
	RTO0 <= 0;
	CSO0 <= 8'b00000000;
	ImmediateO0 <=  0;
		
	RAW <= 0;
	RBW <= 0;
	RCW <= 0;
	RTW <= 0;
	CSW <= 8'b00000000;
	ImmediateW <=  0;
	
	PC0 <= 0;
end
else if (Stall == 1) begin
	State <= State;
	Wait <= 0;
	
	RAE0 <= RAE0;
	RBE0 <= RBE0;
	RCE0 <= RCE0;
	RTE0 <= RTE0;
	CSE0 <= CSE0;
	ImmediateE0 <=  ImmediateE0;
		
	RAO0 <= RAO0;
	RBO0 <= RBO0;
	RCO0 <= RCO0;
	RTO0 <= RTO0;
	CSO0 <= CSO0;
	ImmediateO0 <=  ImmediateO0;
		
	RAW <= RAW;
	RBW <= RBW;
	RCW <= RCW;
	RTW <= RTW;
	CSW <= CSW;
	ImmediateW <=  ImmediateW;
	
	PC0 <= PC0;
end
 else begin
case (State)

	2'b00 : begin
	if (OneTwo == 2'b01) begin
		if ( (RT1 == RT2) | ((RT1 == RA2) | (RT1 == RB2) | (RT1 == RC2)) ) begin
			State <= 2'b01;
			RAE0 <= RA1;
			RBE0 <= RB1;
			RCE0 <= RC1;
			RTE0 <= RT1;
			CSE0 <= CS1[1:8];
			ImmediateE0 <=  Immediate1;
			
			RAO0 <= 0;
			RBO0 <= 0;
			RCO0 <= 0;
			RTO0 <= 0;
			CSO0 <= 8'b00000000;
			ImmediateO0 <=  0;
			
			RAW <= RA2;
			RBW <= RB2;
			RCW <= RC2;
			RTW <= RT2;
			CSW <= CS2[1:8];
			ImmediateW <=  Immediate2;
		
			PC0 <= PCIn;
			Wait <= 1;
		end
		else begin
			State <= 2'b00;
			RAE0 <= RA1;
			RBE0 <= RB1;
			RCE0 <= RC1;
			RTE0 <= RT1;
			CSE0 <= CS1[1:8];
			ImmediateE0 <=  Immediate1;
			
			RAO0 <= RA2;
			RBO0 <= RB2;
			RCO0 <= RC2;
			RTO0 <= RT2;
			CSO0 <= CS2[1:8];
			ImmediateO0 <=  Immediate2;
			
			RAW <= 0;
			RBW <= 0;
			RCW <= 0;
			RTW <= 0;
			CSW <= 0;
			ImmediateW <=  0;
		
			PC0 <= PCIn;
			Wait <= 0;
		end
	end
	else if (OneTwo == 2'b10) begin
		if ((RT1 == RT2) | (( (RT1 == RA2) | (RT1 == RB2) | (RT1 == RC2) ) & ((CS1[3:4] == 01) | (CS2[3:7] == 10100) | (CS1[3:8] == 110001) | (CS1[3:8] == 110010) | (CS1[3:8] == 110011) | (CS1[3:8] == 110100) | (CS1[3:8] == 110101 ))))  begin
			State <= 2'b10;
			RAE0 <= 0;
			RBE0 <= 0;
			RCE0 <= 0;
			RTE0 <= 0;
			CSE0 <= 8'b00000000;
			ImmediateE0 <=  Immediate2;
			
			RAO0 <= RA1;
			RBO0 <= RB1;
			RCO0 <= RC1;
			RTO0 <= RT1;
			CSO0 <= CS1[1:8];
			ImmediateO0 <=  Immediate1;
			
			RAW <= RA2;
			RBW <= RB2;
			RCW <= RC2;
			RTW <= RT2;
			CSW <= CS2[1:8];
			ImmediateW <=  Immediate2;
		
			PC0 <= PCIn;
			Wait <= 1;
		end
		else begin
			State <= 2'b00;
			RAE0 <= RA2;
			RBE0 <= RB2;
			RCE0 <= RC2;
			RTE0 <= RT2;
			CSE0 <= CS2[1:8];
			ImmediateE0 <=  Immediate2;
				
			RAO0 <= RA1;
			RBO0 <= RB1;
			RCO0 <= RC1;
			RTO0 <= RT1;
			CSO0 <= CS1[1:8];
			ImmediateO0 <=  Immediate1;
				
			RAW <= 0;
			RBW <= 0;
			RCW <= 0;
			RTW <= 0;
			CSW <= 0;
			ImmediateW <=  0;
			
			PC0 <= PCIn;
			Wait <= 0;
		end
	end
	else if ( OneTwo == 2'b00) begin
		State <= 2'b10;
		RAE0 <= RA1;
		RBE0 <= RB1;
		RCE0 <= RC1;
		RTE0 <= RT1;
		CSE0 <= CS1[1:8];
		ImmediateE0 <=  Immediate1;
			
		RAO0 <= 0;
		RBO0 <= 0;
		RCO0 <= 0;
		RTO0 <= 0;
		CSO0 <= 8'b00000000;
		ImmediateO0 <=  0;
			
		RAW <= RA2;
		RBW <= RB2;
		RCW <= RC2;
		RTW <= RT2;
		CSW <= CS2[1:8];
		ImmediateW <=  Immediate2;
		
		PC0 <= PCIn;
		Wait <= 1;
	end
	else if ( OneTwo == 2'b11 ) begin
		State <= 2'b01;
		RAE0 <= 0;
		RBE0 <= 0;
		RCE0 <= 0;
		RTE0 <= 0;
		CSE0 <= 8'b00000000;
		ImmediateE0 <=  0;
		
		RAO0 <= RA1;
		RBO0 <= RB1;
		RCO0 <= RC1;
		RTO0 <= RT1;
		CSO0 <= CS1[1:8];
		ImmediateO0 <=  Immediate1;
		
		RAW <= RA2;
		RBW <= RB2;
		RCW <= RC2;
		RTW <= RT2;
		CSW <= CS2[1:8];
		ImmediateW <=  Immediate2;
		
		PC0 <= PCIn;
		Wait <= 1;
	end
	end
		
	// EVEN-EVEN
	2'b10 : begin 
	State <= 2'b00;
	RAE0 <= RAW;
	RBE0 <= RBW;
	RCE0 <= RCW;
	RTE0 <= RTW;
	CSE0 <= CSW;
	ImmediateE0 <=  ImmediateW;
	
	RAO0 <= 0;
	RBO0 <= 0;
	RCO0 <= 0;
	RTO0 <= 0;
	CSO0 <= 8'b00000000;
	ImmediateO0 <=  0;
	
	RAW <= 0;
	RBW <= 0;
	RCW <= 0;
	RTW <= 0;
	CSW <= 0;
	ImmediateW <=  0;
	
	PC0 <= PC0 +4;
	Wait <= 0;
	end
		
	// ODD-ODD
	2'b01 : begin
	State <= 2'b00;
	RAE0 <= 0;
	RBE0 <= 0;
	RCE0 <= 0;
	RTE0 <= 0;
	CSE0 <= 8'b00000000;
	ImmediateE0 <=  0;
		
	RAO0 <= RAW;
	RBO0 <= RBW;
	RCO0 <= RCW;
	RTO0 <= RTW;
	CSO0 <= CSW;
	ImmediateO0 <=  ImmediateW;
	
	RAW <= 0;
	RBW <= 0;
	RCW <= 0;
	RTW <= 0;
	CSW <= 0;
	ImmediateW <=  0;
	
	PC0 <= PC0 +4;
	Wait <= 0;
	end

	default : begin
	State <= 2'b00;
	RAE0 <= 0;
	RBE0 <= 0;
	RCE0 <= 0;
	RTE0 <= 0;
	CSE0 <= 8'b00000000;
	ImmediateE0 <=  0;
	
	RAO0 <= 0;
	RBO0 <= 0;
	RCO0 <= 0;
	RTO0 <= 0;
	CSO0 <= 8'b00000000;
	ImmediateO0 <=  0;
	
	RAW <= 0;
	RBW <= 0;
	RCW <= 0;
	RTW <= 0;
	CSW <= 8'b00000000;
	ImmediateW <=  0;
	
	PC0 <= PC0 +4;
	Wait <= 0;
	end
	
endcase
end

end


endmodule
