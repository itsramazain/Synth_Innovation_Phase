module MEM_WB (clk, rst, writeRegister, ALUResult,  
            memoryReadData, MemtoReg, RegWriteEn,
            writeRegister_MEMWB, ALUResult_MEMWB, memoryReadData_MEMWB,
            MemtoReg_MEMWB, RegWriteEn_MEMWB);
        
input wire clk, rst;
input wire [4:0] writeRegister;
input wire [31:0] ALUResult, memoryReadData;
input wire MemtoReg, RegWriteEn;

output reg [4:0] writeRegister_MEMWB ;
output reg [31:0] ALUResult_MEMWB, memoryReadData_MEMWB;
output reg MemtoReg_MEMWB, RegWriteEn_MEMWB;

always @ (posedge clk or negedge rst) begin: Pipeline_Register 

if (~rst) begin
    {RegWriteEn_MEMWB} <= 0;
    
end
else begin
    ALUResult_MEMWB <= ALUResult;
    memoryReadData_MEMWB <= memoryReadData;
    MemtoReg_MEMWB <= MemtoReg;
    RegWriteEn_MEMWB <= RegWriteEn;
    writeRegister_MEMWB <= writeRegister;
end

end

endmodule