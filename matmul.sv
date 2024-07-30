`timescale 1ns / 1ps
//`include shift_reg_.sv //Uncomment for including file
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 10:30:51 PM
// Design Name: 
// Module Name: matmul
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


module PE(input  [15:0]a_in,b_in,
          input logic reset,clk ,
          output reg [15:0] a_out,
          output reg [15:0] b_out,
          output reg [15:0] out);
  always_ff @(posedge clk or negedge reset) begin
   if(!reset) begin
    a_out<=16'b0;
    b_out<=16'b0;
    out<=16'b0;
   end
   else begin
    a_out<=a_in;
    b_out<=b_in;
    out<= out + a_in*b_in;
   end
  end
endmodule

module mac_array #(parameter N = 8)(
  input [15:0] a[N][N],
  input [15:0] b[N][N],
  input clk,
  input rst,
  input shift_a[N],
  input shift_b[N],
  output reg [15:0] c[N][N]
);
  reg [15:0] a_i[N][N];
  reg [15:0] b_i[N][N];
  reg [15:0] a_out[N][N];
  reg [15:0] b_out[N][N];

  genvar i, j;
  generate
    for (i = 0; i < N; i = i + 1) begin: row
      // Instantiate the shift register for the first column of a_i
      shift_reg_#(.N(N)) sr_a (
        .clk(clk),
        .rst(rst),
        .a(a[i]),
        .shift(shift_a[i]),
        .out(a_i[i][0])
      );

      for (j = 0; j < N; j = j + 1) begin: col
        // Instantiate the processing element
        PE pe (
          .a_in(a_i[i][j]),
          .b_in(b_i[i][j]),
          .a_out(a_out[i][j]),
          .b_out(b_out[i][j]),
          .out(c[i][j]),
          .clk(clk),
          .reset(rst)
        );

        // Propagate a_i and b_i values to the next PE
        if (j < N-1) begin
          assign a_i[i][j+1] = a_out[i][j];
        end
        if (i < N-1) begin
          assign b_i[i+1][j] = b_out[i][j];
        end

        // For the first row, instantiate the shift register for b_i
        if (i == 0) begin
          shift_reg_#(.N(N)) sr_b (
            .clk(clk),
            .rst(rst),
            .a(b[j]),
            .shift(shift_b[j]),
            .out(b_i[0][j])
          );
        end
      end
    end
  endgenerate
endmodule

module matmul #(parameter N = 8)
               (input [15:0] A[N][N],
               input [15:0] B[N][N],
               input clk,rst,
               output reg [15:0] C[N][N]
               );

reg [7:0]wait_a[N];

reg shift_a[N];

mac_array#(.N(N)) mca (.a(A),.b(B),.c(C),.clk(clk),.rst(rst),.shift_a(shift_a),.shift_b(shift_a));
always_ff @(posedge clk or negedge rst) begin
  if(!rst) begin
   for (int i=0;i<N;i++) begin
    wait_a[i]<=i[15:0];
   end
  end
  else begin
   for(shortint i=0;i<N;i++) begin
    wait_a[i] <= (wait_a[i]==0)? 0: wait_a[i]-1;
    shift_a[i] <= bitwise_and(~wait_a[i]);
   end
  end
 end

endmodule

function logic bitwise_and(input [7:0] in);
    integer i;
    logic result;
    begin
      result = in[0];
      for (i = 1; i < 8; i = i + 1) begin
        result = result & in[i];
      end
      bitwise_and = result;
    end
endfunction
