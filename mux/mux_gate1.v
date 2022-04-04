module mux_gate1(S0,I0,I1,Y);
input S0,I0,I1;
output Y;
assign Y=S0 ? I1:I0;
endmodule

