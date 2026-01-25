module lzc(input [31:0] in, 
			   output [4:0] zero_count, 
				output all_zeroes);

wire [7:0] a;
wire [15:0] z;

genvar i;
generate

for (i = 1; i < 9; i = i+1)
begin: calc_zer0
	nlc nlc(in[4*i-1:4*i-4], a[i-1], z[2*i-1], z[2*i-2]); 
end
endgenerate

BNE BNE(a, zero_count[4:2], all_zeroes);

mux mux(z, zero_count[4:2], zero_count[1:0]); 

endmodule


module nlc(nib, a, z1, z0);
input [3:0] nib;	
output a, z0, z1;				

assign a = ~|(nib);
assign z0 = ~((~nib[2] & nib[1]) | (nib[3]));
assign z1 = ~|(nib[3:2]);	

endmodule


module BNE(a, y, Q);
input [7:0] a;
output Q;
output [2:0] y;

assign Q = &a;
assign y[2] = &a[7:4];
assign y[1] = &a[7:6] & (~a[5] | ~a[4] | &a[3:2]); 
assign y[0] = a[7] & (~a[6] | a[5] & ~a[4]) | (a[7] & a[5] & a[3] & (~a[2] | a[1]));	
				
endmodule

module mux(in, sel, out);

input [15:0] in;
input [2:0] sel;
output reg [1:0] out;

always @(*) begin

case(sel)
  0: out = in[15:14];
  1: out = in[13:12];
  2: out = in[11:10];
  3: out = in[9:8];
  4: out = in[7:6];
  5: out = in[5:4];
  6: out = in[3:2];
  7: out = in[1:0];
endcase
end
endmodule



	
		
