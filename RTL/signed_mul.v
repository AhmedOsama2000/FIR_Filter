module signed_mul #(
	parameter IN_WIDTH  = 16,
	parameter OUT_WIDTH = 2 * IN_WIDTH
)
(
	input  wire [IN_WIDTH-1:0]  in0,
	input  wire [IN_WIDTH-1:0]  in1,
	output wire [OUT_WIDTH-1:0] out
);

wire [IN_WIDTH-1:0]  passed_in0;
wire [IN_WIDTH-1:0]  passed_in1;
wire [OUT_WIDTH-1:0] passed_out;

assign passed_in0 = (in0[IN_WIDTH-1])? (~in0 + 1): in0;
assign passed_in1 = (in1[IN_WIDTH-1])? (~in1 + 1): in1;

assign passed_out = passed_in0 * passed_in1;

assign out = (in0[IN_WIDTH-1] ^ in1[IN_WIDTH-1])? (~passed_out + 1) : passed_out;

endmodule