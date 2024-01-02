module VGAStateMachine
// #(
//     parameter width = 640, parameter height = 480, parameter target_frequency = 60,
//     parameter hsync_pulse_width = 96, parameter hsync_back_porch = 48, parameter hsync_front_porch = 16,
//     parameter vsync_pulse_width = 2,  parameter vsync_back_porch = 33, parameter vsync_front_porch = 10
// )
(
    input clk,
    output reg [$clog2(`WIDTH) - 1:0] x,
    output reg [$clog2(`HEIGHT) - 1:0] y,
    output reg [1:0] h_state, 
    output reg [1:0] v_state
);
    reg [$clog2(`WIDTH) - 1:0] counter_x;
    reg [$clog2(`WIDTH) - 1:0] target_counter_x;
    reg [$clog2(`HEIGHT) - 1:0] counter_y;
    reg [$clog2(`HEIGHT) - 1:0] target_counter_y;
    reg [1:0] h;
    reg [1:0] v;

    initial begin
        h = `SyncState;
        v = `SyncState;
        counter_x = 0;
        counter_y = 0;
        target_counter_x = `WIDTH;
        target_counter_y = `HEIGHT;
    end

    always @(negedge clk) begin
        if(counter_x == target_counter_x) begin
            counter_x <= 0;
            case(h)
                `SyncState: begin
                    h <= `BackPorchState;
                    target_counter_x <= `hsync_back_porch;
                end
                `BackPorchState: begin
                    h <= `DisplayState;
                    target_counter_x <= `WIDTH;
                end
                `DisplayState: begin
                    h <= `FrontPorchState;
                    target_counter_x <= `hsync_front_porch;
                end
                `FrontPorchState: begin
                    h <= `SyncState;
                    target_counter_x <= `hsync_pulse_width;
                    counter_y <= counter_y + 1'h1;
                end
                default: begin
                    h <= `SyncState;
                    target_counter_x <= `hsync_pulse_width;
                end
            endcase
        end
        else counter_x <= counter_x + 1'h1;

        if(counter_y == target_counter_y) begin
            counter_y <= 0;
            case(v)
                `SyncState: begin
                    v <= `BackPorchState;
                    target_counter_y <= `vsync_back_porch;
                end
                `BackPorchState: begin
                    v <= `DisplayState;
                    target_counter_y <= `HEIGHT;
                end
                `DisplayState: begin
                    v <= `FrontPorchState;
                    target_counter_y <= `vsync_front_porch;
                end
                `FrontPorchState: begin
                    v <= `SyncState;
                    target_counter_y <= `vsync_pulse_width;
                end
                default: begin
                    v <= `SyncState;
                    target_counter_y <= `vsync_pulse_width;
                end
            endcase
        end
        else ;

        h_state <= h;
        v_state <= v;
        x <= counter_x;
        y <= counter_y;
    end
endmodule