module Hazard_Detection_Unit(MemReadEn_IDEX, MemReadEn_EXMEM, writeRegister_EXMEM, 
							writeRegister_IDEX, rs, rt, Slt, Sgt,
							Slt_IDEX, Sgt_IDEX,
							flush, PCwrite, Write_IFID, nopSel, Jump, JumpReg, BranchEqual,
							BranchNotEqual, willBranch, willJump, HasStalled, HasStalled_IDEX);

	input [4:0] rs, rt, writeRegister_EXMEM, writeRegister_IDEX;
	input  Slt_IDEX, Sgt_IDEX, Slt, Sgt, MemReadEn_EXMEM, MemReadEn_IDEX, JumpReg, BranchEqual,
			Jump, BranchNotEqual;
	input willBranch, willJump, HasStalled_IDEX;
	
	reg StallCondition;
	wire FlushCondition;
		
	assign FlushCondition = ((willBranch) || (JumpReg) || Jump) && ~StallCondition;

//Load Use
	 wire FirstStallCondition = (MemReadEn_IDEX 
		&& (writeRegister_IDEX != 5'b0)
		&& ((writeRegister_IDEX == rs) || (writeRegister_IDEX == rt)));

//Cannot Resolve Branch
	 wire SecondStallCondition =  ((writeRegister_IDEX == rs) || (writeRegister_IDEX == rt))
							&& (writeRegister_IDEX != 5'b0) 
							&& ((BranchEqual || BranchNotEqual || JumpReg || Slt || Sgt) && (!Slt_IDEX && !Sgt_IDEX));

	output reg PCwrite, Write_IFID, nopSel, flush, HasStalled;
	

	wire [1:0] Conditions = {StallCondition, FlushCondition};

	
	always @(*) begin
		HasStalled = 0;
		StallCondition = 0;
	if (FirstStallCondition)
		StallCondition = 1'b1;
	else if (SecondStallCondition && !HasStalled_IDEX) begin
		StallCondition = 1'b1; 
		HasStalled = 1'b1;
	end
	end

	
	always @(*) begin
		PCwrite <= 1'b1;
		Write_IFID <= 1'b1;
		nopSel <= 1'b0;
		flush <= 1'b0;

		case (Conditions)
		2'b10: begin: STALL  	
		PCwrite <= 1'b0;
		Write_IFID <= 1'b0;
		nopSel <= 1'b1;
		flush <= 1'b0;
		end

		2'b01: begin: FLUSH 
		PCwrite <= 1'b1;
		Write_IFID <= 1'b1;
		nopSel <= 1'b0;
		flush <= 1'b1;
		end

endcase
	end 

endmodule