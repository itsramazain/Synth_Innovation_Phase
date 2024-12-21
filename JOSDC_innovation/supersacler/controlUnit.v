module controlUnit(opCode, funct,
                RegDst, Link, BranchEqual,
                MemReadEn, MemtoReg,MemWriteEn,
                RegWriteEn, ALUSrc, Jump, BranchNotEqual,
                JumpReg, opSel, Slt, Sgt);

    input wire [5:0] opCode,funct;        
    output reg RegDst, BranchEqual, Link, MemReadEn, MemtoReg,
                MemWriteEn, RegWriteEn, ALUSrc, Jump, BranchNotEqual,
                JumpReg, Sgt, Slt;
    output reg [3:0] opSel;          

    // Opcode Parameters
    parameter _RType = 6'h0, _addi = 6'h8, _lw = 6'h23, _sw = 6'h2b, _beq = 6'h4, _bne = 6'h5;
    parameter _ori = 6'hd, _xori = 6'he, _andi = 6'hc,  _jump = 6'h2, _jumpandlink = 6'h3;

    // Funct field parameters
    parameter _add_ = 6'h20, _sub_ = 6'h22, _and_ = 6'h24, _or_ = 6'h25, _slt_ = 6'h2a;
    parameter _nor_ = 6'h27, _sll_ = 6'h0, _srl_ = 6'h2, _jr_ = 6'h8, _xor_ = 6'h26, _sgt_ = 6'h2b;
    
	 parameter _ADD = 4'b0000, _SUB = 4'b0001, _AND = 4'b0010, _OR = 4'b0011, _SLT = 4'b0100;
     parameter _XOR = 4'b0101, _NOR = 4'b0110, _SLL = 4'b0111, _SRL = 4'b1111, _SGT=4'b1000;

    always @(*) begin
        // Default control signal values to avoid latches
		  
        RegDst = 1'b0; BranchEqual = 1'b0; MemReadEn = 1'b0; MemtoReg = 1'b0;
        MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 1'b0; Jump = 1'b0;
        BranchNotEqual = 1'b0; JumpReg = 1'b0; opSel = 4'b0000;
        Link = 0; Sgt=0; Slt=0;
		  
        case (opCode)
            _RType: begin
                RegDst = 1'b1;
                RegWriteEn = 1'b1;
                ALUSrc = 1'b0;
                case (funct)
                    _add_: opSel = _ADD;
                    _sub_: opSel = _SUB;
                    _and_: opSel = _AND;
                    _or_:  opSel = _OR;
                    _slt_: begin 
							opSel = _SLT;
							Slt = 1;
						   end
                    _xor_: opSel = _XOR;
                    _nor_: opSel = _NOR;
                    _sll_: opSel = _SLL;
                    _srl_: opSel = _SRL;
                    _sgt_: 
						  begin 
						  opSel = _SGT;
						  Sgt = 1;
						  end
                    _jr_:   begin
                            JumpReg = 1'b1;
                            opSel = 4'bxxxx; 
                            end						  
                    default: begin
									opSel = 4'bxxxx; 
                            JumpReg = 1'b0;
                            Sgt = 1'b0;
                            Slt = 1'b0;
									 end
                endcase
            end
            _addi: begin
                RegDst = 1'b0;
                ALUSrc = 1'b1;
                RegWriteEn = 1'b1;
                opSel = _ADD;
            end
            _andi: begin
                ALUSrc = 1'b1;
                RegWriteEn = 1'b1;
                opSel = _AND;
            end
            _ori: begin
                ALUSrc = 1'b1;
                RegWriteEn = 1'b1;
                opSel = _OR;
            end
            _xori: begin
                ALUSrc = 1'b1;
                RegWriteEn = 1'b1;
                opSel = _XOR;
            end
            _lw: begin
                MemReadEn = 1'b1;
                MemtoReg = 1'b1;
                RegWriteEn = 1'b1;
                ALUSrc = 1'b1;
                opSel = _ADD;
            end
            _sw: begin
                MemWriteEn = 1'b1;
                ALUSrc = 1'b1;
                opSel = _ADD;
            end
            _beq: begin
                BranchEqual = 1'b1;
            end
            _bne: begin
                BranchNotEqual = 1'b1;
            end
            _jump:  begin
                Jump = 1'b1;
            end
            _jumpandlink: begin
                Jump = 1'b1;
                RegWriteEn = 1'b1;
                Link = 1'b1;
            end
            default: begin
        RegDst = 1'b0; BranchEqual = 1'b0; MemReadEn = 1'b0; MemtoReg = 1'b0;
        MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 1'b0; Jump = 1'b0;
        BranchNotEqual = 1'b0; JumpReg = 1'b0; opSel = 4'b0000;
        Link = 0; Sgt=0; Slt=0;
            end
        endcase
    end
endmodule


