module programCounter (clk, rst, PCwrite, PCin, PCout);
	
	//inputs
	input clk, rst, PCwrite;
	input [7:0] PCin;
	
	//outputs 
	output reg [7:0] PCout;
	
   //Counter logic
	always@(posedge clk, negedge rst) begin
		if (~rst) begin
			PCout <= 8'b11111111;
		end
		else begin
			if (PCwrite)
			PCout <= PCin;
			else;	
		end
		
	end
endmodule
