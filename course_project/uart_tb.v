`include "uart_rx.v"
`include "uart_tx.v"

 module uart_tb();

reg clk=0;
reg r_tx_div=0;
wire w_tx_done;
reg[7:0] r_tx_data=0;
reg r_rx_serial=1;
wire[7:0] w_rx_byte;

parameter c_clk_period=100;
parameter c_clk_p_bit=104.166;
parameter c_bit_period=9600;

task uart_write_byte;
input[7:0] u_data;
integer i;
begin
 r_rx_serial<=1'b0;
 #(c_bit_period);
 #1000;
 
 for(i=0;i<8;i=i+1)
 begin
 r_rx_serial<=u_data[i];
 #(c_bit_period);
 end
 
 r_rx_serial<=1'b1;
 #(c_bit_period);
 end
 endtask
 
 uart_rx #(.clk_p_bit(c_clk_p_bit)) uart_rx_inst
 (.clk(clk),.serial_data(r_rx_serial),.rx_div(),.rx_data(w_rx_byte));
 
 uart_tx #(.clk_p_bit(c_clk_p_bit)) uart_tx_inst
 (.clk(clock),.tx_div(r_tx_div),.tx_data(r_tx_data),.tx_ready(),.tx_serial(),.tx_done());
 
 always
     #(c_clk_period/2) clk<=~clk;
 initial
 begin
   @(posedge clk);
   @(posedge clk);
 r_tx_div<=1'b1;
 r_tx_data<=8'hAB;
   @(posedge clk);
 r_tx_div<=1'b0;
   @(posedge w_tx_done);
   @(posedge clk);
 uart_write_byte(8'h3F);
   @(posedge clk);
 if(w_rx_byte==8'h3F)
 $display("test passed-correct byte");
 else
 $display("test failed-incorrect byte");
 end
 endmodule
 
