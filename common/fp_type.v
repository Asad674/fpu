	
module fp_type(
	input [31:0] in1,
	input [31:0] in2,
    output reg in1_is_norm,    
    output reg in1_is_subnorm,
    output reg in1_is_zero,      
    output reg in1_is_inf,       
    output reg in1_is_snan,
    output reg in1_is_qnan,     
    output reg in2_is_norm,    
    output reg in2_is_subnorm,
    output reg in2_is_zero,      
    output reg in2_is_inf,       
    output reg in2_is_snan,
    output reg in2_is_qnan
);
    wire [7:0] exp1, exp2;
	wire [22:0] mant1, mant2;

	assign exp1 = in1[30:23];
	assign exp2 = in2[30:23];

	assign mant1 = in1[22:0];
	assign mant2 = in2[22:0];

    always@(*)
	    begin
	    	in1_is_norm       = 1'b0;    
	    	in1_is_subnorm    = 1'b0;  
	    	in1_is_zero         = 1'b0;      
	    	in1_is_inf          = 1'b0;        
	    	in1_is_snan   = 1'b0;
	    	in1_is_qnan        = 1'b0;
    
	    	if((exp1 == 8'b11111111) & (mant1[22] == 1'b0) & (|mant1[21:0] == 1'b1))
	    	begin
	    		in1_is_snan = 1'b1;
	    	end
    
	    	else if((exp1 == 8'b11111111) & (mant1[22] == 1'b1))
	    	begin
	    		in1_is_qnan      = 1'b1;
	    	end
    
	    	else if((exp1 == 8'b11111111) & (mant1[22:0] == 23'd0))
	    	begin
	    		in1_is_inf        = 1'b1;
	    	end
    
	    	else if((exp1 == 8'd0) & (mant1[22:0] == 23'd0))
	    	begin
	    		in1_is_zero       = 1'b1;
	    	end
    
	    	else if((exp1 == 8'd0) & (|mant1[22:0] == 1'b1))
	    	begin
	    		in1_is_subnorm  = 1'b1;
	    	end
    
	    	else
	    	begin
	    		in1_is_norm     = 1'b1;
	    	end
	    end

    always@(*)
	    begin
	    	in2_is_norm       = 1'b0;    
	    	in2_is_subnorm    = 1'b0;  
	    	in2_is_zero         = 1'b0;      
	    	in2_is_inf          = 1'b0;        
	    	in2_is_snan   = 1'b0;
	    	in2_is_qnan        = 1'b0;
    
	    	if((exp2 == 8'b11111111) & (mant2[22] == 1'b0) & (|mant2[21:0] == 1'b1))
	    	begin
	    		in2_is_snan = 1'b1;
	    	end
    
	    	else if((exp2 == 8'b11111111) & (mant2[22] == 1'b1))
	    	begin
	    		in2_is_qnan      = 1'b1;
	    	end
    
	    	else if((exp2 == 8'b11111111) & (mant2[22:0] == 23'd0))
	    	begin
	    		in2_is_inf        = 1'b1;
	    	end
    
	    	else if((exp2 == 8'd0) & (mant2[22:0] == 23'd0))
	    	begin
	    		in2_is_zero       = 1'b1;
	    	end
    
	    	else if((exp2 == 8'd0) & (|mant2[22:0] == 1'b1))
	    	begin
	    		in2_is_subnorm  = 1'b1;
	    	end
    
	    	else
	    	begin
	    		in2_is_norm     = 1'b1;
	    	end
    
	    end
endmodule
