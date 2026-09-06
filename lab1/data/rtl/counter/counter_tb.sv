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

        // Reset
        repeat (2) @(posedge clk);
        @(negedge clk);

        if (count !== 8'd0) begin
            $display("TEST FAILED: reset");
            $finish;
        end

        // Release reset
        rst_n = 1;

        // Check counting
        enable = 1;

        for (int i = 1; i <= 5; i++) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== i) begin
                $display(
                    "TEST FAILED: expected count = %0d, got %0d",
                    i, count
                );
                $finish;
            end
        end

        // Check hold
        enable = 0;

        repeat (3) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== 8'd5) begin
                $display(
                    "TEST FAILED: counter changed while enable = 0"
                );
                $finish;
            end
        end

        // Continue counting
        enable = 1;

        for (int i = 6; i <= 10; i++) begin
            @(posedge clk);
            @(negedge clk);

            if (count !== i) begin
                $display(
                    "TEST FAILED: expected count = %0d, got %0d",
                    i, count
                );
                $finish;
            end
        end

        $display("TEST PASSED");
        $finish;
    end

endmodule