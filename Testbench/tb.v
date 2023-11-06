module testbench;

	parameter SAMPLE_IN_WIDTH  = 16;
	parameter SAMPLE_OUT_WIDTH = 32;

	parameter SIGNAL_SAMPLES   = 20001;

	reg 	   				    rst_n;
	reg 	   				    CLK;
	reg [SAMPLE_IN_WIDTH-1:0]   sample_in;
	reg        				    En_FIR;
	wire [SAMPLE_OUT_WIDTH-1:0] sample_out;

integer i;

// Load test signal samples from generated MATLAB script
reg [15:0] signal_samples [0:SIGNAL_SAMPLES-1];

FIR DUT (
	.rst_n(rst_n),
	.CLK(CLK),
	.sample_in(sample_in),
	.En_FIR(En_FIR),
	.sample_out(sample_out)
);

always begin
	#10
	CLK = ~CLK;
end

initial begin
	En_FIR    = 1'b0;
	rst_n     = 1'b0;
	CLK       = 1'b0;
	sample_in = 'b0;
	repeat (5) @(negedge CLK);

	rst_n = 1'b1;
	En_FIR = 1'b1;
	$readmemh("signal_20KHz+noise.txt",signal_samples);
	
	for (i = 0; i < SIGNAL_SAMPLES;i = i + 1) begin
		sample_in = signal_samples[i];
		if (i == SIGNAL_SAMPLES-1) begin
		   i = 0;
		end
		@(negedge CLK);
	end

	$stop;

end

endmodule