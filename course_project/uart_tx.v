module uart_tx
#(parameter clk_p_bit=104.166)
(tx_serial,tx_done,tx_ready,tx_data,tx_div,clk
    );
	 input clk;
	 input tx_div;
	 input[7:0] tx_data;
	 output tx_ready;
	 output reg tx_serial;
	 output tx_done;
	 
	 parameter t_idle=3'b000,t_start=3'b001,t_data=3'b010,t_stop=3'b011,t_reset=3'b100;
	 reg[2:0] state=0;
	 reg[7:0] r_clock_count=0;
	 reg[2:0] r_bit_index=0;
	 reg[7:0] r_tx_data=0;
	 reg r_tx_done=0;
	 reg r_tx_ready=0;
	 
	 always@(posedge clk)
	 begin
	 case(state)
	 t_idle:
	 begin
	 tx_serial<=1'b1;
	 r_tx_done<=1'b0;
	 r_clock_count<=0;
	 r_bit_index<=0;
	 
	if(tx_div==1'b1)
	begin
	tx_serial<=1'b1;
	r_tx_data<=tx_data;
	state<=t_start;
    end
	else
	state<=t_idle;
	end
	
	t_start:
	begin
	tx_serial<=1'b0;
	if(r_clock_count<clk_p_bit-1)
	begin
	r_clock_count<=r_clock_count+1;
	state<=t_start;
	end
	else
	begin
	r_clock_count<=0;
	state<=t_data;
	end
	end
	
	t_data:
	begin
	tx_serial<=r_tx_data[r_bit_index];
	if(r_clock_count<clk_p_bit-1)
	begin
	r_clock_count<=r_clock_count+1;
	state<=t_data;
	end
	else
	begin
	r_clock_count<=0;
	if(r_bit_index<7)
	begin
	r_bit_index<=r_bit_index+1;
	state<=t_data;
	end
	else
	begin
	r_bit_index<=0;
	state<=t_stop;
	end
	end
	end
	
	t_stop:
	begin
	tx_serial<=1'b1;
	if(r_clock_count<clk_p_bit-1)
	begin
	r_clock_count<=r_clock_count+1;
	state<=t_stop;
	end
	else
	begin
	r_tx_done<=1'b1;
	r_clock_count<=0;
	state<=t_reset;
	r_tx_ready<=1'b0;
	end
	end
	
	t_reset:
	begin
	r_tx_done<=1'b1;
	state<=t_idle;
	end
	
	default:
	state<=t_idle;
	endcase
	end
	
	assign tx_ready=r_tx_ready;
	assign tx_done=r_tx_done;
	endmodule
