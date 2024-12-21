`timescale 1ns/1ps

module testbench;

    reg clk, rst;
    wire [5:0] PC;
	 

    // Function to calculate clock cycles from simulation time
    function integer time_to_cycles(input integer sim_time, input integer clk_period);
        begin
            time_to_cycles = sim_time / clk_period;
        end
    endfunction

    // Instantiate the processor module
    processor uut (
        .clk(clk),
        .rst(rst),
        .PC(PC)
    );
	 
	 
	 

    // Clock generation (Simulation only)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Generate clock with 10 ns period
    end

    // Reset generation
    initial begin
        rst = 0;
        #4 rst = 1;            // Deassert reset after 4 ns
        #2500 $stop;            // Stop simulation after 400 ns
    end

    // File handling for simulation (Simulation only)
    integer file;
    initial begin
        // Open the file
        file = $fopen("registerfile_output.txt", "w");
        if (file == 0) begin
            $display("Error: Failed to open file!");
            $finish;
        end

        // Monitor signals and write to file
        forever begin
            @(posedge clk);  // Trigger at positive edge of clock
$fdisplay(file,"Register file content at cycle: %0d\n[0] %h\n[1] %h\n[2] %h\n[3] %h\n[4] %h\n[5] %h\n[6] %h\n[7] %h\n[8] %h\n[9] %h\n[10] %h\n[11] %h\n[12] %h\n[13] %h\n[14] %h\n[15] %h\n[16] %h\n[17] %h\n[18] %h\n[19] %h\n[20] %h\n[21] %h\n[22] %h\n[23] %h\n[24] %h\n[25] %h\n[26] %h\n[27] %h\n[28] %h\n[29] %h\n[30] %h\n[31] %h",time_to_cycles($time, 10),
                uut.RF.registers[0],
                uut.RF.registers[1],
                uut.RF.registers[2],
                uut.RF.registers[3],
                uut.RF.registers[4],
                uut.RF.registers[5],
                uut.RF.registers[6],
                uut.RF.registers[7],
                uut.RF.registers[8],
                uut.RF.registers[9],
                uut.RF.registers[10],
                uut.RF.registers[11],
                uut.RF.registers[12],
                uut.RF.registers[13],
                uut.RF.registers[14],
                uut.RF.registers[15],
                uut.RF.registers[16],
                uut.RF.registers[17],
                uut.RF.registers[18],
                uut.RF.registers[19],
                uut.RF.registers[20],
                uut.RF.registers[21],
                uut.RF.registers[22],
                uut.RF.registers[23],
                uut.RF.registers[24],
                uut.RF.registers[25],
                uut.RF.registers[26],
                uut.RF.registers[27],
                uut.RF.registers[28],
                uut.RF.registers[29],
                uut.RF.registers[30],
                uut.RF.registers[31]
            );
        end
    end
	 
	 
	 
	 always @(posedge clk)
   begin
	    $display("\n============================================================\n\
Cycle: %0d | Time=%0t ns | PC=%0d |\n\
------------------------------------------------------------\n\
IF Stage:  | IF/ID PC+1=%0d |       Instruction=%h |\n\
ID Stage:  | ID/EX PC+1=%0d | IF/ID Instruction=%h |\n\
           | rs=%d, rt=%d, rd=%d, shamt=%d, funct=%h |\n\
           | Control Signals: RegDst=%b, ALUSrc=%b, MemtoReg=%b, RegWriteEn=%b, MemReadEn=%b, MemWriteEn=%b ,Branch=%b,bne=%b,willbarnch=%b, Jump=%b |\n\
           | Read Data 1=%h, Read Data 2=%h, Immediate=%h \nHazard unit| flush=%b, PCwrite=%b, Write_IFID=%b, nopSel=%b|\n\
EX Stage:  | ALUin1=%h, ALUin2=%h, ALUResult=%h, Zero=%b |\n\
           | ForwardA=%b, ForwardB=%b, opSel=%b |\n\
MEM Stage: | EX/MEM ALUResult=%h, EX/MEM WriteData=%h, MemReadEn=%b, MemWriteEn=%b |\n\
WB Stage:  | MEM/WB WriteData=%h, WriteRegister=%d, RegWriteEn=%b          r1=%h |\n\
------------------------------------------------------------\n\
===============================================================================",
	        $time / 10,                 
	        $time,                      
	        uut.PCout,                     
	        uut.PCPlus1_IFID,      
	        uut.instruction,       
	        uut.PCPlus1_IDEX,           
	        uut.instruction_IFID,       
	        uut.rs,                     
	        uut.rt,                     
	        uut.rd,                     
	        uut.shamt,                  
	        uut.funct,                  
	        uut.RegDst,                 
	        uut.ALUSrc,                 
	        uut.MemtoReg,               
	        uut.RegWriteEn,             
	        uut.MemReadEn,              
	        uut.MemWriteEn,             
	        uut.BranchEqual, 
			  uut._BranchNotEqual,
			  uut.willBranch,
	        uut.Jump,                   
	        uut.readData1,              
	        uut.readData2,              
	        uut.extImm,  
		     uut.flush,
			  uut.PCwrite,
			  uut.Write_IFID,
			  uut.nopSel,
	        uut.ALUin1,                 
	        uut.ALUin2,                 
	        uut.ALUResult,              
	        uut.zero,                   
	        uut.EXForwardA,             
	        uut.EXForwardB,             
	        uut.opSel_IDEX,             
	        uut.ALUResult_EXMEM,        
	        uut.FWDrtData_EXMEM,          
	        uut.MemReadEn_EXMEM,        
	        uut.MemWriteEn_EXMEM,       
	        uut.writeData,              
	        uut.writeRegister_MEMWB,    
	        uut.RegWriteEn_MEMWB, 
			  uut.RF.registers[1]
        
	    );
	end

    // Dumping signals for waveform (Simulation only)
    initial begin
        $dumpfile("waveform.vcd");  // Specify output VCD file name
        $dumpvars(0, testbench);    // Dump all variables in testbench
    end

    // Close the file after simulation ends
    initial begin
        #4000 $fclose(file);  // Close file after 800 ns
		  
    end

endmodule