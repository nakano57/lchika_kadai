`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/06/11 10:09:52
// Design Name:
// Module Name: debounce
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module debounce(
    input CLK,
    input RST,
    input BTNIN,
    output reg BTNOUT
    );

    reg [21:0] cnt22;

    wire en40hz = (cnt22==22'd3125000-1);

    always @(posedge CLK) begin
        if(RST)
            cnt22 <= 22'h0;
        else if (en40hz)
            cnt22 <= 22'h0;
        else
            cnt22 <= cnt22 + 1'd1;
    end

    reg ff1,ff2;

    always @(posedge CLK) begin
        if(RST)begin
            ff1 <=1'b0;
            ff2 <=1'b0;
        end else if(en40hz) begin
            ff2<=ff1;
            ff1<=BTNIN;
        end
    end

    wire temp = ff1 & ~ff2 & en40hz;

    always @(posedge CLK)begin
        if(RST)
            BTNOUT <= 1'b0;
        else
            BTNOUT <= temp;
    end

endmodule
