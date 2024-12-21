module comparator (rsData, rtData, zero, lessthan, greaterthan);

    input [31:0] rsData;
    input [31:0] rtData;
    
    output zero, lessthan, greaterthan;

    wire zero = (rsData == rtData);
    wire lessthan = ($signed(rsData) < $signed(rtData));
    wire greaterthan = ($signed(rsData) > $signed(rtData));
    
endmodule