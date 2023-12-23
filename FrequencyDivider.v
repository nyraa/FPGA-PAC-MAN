module FrequencyDivider #(parameter target_frequency = 1) (
    input clk,
    input reset,
    output reg div_clock
);
    
    reg [$clog2(25000000 / target_frequency) - 1:0] counter;
    reg [$clog2(25000000 / target_frequency) - 1:0] target_counter;

    initial begin
        target_counter = 25000000 / target_frequency;
        counter = 'h0;
    end


    always @(posedge clk)
    begin
        if(counter == target_counter) begin
            counter <= 'h0;
            div_clock <= ~div_clock;
        end
        else begin
            counter <= counter + 1'h1;
        end
    end
endmodule