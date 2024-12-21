module ID_EX (clk, rst, rs, rt, rsData, rtData, extImm, shamt, 
            MemtoReg, MemReadEn, MemWriteEn, opSel,  ALUSrc,
            RegWriteEn, Link, writeRegister, PCPlus1_IFID,
            lessthan, Slt, greaterthan, Sgt, HasStalled,
            rs_IDEX, rt_IDEX, rsData_IDEX, rtData_IDEX, 
            extImm_IDEX,  shamt_IDEX, MemtoReg_IDEX, MemReadEn_IDEX, 
            MemWriteEn_IDEX, opSel_IDEX, ALUSrc_IDEX, RegWriteEn_IDEX,
            Link_IDEX, writeRegister_IDEX, PCPlus1_IDEX,
            lessthan_IDEX, Slt_IDEX, greaterthan_IDEX, Sgt_IDEX, HasStalled_IDEX);
   
input wire clk, rst;
input wire [7:0]  PCPlus1_IFID;
input wire [4:0] rs, rt, writeRegister, shamt;
input wire [31:0] rsData, rtData, extImm;
input wire MemtoReg, RegWriteEn;
input wire MemReadEn, MemWriteEn;
input wire lessthan, greaterthan;
input wire [3:0] opSel;
input wire  ALUSrc;
input wire Link, Sgt, Slt, HasStalled;

output reg [7:0]  PCPlus1_IDEX; 
output reg [4:0] rs_IDEX, rt_IDEX, writeRegister_IDEX, shamt_IDEX;
output reg [31:0] rsData_IDEX, rtData_IDEX, extImm_IDEX;
output reg MemtoReg_IDEX, RegWriteEn_IDEX;
output reg MemReadEn_IDEX, MemWriteEn_IDEX;
output reg lessthan_IDEX, greaterthan_IDEX;
output reg [3:0] opSel_IDEX;
output reg ALUSrc_IDEX;
output reg Link_IDEX, Sgt_IDEX, Slt_IDEX, HasStalled_IDEX;


always @ (posedge clk or negedge rst) begin: Pipeline_Register 

if (~rst) begin
    {MemWriteEn_IDEX, RegWriteEn_IDEX, HasStalled_IDEX} <= 0;
end
else begin
    rs_IDEX <= rs;
    rt_IDEX <= rt;
    writeRegister_IDEX <= writeRegister;
    rsData_IDEX <= rsData;
    rtData_IDEX <= rtData;
    extImm_IDEX <= extImm;
    shamt_IDEX <= shamt;
    MemtoReg_IDEX <= MemtoReg;
    MemReadEn_IDEX <= MemReadEn;
    MemWriteEn_IDEX <= MemWriteEn;
    opSel_IDEX <= opSel;
    ALUSrc_IDEX <= ALUSrc;
    RegWriteEn_IDEX <= RegWriteEn;
    Link_IDEX <= Link;
    PCPlus1_IDEX <= PCPlus1_IFID;
    Slt_IDEX <= Slt;
    Sgt_IDEX <= Sgt;
    lessthan_IDEX <= lessthan;
    greaterthan_IDEX <= greaterthan;
    HasStalled_IDEX <= HasStalled;
end

end

endmodule