module branch_detection_unit(BranchEqual, BranchNotEqual, zero,
JumpReg, Jump, willJump, willBranch);
		
		input BranchEqual , zero, BranchNotEqual, JumpReg, Jump;
		output willBranch, willJump ;
		
		assign willBranch = (~zero & BranchNotEqual) | (zero & BranchEqual);
        assign willJump = Jump || JumpReg;


endmodule