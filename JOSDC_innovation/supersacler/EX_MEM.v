module EX_MEM (clk, rst, writeRegister_IDEX, ALUResult, rtData, MemtoReg, 
            RegWriteEn, MemReadEn, MemWriteEn, 
            writeRegister_EXMEM, ALUResult_EXMEM, rtData_EXMEM,
            MemtoReg_EXMEM, RegWriteEn_EXMEM, MemReadEn_EXMEM, MemWriteEn_EXMEM);
        
input wire clk, rst;
input wire [4:0] writeRegister_IDEX;
input wire [31:0] ALUResult, rtData;
input wire MemtoReg, RegWriteEn;
input wire MemReadEn, MemWriteEn;

output reg [4:0] writeRegister_EXMEM;
output reg [31:0] ALUResult_EXMEM, rtData_EXMEM;
output reg MemtoReg_EXMEM, RegWriteEn_EXMEM;
output reg MemReadEn_EXMEM, MemWriteEn_EXMEM;

always @ (posedge clk or negedge rst) begin: Pipeline_Register 

if (~rst) begin
    {MemWriteEn_EXMEM, RegWriteEn_EXMEM} <= 0;   
end

else begin
    ALUResult_EXMEM <= ALUResult;
    rtData_EXMEM <= rtData;
    MemtoReg_EXMEM <= MemtoReg;
    MemReadEn_EXMEM <= MemReadEn;
    MemWriteEn_EXMEM <= MemWriteEn;
    RegWriteEn_EXMEM <= RegWriteEn;
    writeRegister_EXMEM <= writeRegister_IDEX;
end

end

endmodule