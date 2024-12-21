module processor(clk, rst, PC);

	//inputs
	input clk, rst;
	
	//outputs
	output [7:0] PC;

	wire [31:0] instruction, writeData, readData1, readData2, extImm, 
				ALUin2, ALUin1, _ALUResult, ALUResult, memoryReadData, rtData, rsData,
				instruction_IFID, readData1_IDEX, rsData_IDEX ,
				FWDrtData, rtData_IDEX, rtData_EXMEM, extImm_IDEX, FWDrtData_EXMEM,
				ALUResult_EXMEM, ALUResult_MEMWB, memoryReadData_MEMWB;
	wire [15:0] imm;
	wire [7:0]  PC, PCout, nextPC, PCPlus1, branch_address,
			   PCPlus1_IFID, PCPlus1_IDEX, jump_address, FWDvalue,
			   jump_to_address, PC_or_Branch;
	wire [5:0] opCode, funct;
	wire [4:0] rs, rt, rd, writeRegister, shamt, returnReg, rs_IDEX,
			   rt_IDEX, rd_IDEX, writeRegister_EXMEM, writeRegister_MEMWB,
			   writeRegister_IDEX, shamt_IDEX, writeRegister_rdrt;
	wire [3:0] _opSel, opSel, opSel_IDEX;
	wire [1:0] IDForwardA, IDForwardB, EXForwardA, EXForwardB;
	wire PCwrite, RegDst, Branch, MemReadEn, MemtoReg,
		 MemWriteEn, RegWriteEn, ALUSrc, ALUSrc_IDEX,
		 JumpReg, Jump, Link, Link_IDEX, flush, zero, nopSel,
		 willBranch, willJump, BranchNotEqual, BranchEqual, Write_IFID, Sgt, Slt, 
		 Slt_IDEX, Sgt_IDEX, lessthan, greaterthan, 
		 lessthan_IDEX, greaterthan_IDEX,
		 RegDst_IDEX, MemReadEn_IDEX, MemReadEn_EXMEM, 
		 MemtoReg_IDEX, MemtoReg_EXMEM, MemtoReg_MEMWB, MemWriteEn_IDEX, MemWriteEn_EXMEM,
		 RegWriteEn_IDEX, RegWriteEn_EXMEM, RegWriteEn_MEMWB, PassALU,
		 _RegDst, _Link, _BranchEqual,
				_MemReadEn, _MemtoReg, _MemWriteEn,
				_RegWriteEn, _ALUSrc, _Jump, _BranchNotEqual,
				_JumpReg, _Slt, _Sgt, HasStalled, HasStalled_IDEX;

	

	assign opCode = instruction_IFID[31:26];
	assign rs = instruction_IFID[25:21];
	assign rt = instruction_IFID[20:16];
	assign rd = instruction_IFID[15:11];
	assign shamt = instruction_IFID[10:6];
	assign imm = instruction_IFID[15:0];
	assign funct = instruction_IFID[5:0];
	assign returnReg = 5'b11111;
	assign jump_address = instruction_IFID[7:0];
	assign PassALU = Link_IDEX || Slt_IDEX || Sgt_IDEX;
	
// ==================================================================================================================== 
// IF stage
// ==================================================================================================================== 
programCounter pc(.clk(clk), .PCwrite(PCwrite), .rst(rst), .PCin(PC), .PCout(PCout));

instructionMemory IM(.address(PC), .clock(clk), .q(instruction));

