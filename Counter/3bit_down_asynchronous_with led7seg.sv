module led_decoder(
    input [2:0] Q,       // Giá trị từ bộ đếm
    output reg [6:0] B   // Mã LED 7 đoạn (anode chung)
);
    always @(*) begin
        case (Q)
            3'd0: B = 7'b1000000;
            3'd1: B = 7'b1111001;
            3'd2: B = 7'b0100100;
            3'd3: B = 7'b0110000;
            3'd4: B = 7'b0011001;
            3'd5: B = 7'b0010010;
            3'd6: B = 7'b0000010;
            3'd7: B = 7'b1111000;
            default: B = 7'b0111110;
        endcase
    end
endmodule

module counter(
    input clk,          // Clock 1Hz từ bộ chia tần số
    input reset,        // Active high reset
    output reg [2:0] Q  // Giá trị đếm (3-bit)
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            Q <= 3'd7;  // Reset về trạng thái cao nhất (7)
        else 
            Q <= Q - 1; // Đếm xuống
    end
endmodule

module freq_divider(
    input clk,          // Clock 50MHz
    input reset,        // Active high reset
    output reg clk_out  // 1Hz clock output
);
    integer count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            clk_out <= 0;
        end else if (count == 50000000 - 1) begin
            count <= 0;
            clk_out <= ~clk_out; // Tạo xung 1Hz
        end else begin
            count <= count + 1;
        end
    end
endmodule

module eq_n(
    input clk,          // Clock 50MHz //ganchanDE1
    input reset,        // Active high reset
    output [6:0] B      // Mã LED 7 đoạn
);
    wire clk_1hz;       // Clock 1Hz
    wire [2:0] Q;       // Giá trị đếm

    // Bộ chia tần số từ 50MHz xuống 1Hz
    freq_divider u1 (
        .clk(clk),
        .reset(reset),
        .clk_out(clk_1hz)
    );

    // Bộ đếm 3-bit
    counter u2 (
        .clk(clk_1hz),
        .reset(reset),
        .Q(Q)
    );

    // Bộ giải mã LED 7 đoạn
    led_decoder u3 (
        .Q(Q),
        .B(B)
    );

endmodule
