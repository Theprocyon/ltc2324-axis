`timescale 1ns / 1ps

module tb_ltc2324_core;

    // System Interface
    logic        clk;
    logic        rst_n;
    logic        start;
    logic        valid;
    logic [15:0] ch1, ch2, ch3, ch4;

    // LTC2324 Interface (Virtual ADC connection)
    logic        CLKOUT;
    logic        SDO1, SDO2, SDO3, SDO4;
    logic        nCNV; // Active Low (Conversion Phase)
    logic        SCK;

    // Simulation Variables
    logic [15:0] expected_ch1, expected_ch2, expected_ch3, expected_ch4;
    int          test_cycle_cnt;

    // 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    ltc2324_core u_dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .valid      (valid),
        .ch1        (ch1),
        .ch2        (ch2),
        .ch3        (ch3),
        .ch4        (ch4),

        .CLKOUT     (CLKOUT),
        .SDO1       (SDO1),
        .SDO2       (SDO2),
        .SDO3       (SDO3),
        .SDO4       (SDO4),
        .nCNV       (nCNV),
        .SCK        (SCK)
    );

    // SCK to CLKOUT Delay max 4.5ns
    always @(SCK) begin
        CLKOUT <= #6ns SCK; 
    end

    // 3-2. Analog Sample & Data Shift Logic
    logic [15:0] adc_shift_reg [1:4]; 


    always @(negedge nCNV) begin

        adc_shift_reg[1] = $random;
        adc_shift_reg[2] = $random;
        adc_shift_reg[3] = $random;
        adc_shift_reg[4] = $random;


        expected_ch1 = adc_shift_reg[1];
        expected_ch2 = adc_shift_reg[2];
        expected_ch3 = adc_shift_reg[3];
        expected_ch4 = adc_shift_reg[4];
        
        $display("[Virtual ADC] Sampled New Analog Data: %h, %h, %h, %h", 
                 adc_shift_reg[1], adc_shift_reg[2], adc_shift_reg[3], adc_shift_reg[4]);
    end

    always @(negedge SCK) begin
        if (nCNV == 0) begin
            SDO1 <= adc_shift_reg[1][15];
            SDO2 <= adc_shift_reg[2][15];
            SDO3 <= adc_shift_reg[3][15];
            SDO4 <= adc_shift_reg[4][15];

            // Shift Left
            adc_shift_reg[1] <= {adc_shift_reg[1][14:0], 1'b0};
            adc_shift_reg[2] <= {adc_shift_reg[2][14:0], 1'b0};
            adc_shift_reg[3] <= {adc_shift_reg[3][14:0], 1'b0};
            adc_shift_reg[4] <= {adc_shift_reg[4][14:0], 1'b0};
        end else begin
            // Hi-Z state (simulated as 0 or Z)
            SDO1 <= 1'bz;
            SDO2 <= 1'bz;
            SDO3 <= 1'bz;
            SDO4 <= 1'bz;
        end
    end


    // =========================================================================
    // 4. Test Sequence & Automatic Checking
    // =========================================================================
    initial begin
        // Initialization
        rst_n = 0;
        start = 0;
        test_cycle_cnt = 0;
        
        // Apply Reset
        #100;
        rst_n = 1;
        #20;

        $display("---------------------------------------------------");
        $display("LTC2324 Interface Core Test Start");
        $display("---------------------------------------------------");

        // Repeat Test 5 times
        repeat (5) begin
            test_cycle_cnt++;
            $display("\n[Test Cycle %0d] Starting Conversion...", test_cycle_cnt);

            // 1. Trigger Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            fork 
                begin
                    wait(valid);
                    $display("[DUT] Valid asserted!");
                end
                begin
                    #5000; // 5us Timeout
                    $error("Timeout! ");
                    $finish;
                end
            join_any
            disable fork;

            // 3. Verify Data
            @(negedge clk); // Check stable data
            if (ch1 === expected_ch1 && ch2 === expected_ch2 && 
                ch3 === expected_ch3 && ch4 === expected_ch4) begin
                $display("[PASS] Data Match! Rcv: %h, Exp: %h", ch1, expected_ch1);
            end else begin
                $error("[FAIL] Data Mismatch!");
                $display("   CH1 - Rcv: %h, Exp: %h", ch1, expected_ch1);
                $display("   CH2 - Rcv: %h, Exp: %h", ch2, expected_ch2);
                $display("   CH3 - Rcv: %h, Exp: %h", ch3, expected_ch3);
                $display("   CH4 - Rcv: %h, Exp: %h", ch4, expected_ch4);
            end

            #200;
        end
        $finish;
    end

endmodule