adder PCAdder(.in1(PCout), .in2(8'b1), .out(PCPlus1));

mux2X1 #(.size(8))
		  BranchMux(.data0x(PCPlus1),
					.data1x(branch_address),
					.sel(willBranch),
					.out(PC_or_Branch));
mux2X1 #(.size(8))
		JumpSelection(.data0x(jump_address),
						.data1x(rsData[7:0]),
						.sel(_JumpReg),
						.out(jump_to_address));

mux2X1 #(.size(8))
		  PCMux(.data0x(PC_or_Branch),
				.data1x(jump_to_address),
		   		.sel(willJump),
				.out(nextPC));

mux2X1 #(.size(8))
		  NextPCMux(.data0x(PCout),
				.data1x(nextPC),
		   		.sel(PCwrite),
				.out(PC));

// ====================================================================================================================  
// ID stage
// ==================================================================================================================== 
IF_ID IFID_register(clk, rst, flush, PCPlus1,
					PCPlus1_IFID, instruction, instruction_IFID, Write_IFID);

adder branchAdder(.in1(PCPlus1_IFID), .in2(extImm[7:0]), .out(branch_address));

registerFile RF(.clk(clk), .rst(rst), .we(RegWriteEn_MEMWB), 
					    .readRegister1(rs), .readRegister2(rt), .writeRegister(writeRegister_MEMWB),
					    .writeData(writeData), .readData1(readData1), .readData2(readData2));	

SignExtender SignExtend(.in(imm), .out(extImm));

branch_detection_unit BranchDetectionUnit(_BranchEqual, _BranchNotEqual, zero,
_JumpReg, _Jump, willJump, willBranch);

comparator comparator(rsData, rtData, zero, lessthan, greaterthan);

controlUnit ControlUnit(opCode, funct,
                _RegDst, _Link, _BranchEqual,
                _MemReadEn, _MemtoReg, _MemWriteEn,
                _RegWriteEn, _ALUSrc, _Jump, _BranchNotEqual,
                _JumpReg, _opSel, _Slt, _Sgt);

mux2X1 #(.size(17)) 
		StallMUX(.data0x ({_RegDst, _Link, _BranchEqual,
				_MemReadEn, _MemtoReg, _MemWriteEn,
				_RegWriteEn, _ALUSrc, _Jump, _BranchNotEqual,
				_JumpReg, _opSel, _Slt, _Sgt}),
				.data1x (17'b0),
				.sel(nopSel),
				.out ({RegDst, Link, BranchEqual,
					MemReadEn, MemtoReg, MemWriteEn,
					RegWriteEn, ALUSrc, Jump, BranchNotEqual,
					JumpReg, opSel, Slt, Sgt}));
	
Hazard_Detection_Unit HazardDetectionUnit(MemReadEn_IDEX, MemReadEn_EXMEM, writeRegister_EXMEM, 
							writeRegister_IDEX, rs, rt, _Slt, _Sgt,
							Slt_IDEX, Sgt_IDEX,
							flush, PCwrite, Write_IFID, nopSel, _Jump, _JumpReg, _BranchEqual,
							_BranchNotEqual, willBranch, willJump, HasStalled, HasStalled_IDEX);			

forwarding_Unit_ID ForwardingUnitID(
						RegWriteEn_MEMWB, writeRegister_MEMWB, 
						RegWriteEn_EXMEM, writeRegister_EXMEM,
						writeRegister_IDEX, RegWriteEn_IDEX, 
						rs, rt, 
						Sgt_IDEX, Slt_IDEX,
						IDForwardA, IDForwardB
					);

fwdvalue fwdvalue(Link_IDEX, Slt_IDEX, Sgt_IDEX,
                 PCPlus1_IDEX, greaterthan_IDEX, lessthan_IDEX,
                 FWDvalue);

mux4X1 #(.size(32))
		 RSfwdMUX (.data0x(readData1),
					.data1x(writeData),
					.data2x(ALUResult_EXMEM),
					.data3x({24'b0,FWDvalue}),
					.sel(IDForwardA),
					.out(rsData));

mux4X1 #(.size(32))
		 RTfwdMUX (.data0x(readData2),
					.data1x(writeData),
					.data2x(ALUResult_EXMEM),
					.data3x({24'b0,FWDvalue}),
					.sel(IDForwardB),
					.out(rtData));


mux2X1 #(.size(5))
		RtRdMux(.data0x(rt),
					.data1x(rd),
					.sel(_RegDst),
					.out(writeRegister_rdrt));

mux2X1 #(.size(5))
		WriteRegMux(.data0x(writeRegister_rdrt),
					.data1x(returnReg),
					.sel(_Link),
					.out(writeRegister));


ID_EX IDEX_register(clk, rst, rs, rt, rsData, rtData, extImm,  shamt, 
				MemtoReg, MemReadEn, MemWriteEn, opSel, ALUSrc,
				RegWriteEn, Link, writeRegister, PCPlus1_IFID,
				lessthan, Slt, greaterthan, Sgt, HasStalled,
				rs_IDEX, rt_IDEX, rsData_IDEX, rtData_IDEX, 
				extImm_IDEX,  shamt_IDEX, MemtoReg_IDEX, MemReadEn_IDEX, 
				MemWriteEn_IDEX, opSel_IDEX, ALUSrc_IDEX, RegWriteEn_IDEX,
				Link_IDEX, writeRegister_IDEX, PCPlus1_IDEX,
				lessthan_IDEX, Slt_IDEX, greaterthan_IDEX, Sgt_IDEX, HasStalled_IDEX);
// ====================================================================================================================  
// EX stage
// ==================================================================================================================== 
ALU alu(.operand1(ALUin1), .operand2(ALUin2),
			.opSel(opSel_IDEX), .shamt(shamt_IDEX), .result(_ALUResult));
	
			
forwarding_Unit_EX ForwardingUnitEX(
							RegWriteEn_MEMWB,
							writeRegister_MEMWB,
							RegWriteEn_EXMEM,
							writeRegister_EXMEM,
							rs_IDEX,
							rt_IDEX,
							EXForwardA,
							EXForwardB);

mux3X1 #(.size(32))
		 ALUMUX1 (.data0x(rsData_IDEX),
					.data1x(writeData),
					.data2x(ALUResult_EXMEM),
					.sel(EXForwardA),
					.out(ALUin1));

mux3X1 #(.size(32))
		 RTDATAMUX (.data0x(rtData_IDEX),
					.data1x(writeData),
					.data2x(ALUResult_EXMEM),
					.sel(EXForwardB),
					.out(FWDrtData));

mux2X1 #(.size(32))
		 ALUMUX2 (.data0x(FWDrtData),
		 			.data1x(extImm_IDEX),
					.sel(ALUSrc_IDEX),
					.out(ALUin2));

mux2X1 #(.size(32))
		 ALUResultFWDvalue(.data0x(_ALUResult),
		 					.data1x({24'b0,FWDvalue}),
		   					.sel(PassALU),
							.out(ALUResult));	

EX_MEM EXMEM_register(clk, rst, writeRegister_IDEX, ALUResult, 
            			FWDrtData, MemtoReg_IDEX, RegWriteEn_IDEX, MemReadEn_IDEX, MemWriteEn_IDEX, 
            			writeRegister_EXMEM, ALUResult_EXMEM, FWDrtData_EXMEM,
            			MemtoReg_EXMEM, RegWriteEn_EXMEM,
						MemReadEn_EXMEM, MemWriteEn_EXMEM);
// ====================================================================================================================  
// MEM stage
// ==================================================================================================================== 
dataMemory DM(.address(ALUResult_EXMEM[7:0]), .clock(~clk),
			  .data(FWDrtData_EXMEM), .rden(MemReadEn_EXMEM), .wren(MemWriteEn_EXMEM),
			  .q(memoryReadData));
	
MEM_WB MEMWB_register(clk, rst, writeRegister_EXMEM, ALUResult_EXMEM,  
            		 	memoryReadData, MemtoReg_EXMEM, RegWriteEn_EXMEM,
            			writeRegister_MEMWB, ALUResult_MEMWB, memoryReadData_MEMWB,
            			MemtoReg_MEMWB, RegWriteEn_MEMWB);

// ====================================================================================================================  
// WB stage
// ==================================================================================================================== 
mux2X1 #(.size(32))
			WBMux(.data0x(ALUResult_MEMWB),
				 .data1x(memoryReadData_MEMWB),
				 .sel(MemtoReg_MEMWB),
				 .out(writeData));	

endmodule