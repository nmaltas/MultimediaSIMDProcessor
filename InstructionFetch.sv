module InstructionFetch (clk, Wait, Stall, Flush, reset, Instruction1i, Instruction2i, Instruction1, Instruction2, PC1, PC2, PCBranch, missback, BlockTag, done, miss, BlockHere);

// INPUT SIGNALS
input logic clk, Wait, Stall, Flush, reset, missback;
input logic [0:31] Instruction1i;
input logic [0:31] Instruction2i;
input logic [0:31] PCBranch;
input logic [0:9] BlockHere;

// OUTPUT SIGNALS
output logic done, miss;
output logic [0:31] Instruction1;
output logic [0:31] Instruction2;
output logic [0:31] PC1;
output logic [0:31] PC2;
output logic [0:9] BlockTag;

// INTERNAL SIGNALS
logic [0:31] PC;
logic State;



// DATAPATH
always_ff @(posedge clk) begin
if ((miss == 1 ) & (Instruction1i[0:10] != 11'b00011111111) &(Instruction2i[0:10] != 11'b00011111111)) begin
Instruction1 <= 32'h1FFFFFFF;
Instruction2 <= 32'h1FFFFFFF;
end
else begin
Instruction1 <= Instruction1i;
Instruction2 <= Instruction2i;
end
end


// EVEN - ODD DIFFERENTIATION
always_comb begin
PC1 = PC;
PC2 = PC+32'd4;
end

// FSM
always_ff @(posedge clk) begin
case (State)
	
	// REGULAR STATE
	1'b0 : begin
	// RESET
	if (reset == 1) begin
		State <= 1;
		PC <= 0;
		miss <= 1;
		done <= 0;
		BlockTag <= 10'd0;
	end
	// STALL/WAIT
	else if (Stall == 1 | Wait ==1 ) begin
		State <= 0;
		PC <= PC;
		miss <=0;
		done <= 0;
		BlockTag <= BlockTag;
	end
	// FLUSH
	else if (Flush == 1) begin
		done <= 0;
		if (PCBranch[15:24]  == PC[15:24] ) begin
			State <= 0;
			PC <= PCBranch;
			miss <= 0;
			BlockTag <= BlockTag;
		end
		else begin
			State <= 1;
			miss <= 1;
			PC <= PC;
			BlockTag <= PCBranch[15:24];
		end
	end
	// STOP
	else if (Instruction1i[0:10] == 11'b00000000000 | Instruction2i[0:10] == 11'b00000000000) begin
		State <= 0;
		PC <= PC;
		miss <=0;
		done <= 1;
		BlockTag <= BlockTag;
	end
	// IMISS 1
	else if (Instruction1i[0:10] == 11'b00011111111) begin
		State <= 1;
		done <= 0;
		miss <= 1;
		PC <= {15'd0,Instruction1i[11:20],7'd0};
		BlockTag <= Instruction1i[11:20];
	end
	// IMISS 2
	else if ( Instruction2i[0:10] == 11'b00011111111) begin
		State <= 1;
		done <= 0;
		miss <= 1;
		PC <= PC;
		BlockTag <= {15'd0,Instruction2i[11:20],7'd0};
	end
	else if ( PC[25:29] == 5'b11111) begin
		State <= 1;
		done <= 0;
		miss <= 1;
		PC <= PC+32'd8;
		BlockTag <= PC[15:24] + 10'd1;
	end
	// NORMAL PROCEDURE
	else begin
		BlockTag <= BlockTag;
		State <= 0;
		PC <= PC + 32'd8;
		miss <= 0;
		done <= 0;
	end
	end

	// MISS STATE
	1'b1: begin
	// RESET
	if (reset == 1) begin
		State <= 1;
		PC <= 0;
		miss <= 1;
		done <= 0;
		BlockTag <= 10'd0;
	end
	// FLUSH 
	else if ( Flush == 1) begin
		done <= 0;
		if (PCBranch[15:24]  == PC[15:24] ) begin
			State <= 0;
			PC <= PCBranch;
			miss <= 0;
			BlockTag <= BlockTag;
		end
		else begin
			State <= 0;
			miss <= 1;
			PC <= PC;
			BlockTag <= PCBranch[15:24];
		end
	end
	// EXIT MISS STATE
	else begin
		BlockTag <= BlockTag;
		if ((miss == 1) & (missback == 1) & (BlockHere == BlockTag)) begin
			State <= 0;
			done <=0;
			miss <= 0;
			PC <= PC+32'd8;
		end
		else begin 
			State <= 1;
			done <=0;
			miss <= 1;
			PC <= PC;
		end
	end
	end
	
	default : begin
	State <= 1;
	PC <= 0;
	miss <= 1;
	done <= 0;
	BlockTag <= 32'd0;
	end
endcase
end



endmodule
