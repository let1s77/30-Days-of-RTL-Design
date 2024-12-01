module eq_n( 
    input reset,clk,
    output reg [6:0] Q,
	 output reg [6:0] B);
	 reg y;
	 integer i = 0;
	 always_ff@(posedge clk)
	 begin 
	 i = i +1;
	 if ( i == 50000000) //bo chia tan so 50MHz - 1 clk = 20ns
	 // muon 1 giay thi -> 1 clk = 50 000 000
	 begin 
	 y = ~y;
	 i = 0;
	 end
	 end
	 
	 always @(posedge y)
	 begin
	 if (!reset)
	 Q <= 0;
	 else 
	 Q = Q - 1;
	 end
	 
	 always @(Q) //led 7 doan anode chung
	 begin 
	 case(Q)
	 3'd0: B <= 7'b1000000;
	 3'd1: B <= 7'b1111001;
	 3'd2: B <= 7'b0100100;
	 3'd3: B <= 7'b0110000;
	 3'd4: B <= 7'b0011001;
	 3'd5: B <= 7'b0010010;
	 3'd6: B <= 7'b0000010;
	 3'd7: B <= 7'b1111000;
	 
	 default: B <= 7'b0111_110;
	 endcase
	 end
	 endmodule 