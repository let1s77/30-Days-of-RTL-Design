module clk_divider( //chuyen doi xung clock 50 Mhz sang 1Hz aka 1 giay
    input clk,          // Clock 50 MHz
    input reset,        // Tín hiệu reset (active high)
    output reg clk_out  // Clock 1 Hz
);
    reg [25:0] count;   // Bộ đếm chia tần số

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            clk_out <= 0;
        end else if (count == 50000000 - 1) begin
            count <= 0;
            clk_out <= ~clk_out; // Tạo xung 1 Hz
        end else begin
            count <= count + 1;
        end
    end
endmodule


module counter(
    input clk,         // Clock 1 Hz
    input reset,       // Tín hiệu reset (active high)
    output reg [3:0] Q // Giá trị đếm 4-bit
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 4'd5; // Reset về giá trị 5
        end else if (Q == 4'd14) begin
            Q <= 4'd5; // Quay lại 5 khi đạt giá trị 14
        end else begin
            Q <= Q + 1; // Đếm tăng
        end
    end
endmodule

module bin_to_bcd( //4bit sang bcd
    input [3:0] bin,   // Giá trị nhị phân 4-bit
    output reg [3:0] chuc, // Hàng chục
    output reg [3:0] dvi  // Hàng đơn vị
);
    always @(*) begin
        chuc = bin / 4'd10; // Lấy hàng chục // chia lay phan nguyen
        dvi = bin % 4'd10; // Lấy hàng đơn vị // chia lay du
    end
endmodule

module seven_segment(
    input [3:0] bcd,   // Số BCD (hàng chục hoặc hàng đơn vị)
    output reg [6:0] led // LED 7 đoạn
);
    always @(*) begin
        case (bcd)
            4'd0: led = 7'b1000000;
            4'd1: led = 7'b1111001;
            4'd2: led = 7'b0100100;
            4'd3: led = 7'b0110000;
            4'd4: led = 7'b0011001;
            4'd5: led = 7'b0010010;
            4'd6: led = 7'b0000010;
            4'd7: led = 7'b1111000;
            4'd8: led = 7'b0000000;
            4'd9: led = 7'b0010000;
            default: led =7'b1000000; // hien thi so '0'
        endcase
    end
endmodule


module eq_n(
    input clk,              // Clock 50 MHz
    input reset,            // Tín hiệu reset (active high)
    output [6:0] HEX1,      // LED 7 đoạn hiển thị hàng chục
    output [6:0] HEX0       // LED 7 đoạn hiển thị hàng đơn vị
);
    wire clk_1hz;           // Clock 1 Hz
    wire [3:0] Q;           // Giá trị đếm 4-bit
    wire [3:0] chuc,dvi;  // Giá trị BCD (hàng chục, hàng đơn vị)

    // Bộ chia tần số
    clk_divider clk_div_inst (
        .clk(clk),
        .reset(reset),
        .clk_out(clk_1hz)
    );

    // Bộ đếm 4-bit
    counter counter_inst (
        .clk(clk_1hz),
        .reset(reset),
        .Q(Q)
    );

    // Chuyển đổi từ nhị phân sang BCD
    bin_to_bcd bcd_inst (
        .bin(Q),
        .chuc(chuc),
        .dvi(dvi)
    );

    // Hiển thị hàng chục trên LED 7 đoạn
    seven_segment seg_tens (
        .bcd(chuc),
        .led(HEX1)
    );

    // Hiển thị hàng đơn vị trên LED 7 đoạn
    seven_segment seg_ones (
        .bcd(dvi),
        .led(HEX0)
    );
endmodule