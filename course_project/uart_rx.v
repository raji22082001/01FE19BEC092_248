module uart_rx
#(parameter clk_p_bit=104.166)
(rx_div,rx_data,clk,serial_data
    );
input clk;
input serial_data;
output rx_div;
output[7:0] rx_data;

parameter idle=3'b000,start=3'b001,r_data=3'b010,stop=3'b011,reset=3'b100;
reg rx_data_rec=1'b1;
reg rx=1'b1;
reg[7:0] r_clock_count=0;
reg[2:0] r_bit_index=0;
reg[7:0] r_rx_byte=0;
reg r_rx_div=0;
reg[2:0] state;

always@(posedge clk)
begin
rx_data_rec<=serial_data;
rx<=rx_data_rec;
end

always@(posedge clk)
begin
case(state)
idle:
begin
r_rx_div<=1'b0;
r_clock_count<=0;
r_bit_index<=0;
if(rx==1'b0)
state<=start;
else
state<=idle;
end

start:
begin
if(r_clock_count==(clk_p_bit-1)/2)
begin
if(rx==1'b0)
begin
r_clock_count<=0;
state<=r_data;
end
else
state<=idle;
end
else
begin
r_clock_count<=r_clock_count+1;
state<=start;
end
end

r_data:
begin
if(r_clock_count<clk_p_bit-1)
begin
r_clock_count<=r_clock_count+1;
state<=r_data;
end
else
begin
r_clock_count<=0;
r_rx_byte[r_bit_index]<=rx;

if(r_bit_index<7)
begin
r_bit_index<=r_bit_index+1;
state<=r_data;
end
else
begin
r_bit_index<=0;
state<=stop;
end
end
end

stop:
begin
if(r_clock_count < clk_p_bit-1)
begin
r_clock_count<=r_clock_count+1;
state<=stop;
end
else
begin
r_rx_div<=1'b1;
r_clock_count<=0;
state<=reset;
end
end

reset:
begin
state<=idle;
r_rx_div<=1'b0;
end
default:
state<=idle;
endcase
end
assign rx_div=r_rx_div;
assign rx_data=r_rx_byte;
endmodule
