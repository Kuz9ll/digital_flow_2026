`timescale 1ns/1ps

module counter_tb;

    logic       clk;
    logic       rst_n;
    logic       enable;
    logic [7:0] count;

    counter dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .enable (enable),
        .count  (count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        rst_n  = 0;
        enable = 0;

        $display("========================================");
        $display("Starting counter test");
        $display("========================================");

        // ----------------------------------------------------
        // Test 1: Reset
        // ----------------------------------------------------
        repeat (2) @(posedge clk);
        @(negedge clk);

        if (count !== 8'd0) begin
            $display("[FAILED] Reset: expected count = 0, got %0d", count);
            $finish;
        end

        $display("[PASSED] Reset");

        rst_n = 1;

        // ----------------------------------------------------
        // Test 2: Counting
        // ----------------------------------------------------
        enable = 1;

        for (int i = 1; i <= 5; i++) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== i) begin
                $display(
                    "[FAILED] Counting: expected count = %0d, got %0d",
                    i, count
                );
                $finish;
            end
        end

        $display("[PASSED] Counting with enable = 1");

        // ----------------------------------------------------
        // Test 3: Hold
        // ----------------------------------------------------
        enable = 0;

        repeat (3) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== 8'd5) begin
                $display(
                    "[FAILED] Hold: expected count = 5, got %0d",
                    count
                );
                $finish;
            end
        end

        $display("[PASSED] Hold with enable = 0");

        // ----------------------------------------------------
        // Test 4: Continue counting
        // ----------------------------------------------------
        enable = 1;

        for (int i = 6; i <= 10; i++) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== i) begin
                $display(
                    "[FAILED] Continue counting: expected count = %0d, got %0d",
                    i, count
                );
                $finish;
            end
        end

        $display("[PASSED] Continue counting after hold");

        // ----------------------------------------------------
        // Test completed
        // ----------------------------------------------------
        $display("========================================");
        $display("ALL TESTS PASSED");
        $display("========================================");

        $finish;
    end

endmodule