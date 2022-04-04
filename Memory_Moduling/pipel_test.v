module pipel_test;
parameter N=100;
wire [N-1:0] F;
reg [N-1:0] A,B,C,D;
reg clk;
pipe_ex MYPIPE (F,A,B,C,D,clk);
initial clk=0;
always #10 clk = ~clk;
initial 
begin
#5 A=10; B=12; C=6; D=3; //F=75
#20 A=10; B=10; C=5; D=3; //F=66
#20 A=20; B=11; C=1; D=4; //F=112
end
initial 
begin
$dumpfile("pipel.vcd");
$dumpvars(0,pipel_test);
$monitor ("Time: %d,F=%d", $time,F);
#300 $finish;
end
endmodule

