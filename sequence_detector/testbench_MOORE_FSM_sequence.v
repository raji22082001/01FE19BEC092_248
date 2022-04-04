module tb_sequence_Detector_Moore_FSM_verilog;
//inputs
reg clock;
reg reset;
reg sequence_in;
//outputs
wire detector_out;
//Instantiate the sequence Detector using moore FSM
sequence_Detector_MOORE_Verilog uut(
.sequence_in(sequence_in),
.clock(clock),
.reset(reset),
.detector_out(detector_out)
);
initial begin
clock=0;
forever #5 clock = ~clock;
end
initial begin
sequence_in=0;
reset=1;
//wait 100 ns for global reset to finish
#30;
reset=0;
#40;
sequence_in=1;
#10;
sequence_in=0;
#10;
sequence_in=1;
#20;
sequence_in=0;
#20;
sequence_in=1;
#20;
sequence_in=0;
// add stimulus here
end
endmodule

