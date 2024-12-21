module mux3X1 #(parameter size = 32) (data0x, data1x, data2x, sel, out);

	// inputs	
	input [1:0] sel;
	input [size - 1 :0] data0x, data1x, data2x;
	
	// outputs
	output reg [size - 1 :0] out;

	// Unit logic
	always @(*) begin
		case(sel)
		2'b00: out = data0x;
		2'b01: out = data1x;
		2'b10: out = data2x;
		default: out = {size{1'b0}};
		endcase
	end
	
endmodule
