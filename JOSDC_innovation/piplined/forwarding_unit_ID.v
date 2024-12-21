module forwarding_Unit_ID (
    RegWriteEn_MEMWB, writeRegister_MEMWB, 
    RegWriteEn_EXMEM, writeRegister_EXMEM,
    writeRegister_IDEX, RegWriteEn_IDEX, 
    rs, rt, 
     Sgt_IDEX, Slt_IDEX,
    ForwardA, ForwardB
);
    input RegWriteEn_MEMWB, RegWriteEn_EXMEM, RegWriteEn_IDEX;
    input [4:0] writeRegister_MEMWB, writeRegister_EXMEM, writeRegister_IDEX;
    input [4:0] rs;
    input [4:0] rt;
    input  Sgt_IDEX, Slt_IDEX; // Signal to indicate forwarding of _slt, _sgt, instructions

    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;

    always @(*) begin
        // Default values: No forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ForwardA: Handling Rs
        if (RegWriteEn_EXMEM  
        && (writeRegister_EXMEM != 5'b0)  
        && (writeRegister_EXMEM == rs)
        && !((Slt_IDEX || Sgt_IDEX) && (writeRegister_IDEX == rt))) begin
            ForwardA = 2'b10; // Forward from EX/MEM
        end
        if (RegWriteEn_MEMWB  
        && (writeRegister_MEMWB != 5'b0)  
        && (writeRegister_MEMWB == rs)  
        && !(RegWriteEn_EXMEM && (writeRegister_EXMEM == rs))
        && !((Slt_IDEX || Sgt_IDEX) && (writeRegister_IDEX == rt))) begin
            ForwardA = 2'b01; // Forward from MEM/WB
        end
        // Additional condition: Forward value from EX stage
        if (RegWriteEn_IDEX  
        && (writeRegister_IDEX != 5'b0)  
        && (writeRegister_IDEX == rs)
        && (Slt_IDEX || Sgt_IDEX)) begin
            ForwardA = 2'b11; 
        end

        // ForwardB: Handling Rt
        if (RegWriteEn_EXMEM  
        && (writeRegister_EXMEM != 5'b0)  
        && (writeRegister_EXMEM == rt)
        && !((Slt_IDEX || Sgt_IDEX) && (writeRegister_IDEX == rt))) begin
            ForwardB = 2'b10; // Forward from EX/MEM
        end
        if (RegWriteEn_MEMWB  
        && (writeRegister_MEMWB != 5'b0)  
        && (writeRegister_MEMWB == rt)  
        && !(RegWriteEn_EXMEM && (writeRegister_EXMEM == rt))
        && !((Slt_IDEX || Sgt_IDEX) && (writeRegister_IDEX == rt))) begin
            ForwardB = 2'b01; // Forward from MEM/WB
        end
        // Additional condition: Forward value from EX stage
        if (RegWriteEn_IDEX  
        && (writeRegister_IDEX != 5'b0)  
        && (writeRegister_IDEX == rt)
        && (Slt_IDEX || Sgt_IDEX)) begin
            ForwardB = 2'b11; 
        end

    end
endmodule
