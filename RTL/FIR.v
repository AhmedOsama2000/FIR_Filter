module FIR #(
	// Using N-bit fixed point represnation
	// Fc = 24  KHz
	// Fs = 160 KHz
	parameter SAMPLE_IN_WIDTH  = 16,
	parameter SAMPLE_OUT_WIDTH = SAMPLE_IN_WIDTH*2,
	parameter TAPS	 		   = 67
)
(
	input  wire 	   				    rst_n,
	input  wire 	   				    CLK,
	input  wire  [SAMPLE_IN_WIDTH-1:0]  sample_in,
	input  wire        				    En_FIR,
	output wire  [SAMPLE_OUT_WIDTH-1:0] sample_out 
);

// TAPS counter
integer i;

wire [SAMPLE_IN_WIDTH-1:0]  FIR_Coef   [TAPS-1:0];
wire [SAMPLE_OUT_WIDTH-1:0] mul_res    [TAPS-1:0];

reg  [SAMPLE_OUT_WIDTH-1:0] add_res    [TAPS-2:0];
reg  [SAMPLE_IN_WIDTH-1:0]  delay_regs [TAPS-1:0];

// Instantiate signed multipliers
genvar x;

generate

for (x = 0; x < TAPS; x = x + 1) begin
	signed_mul mul_insts (
		.in0(FIR_Coef[x]),
		.in1(delay_regs[x]),
		.out(mul_res[x])
	);
end

endgenerate

// FIR_Coeff
assign FIR_Coef[0]  = 16'hFFF8; 
assign FIR_Coef[1]  = 16'hFFE7; 
assign FIR_Coef[2]  = 16'hFFE8; 
assign FIR_Coef[3]  = 16'h0000; 
assign FIR_Coef[4]  = 16'h0021; 
assign FIR_Coef[5]  = 16'h002F; 
assign FIR_Coef[6]  = 16'h0012; 
assign FIR_Coef[7]  = 16'hFFD6; 
assign FIR_Coef[8]  = 16'hFFA9; 
assign FIR_Coef[9]  = 16'hFFC3; 
assign FIR_Coef[10] = 16'h0026; 
assign FIR_Coef[11] = 16'h008C; 
assign FIR_Coef[12] = 16'h008C; 
assign FIR_Coef[13] = 16'h0000; 
assign FIR_Coef[14] = 16'hFF40; 
assign FIR_Coef[15] = 16'hFEFA; 
assign FIR_Coef[16] = 16'hFF9E; 
assign FIR_Coef[17] = 16'h00D8; 
assign FIR_Coef[18] = 16'h01A6; 
assign FIR_Coef[19] = 16'h011C; 
assign FIR_Coef[20] = 16'hFF55; 
assign FIR_Coef[21] = 16'hFDA3; 
assign FIR_Coef[22] = 16'hFDB0; 
assign FIR_Coef[23] = 16'h0000; 
assign FIR_Coef[24] = 16'h0316; 
assign FIR_Coef[25] = 16'h043C; 
assign FIR_Coef[26] = 16'h01A0; 
assign FIR_Coef[27] = 16'hFC4B; 
assign FIR_Coef[28] = 16'hF841; 
assign FIR_Coef[29] = 16'hFA33; 
assign FIR_Coef[30] = 16'h0420; 
assign FIR_Coef[31] = 16'h133E; 
assign FIR_Coef[32] = 16'h20F2; 
assign FIR_Coef[33] = 16'h2676; 
assign FIR_Coef[34] = 16'h20F2; 
assign FIR_Coef[35] = 16'h133E; 
assign FIR_Coef[36] = 16'h0420; 
assign FIR_Coef[37] = 16'hFA33; 
assign FIR_Coef[38] = 16'hF841; 
assign FIR_Coef[39] = 16'hFC4B; 
assign FIR_Coef[40] = 16'h01A0; 
assign FIR_Coef[41] = 16'h043C; 
assign FIR_Coef[42] = 16'h0316; 
assign FIR_Coef[43] = 16'h0000; 
assign FIR_Coef[44] = 16'hFDB0; 
assign FIR_Coef[45] = 16'hFDA3; 
assign FIR_Coef[46] = 16'hFF55; 
assign FIR_Coef[47] = 16'h011C; 
assign FIR_Coef[48] = 16'h01A6; 
assign FIR_Coef[49] = 16'h00D8; 
assign FIR_Coef[50] = 16'hFF9E; 
assign FIR_Coef[51] = 16'hFEFA; 
assign FIR_Coef[52] = 16'hFF40; 
assign FIR_Coef[53] = 16'h0000; 
assign FIR_Coef[54] = 16'h008C; 
assign FIR_Coef[55] = 16'h008C; 
assign FIR_Coef[56] = 16'h0026; 
assign FIR_Coef[57] = 16'hFFC3; 
assign FIR_Coef[58] = 16'hFFA9; 
assign FIR_Coef[59] = 16'hFFD6; 
assign FIR_Coef[60] = 16'h0012; 
assign FIR_Coef[61] = 16'h002F; 
assign FIR_Coef[62] = 16'h0021; 
assign FIR_Coef[63] = 16'h0000; 
assign FIR_Coef[64] = 16'hFFE8; 
assign FIR_Coef[65] = 16'hFFE7; 
assign FIR_Coef[66] = 16'hFFF8; 

always @(posedge CLK,negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0; i < TAPS;i = i + 1) begin
			delay_regs[i] <= 'b0;
		end
	end
	else if (En_FIR) begin
		delay_regs[0] <= sample_in;
		for (i = 1; i < TAPS;i = i + 1) begin
			delay_regs[i] <= delay_regs[i-1];
		end
	end
end

// Addition Process
always @(*) begin
	add_res[0] = mul_res[0] + mul_res[1];
	for (i = 1;i < TAPS - 1; i = i + 1) begin
		add_res[i] = add_res[i-1] + mul_res[i+1];
	end 
end

// Output samples from last summation
assign sample_out = (En_FIR)? add_res[TAPS-2] : 'b0;

endmodule