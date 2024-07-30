`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 09:32:32 PM
// Design Name: 
// Module Name: shift_reg_
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

module shift_reg_ #(parameter N=4)(
  input clk,rst,
  input [15:0]a[N],
  input shift,
  output reg [15:0]out
  );
  reg [15:0]p[N];
  genvar i;
  generate
   for(i=0;i<N;i++) begin
    assign p[i] = a[i];
   end
  endgenerate
  always_ff @(negedge clk or negedge rst) begin
   if(!rst) begin
    foreach(p[i]) begin
     p[i] <= 16'b0;
     out<= 16'b0;
    end
   end
   else if(shift) begin
    out = p[0];
    for(int i=0;i<N-1;i++) begin
     p[i]<= p[i+1];
    end
    p[N-1]=16'b0;
   end
   else begin
    out=16'b0;
   end
  end
  
endmodule