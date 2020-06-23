/*--------------------------------------------------------------------------------
Author: Waseem Orphali 
Create Date: 06/22/2020
Module Name: driver
Project Name: segment_display
Target Devices: Nexys A7 (Artix A7)
Description: 
This module takes 32 bit hex input and displays the hex code on the 
eight 7-segment displays present on the Nexys A7 board.
The clock rate on the board is 100 MHz, each digit is displayed
for 1ms for a total of 8ms to display all eight digits

--------------------------------------------------------------------------------*/

module driver(
    input   wire        i_clk,      // 100 MHz clk
    input   wire [31:0] i_data,     // eight 4-bit hex input
    output  reg  [7:0]  o_segments, // segment code output to be displayed
    output  reg  [7:0]  o_digits    // enables the display digits
    );
    
    localparam CYCLES_PER_DIGIT = 100000;    // 1 ms if the clk freq is 100 Mhz
    localparam NUM_OF_DIGITS = 8;
    localparam TOTAL_CYCLES = NUM_OF_DIGITS * CYCLES_PER_DIGIT;
    localparam [7:0] MEM [15:0] = {'h8e, 'h86, 'ha1, 'hc6, 'h83, 'h88,'h90, 'h80, 'hf8, 'h82, 'h92, 'h99, 'hb0, 'ha4, 'hf9, 'hc0}; // 7-seg code to display hex 0 - F according to Nexys A7 datasheet
    
    reg [7:0] segout0;
    reg [7:0] segout1;
    reg [7:0] segout2;
    reg [7:0] segout3;
    reg [7:0] segout4;
    reg [7:0] segout5;
    reg [7:0] segout6;
    reg [7:0] segout7;
    
    integer counter = 0;        // initiales counter used to slow down clk, 100 Mhz is too fast to run display
    
    always @* begin             // assign each 4 bits to one segment and convert to 7-segment code
        segout0 = MEM[i_data[3:0]];  
        segout1 = MEM[i_data[7:4]];  
        segout2 = MEM[i_data[11:8]]; 
        segout3 = MEM[i_data[15:12]];
        segout4 = MEM[i_data[19:16]];
        segout5 = MEM[i_data[23:20]];
        segout6 = MEM[i_data[27:24]];
        segout7 = MEM[i_data[31:28]];
    end
    
    always @(posedge i_clk) begin
        if(i_clk) begin
            if (counter < TOTAL_CYCLES) begin
                counter <= counter + 1;
                if (counter < CYCLES_PER_DIGIT - 1) begin
                    o_segments <= segout0;
                    o_digits <= 8'b11111110;
                    end
                else if (counter < CYCLES_PER_DIGIT*2 - 1) begin
                    o_segments <= segout1;
                    o_digits <= 8'b11111101;
                    end
                else if (counter < CYCLES_PER_DIGIT*3 - 1) begin
                    o_segments <= segout2;
                    o_digits <= 8'b11111011;
                    end
                else if (counter < CYCLES_PER_DIGIT*4 - 1) begin
                    o_segments <= segout3;
                    o_digits <= 8'b11110111;
                    end
                else if (counter < CYCLES_PER_DIGIT*5 - 1) begin
                    o_segments <= segout4;
                    o_digits <= 8'b11101111;
                    end
                else if (counter < CYCLES_PER_DIGIT*6 - 1) begin
                    o_segments <= segout5;
                    o_digits <= 8'b11011111;
                    end
                else if (counter < CYCLES_PER_DIGIT*7 - 1) begin
                    o_segments <= segout6;
                    o_digits <= 8'b10111111;
                    end
                else if (counter < TOTAL_CYCLES - 1) begin
                    o_segments <= segout7;
                    o_digits <= 8'b01111111;
                    end
            end
            else
                counter <= 0;
        end
    end
    
endmodule
    