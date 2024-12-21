module forwarding_Unit_EX (
    RegWriteEn_MEMWB,
    writeRegister_MEMWB,
    RegWriteEn_EXMEM,
    writeRegister_EXMEM,
    rs_IDEX,
    rt_IDEX,
    ForwardA,
    ForwardB
);
    input RegWriteEn_MEMWB;
    input [4:0] writeRegister_MEMWB; // Destination register in MEM/WB
    input RegWriteEn_EXMEM;
    input [4:0] writeRegister_EXMEM; // Destination register in EX/MEM
    input [4:0] rs_IDEX;             // Source register Rs in ID/EX
    input [4:0] rt_IDEX;             // Source register Rt in ID/EX
    
    output reg [1:0] ForwardA; // Forwarding control for ALU input A
    output reg [1:0] ForwardB; // Forwarding control for ALU input B

    always @(*) begin
        // Default values: No forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ForwardA: Handling first ALU input
        if (RegWriteEn_EXMEM  
        &&    (writeRegister_EXMEM != 5'b0) 
        &&    (writeRegister_EXMEM == rs_IDEX)) begin
            ForwardA = 2'b10; // Forward from EX/MEM
        end
        if (RegWriteEn_MEMWB  
        && (writeRegister_MEMWB != 5'b0)  
        && (writeRegister_MEMWB == rs_IDEX)  
        && !(RegWriteEn_EXMEM && (writeRegister_EXMEM == rs_IDEX))) begin
            ForwardA = 2'b01; // Forward from MEM/WB
        end

        // ForwardB: Handling second ALU input
        if (RegWriteEn_EXMEM && 
            (writeRegister_EXMEM != 5'b0) && 
            (writeRegister_EXMEM == rt_IDEX)) begin
            ForwardB = 2'b10; // Forward from EX/MEM
        end
        if (RegWriteEn_MEMWB  
        &&  (writeRegister_MEMWB != 5'b0)  
        &&  (writeRegister_MEMWB == rt_IDEX)  
        &&  !(RegWriteEn_EXMEM && (writeRegister_EXMEM == rt_IDEX))) begin
            ForwardB = 2'b01; // Forward from MEM/WB
        end
    end
endmodule
