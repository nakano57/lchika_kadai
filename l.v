`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/06/10 18:45:56
// Design Name:
// Module Name: lchila
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


module lchila(
    input CLK,
    input RST,
    input [1:0] BTN,
    output reg[3:0] LED
    );

    wire UP,DOWN;

    debounce d0(.CLK(CLK),.RST(RST),.BTNIN(BTN[0]),.BTNOUT(UP));
    debounce d1(.CLK(CLK),.RST(RST),.BTNIN(BTN[1]),.BTNOUT(DOWN));

    reg [1:0] pattern;

    always @(posedge CLK) begin
        if(RST)
            pattern <=2'h0;
        else if (UP)
            pattern <= pattern + 2'd1;
        else if (DOWN) begin
            if (pattern == 2'd0)
                pattern <= pattern + 2'd2;
            else
                pattern <= pattern + 2'd3;
        end else if (pattern == 2'd3)
               pattern <= 2'h0;
    end

    reg [24:0] cnt25 =25'h0;

    always @(posedge CLK) begin
        if(RST)begin
            cnt25 <= 25'h0;
        end
        else begin
            cnt25 <= cnt25 + 1'h1;
        end
    end

    wire ledcnten = (cnt25[22:0]==23'h7fffff);

    reg [2:0] cnt3;

    always @(posedge CLK) begin
      if(RST)begin
        cnt3 <= 3'h0;
      end else if (ledcnten) begin

            if(pattern == 3'd0)begin

                if(cnt3 == 3'd5) begin
                  cnt3 <=3'h0;
                 end else begin
                   cnt3 <= cnt3 + 1'h1;
                 end

            end else begin

                if(cnt3 == 3'd3) begin
                  cnt3 <=3'h0;
                end else begin
                  cnt3 <= cnt3 + 1'h1;
                end
            end
        end
    end

function [3:0] ouhuku( input [2:0] in );
    begin
      case(in)
             3'd0: ouhuku = 4'b0001;
             3'd1: ouhuku = 4'b0010;
             3'd2: ouhuku = 4'b0100;
             3'd3: ouhuku = 4'b1000;
             3'd4: ouhuku = 4'b0100;
             3'd5: ouhuku = 4'b0010;
             default: ouhuku = 4'b0000;
      endcase
    end
    endfunction

    function [3:0]left (input [2:0]in);
    begin
      case(in)
                 3'd0: left = 4'b0001;
                 3'd1: left = 4'b0010;
                 3'd2: left = 4'b0100;
                 3'd3: left = 4'b1000;
                 default: left = 4'b0000;
                 endcase
    end
    endfunction

    function [3:0]right (input [2:0]in );
    begin
      case(in)
                 3'd0: right = 4'b1000;
                 3'd1: right = 4'b0100;
                 3'd2: right = 4'b0010;
                 3'd3: right = 4'b0001;
                 default: right = 4'b0000;
                 endcase
    end
    endfunction



    always @* begin
        case(pattern)
          3'd0: LED = ouhuku(cnt3);
          3'd1: LED = left(cnt3);
          3'd2: LED = right(cnt3);
          default: LED = 4'b0000;
        endcase
    end

endmodule
