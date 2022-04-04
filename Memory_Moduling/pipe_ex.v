module pipe_ex(F,A,B,C,D,clk);
parameter N=100;
input [N-1:0] A,B,C,D;
input clk;
output [N-1:0] F;
reg [N-1:0] L12_X1,L12_X2,L12_D,L23_X3,L23_D,L34_F;
assign F=L34_F;
always@(posedge clk) //STAGE1
begin
L12_X1 <= #4 A+B;
L12_X2 <= #4 C-D;
L12_D <= D;
end
always@(posedge clk) //STAGE2
begin
L23_X3 <= #4 L12_X1 + L12_X2;
L23_D <= L12_D;
end
always@(posedge clk) //STAGE3
begin
L34_F=L23_X3*L23_D;
end
endmodule



