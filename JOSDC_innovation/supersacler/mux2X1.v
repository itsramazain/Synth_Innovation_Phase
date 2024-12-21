module mux2X1 #(parameter size = 32) (data0x, data1x, sel, out);

	// inputs	
	input sel;
	input [size - 1 :0] data0x, data1x;
	
	// outputs
	output [size - 1 :0] out;

	// Unit logic
	assign out = (~sel) ? data0x : data1x;
	// 0 : 1 data0x
endmodule

