module fwdvalue (Link_IDEX, Slt_IDEX, Sgt_IDEX,
                 PCPlus1_IDEX, greaterthan_IDEX, lessthan_IDEX,
                 FWDvalue);

input [7:0] PCPlus1_IDEX;
input Link_IDEX, Slt_IDEX, Sgt_IDEX, lessthan_IDEX, greaterthan_IDEX;
output reg [7:0] FWDvalue;

always @(*) begin
    FWDvalue = 8'b0;
	 
    if (Link_IDEX)
    FWDvalue = PCPlus1_IDEX;
	 
    if (Slt_IDEX)
    FWDvalue = {7'b0 , lessthan_IDEX};
	 
    if(Sgt_IDEX)
    FWDvalue = {7'b0 , greaterthan_IDEX};
end

endmodule