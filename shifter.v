module shifter(
	datain,
	dataout
);
	input [15:0]datain;
	output [15:0]dataout;
assign dataout[0]=datain[15];
assign dataout[1]=datain[14];
assign dataout[2]=datain[13];
assign dataout[3]=datain[12];
assign dataout[4]=datain[11];
assign dataout[5]=datain[10];
assign dataout[6]=datain[9];
assign dataout[7]=datain[8];
assign dataout[8]=datain[7];
assign dataout[9]=datain[6];
assign dataout[10]=datain[5];
assign dataout[11]=datain[4];
assign dataout[12]=datain[3];
assign dataout[13]=datain[2];
assign dataout[14]=datain[1];
assign dataout[15]=datain[0];
endmodule