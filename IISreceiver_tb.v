`timescale 100ps/100ps
`define pclk_period 2500
`define Bclk_period 7100
`define Clk_period 50
module IISreceiver_tb();
	reg bclk;
	reg presetn;
	reg LRCK;
	reg datain;
	integer i;
	wire [15:0]Vol_L;
	wire [15:0]Vol_R;
	wire [16:0]data_out_L;
	wire [16:0]data_out_R;
	wire LRCK_d_out_L;
	wire LRCK_d_out_R;
IISreceiver	L(
	.pclk(),
	.presetn(presetn),
	.bclk(bclk),
	.LRCK(~LRCK),
	.datain(datain),
	.Vol(Vol_L),
	.data_out(data_out_L),
	.LRCK_d_out(LRCK_d_out_L)
);
IISreceiver	R(
	.pclk(),
	.presetn(presetn),
	.bclk(bclk),
	.LRCK(LRCK),
	.datain(datain),
	.Vol(Vol_R),
	.data_out(data_out_R),
	.LRCK_d_out(LRCK_d_out_R)
);
	initial 
	begin
		bclk = 1'b0;
		LRCK = 1'b1;	
		datain = 1'b1;
		presetn = 1'b0;
		#1000;
		presetn = 1'b1;
		wait(bclk == 1'b1);
		wait(bclk == 1'b0);
		LRCK = 1'b0;
		for (i = 1; i <5 ;i =i +1)			//第一个for循环，分别是55AA和00FF
		begin
			#(`Bclk_period);
			datain = 1'b0;		//1
			#(`Bclk_period);
			datain = 1'b1;		//2
			#(`Bclk_period);
			datain = 1'b0;		//3
			#(`Bclk_period);
			datain = 1'b1;		//4
			#(`Bclk_period);
			datain = 1'b0;		//5
			#(`Bclk_period);
			datain = 1'b1;		//6
			#(`Bclk_period);
			datain = 1'b0;		//7
			#(`Bclk_period);
			datain = 1'b1;		//8
			#(`Bclk_period);
			datain = 1'b1;		//9
			#(`Bclk_period);
			datain = 1'b0;		//10
			#(`Bclk_period);
			datain = 1'b1;		//11
			#(`Bclk_period);
			datain = 1'b0;		//12
			#(`Bclk_period);
			datain = 1'b1;		//13
			#(`Bclk_period);
			datain = 1'b0;		//14
			#(`Bclk_period);
			datain = 1'b1;		//15
			#(`Bclk_period);
			datain = 1'b0;		//16
			LRCK = 1'b1;
			#(`Bclk_period);
			datain = 1'b0;		//17
			#(`Bclk_period);
			datain = 1'b0;		//18
			#(`Bclk_period);
			datain = 1'b0;		//19
			#(`Bclk_period);
			datain = 1'b0;		//20
			#(`Bclk_period);
			datain = 1'b0;		//21
			#(`Bclk_period);
			datain = 1'b0;		//22
			#(`Bclk_period);
			datain = 1'b0;		//23
			#(`Bclk_period);
			datain = 1'b0;		//24
			#(`Bclk_period);
			datain = 1'b1;		//25
			#(`Bclk_period);
			datain = 1'b1;		//26
			#(`Bclk_period);
			datain = 1'b1;		//27
			#(`Bclk_period);
			datain = 1'b1;		//28
			#(`Bclk_period);
			datain = 1'b1;		//29
			#(`Bclk_period);
			datain = 1'b1;		//30
			#(`Bclk_period);
			datain = 1'b1;		//31
			#(`Bclk_period);
			LRCK = 1'b0;
			datain = 1'b1;		//32
		end
			
				$stop;
	end
	
	always#(`Bclk_period/2) bclk = ~bclk;

endmodule