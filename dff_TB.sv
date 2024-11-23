module dff_TB();
    reg d, clk;
    wire q, qb;

    // Instantiate the D flip-flop module (Device Under Test - DUT)
    dff dut(
        .d(d),
        .q(q),
        .clk(clk),
        .qb(qb)
    );

    // Initialize wave dump file for waveform visualization
    initial begin 
        $dumpfile("dff.vcd");
        $dumpvars(1, dff_TB);
    end

    // Generate the clock signal with an initial delay
    initial begin
        clk = 0;     // Initialize clock to 0
        forever #2 clk = ~clk;  // Toggle clock every 2 time units
    end

    // Generate the input signal 'd' with an initial delay to avoid undefined states
    initial begin
        d = 0;       // Initialize d to 0
        #4;          // Delay to ensure 'clk' has completed one full cycle
        d = 1;
        #4
        d = 0;
        #4
        d = 1;
        #4
        $finish;     // End the simulation
    end
endmodule
