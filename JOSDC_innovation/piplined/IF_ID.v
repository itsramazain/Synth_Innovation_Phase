module IF_ID (clk, rst, flush, PCPlus1, PCPlus1_IFID,
                 instruction, instruction_IFID, Write_IFID);

input wire clk, rst, flush, Write_IFID;
input wire [7:0] PCPlus1;
input wire [31:0] instruction;

output reg [7:0] PCPlus1_IFID;
output reg [31:0] instruction_IFID;

always @ (posedge clk or negedge rst) begin: Pipeline_Register 

if (~rst) begin : reset
    instruction_IFID <= 32'b0;

end
else begin 
    if (flush) 
    instruction_IFID <= 0;
    else if (Write_IFID) begin
    instruction_IFID <= instruction;
    PCPlus1_IFID <= PCPlus1;
    end
    else;
end


end

endmodule