module ALU (operand1, operand2, opSel, result, shamt );
	
	parameter data_width = 32;
	parameter sel_width = 4;
	
	input [data_width - 1 : 0] operand1, operand2;
	input [sel_width - 1 :0] opSel;
	input [4:0] shamt;

	
	output reg [data_width - 1 : 0] result;
		
	// Operation Parameters
	
	parameter   _ADD = 4'b0000, _SUB = 4'b0001, _AND = 4'b0010,
			_OR = 4'b0011, _SLT = 4'b0100, _SGT = 4'b1000,
			_XOR = 4'b0101, _NOR = 4'b0110, _SLL = 4'b0111,
			_SRL = 4'b1111;
			
	// Perform Operation
	
	always @ (*) begin 
		
		case(opSel)
			
			_ADD: result = operand1 + operand2;
			
			_SUB: result = operand1 - operand2;
			
			_AND: result = operand1 & operand2;
			
			_OR : result = operand1 | operand2;
			
			_SLT: result = ($signed(operand1) < $signed(operand2)) ? 1 : 0; 

			_SGT: result = ($signed(operand1) > $signed(operand2)) ? 1 : 0;
			
			_XOR: result = operand1 ^ operand2;

			_NOR: result = ~ (operand1 | operand2);

			_SLL: result = operand2 >> shamt;

			_SRL: result = operand2 << shamt;
						
			default: result = 32'hxxxxxxxx;

		endcase
	
	end

endmodule
