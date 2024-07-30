`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 10:14:54 PM
// Design Name: 
// Module Name: matmul_tb
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


module tb_matrix_multiply;

    // Parameters
    parameter CLK_PERIOD = 10;

    // Inputs
    logic clk;
    logic rst;
    logic [15:0] A [4][4];
    logic [15:0] B [4][4];
    logic [15:0] expected_C [3:0][3:0];
    // Outputs
    logic [15:0] C [4][4];

    // Instantiate the DUT
    matmul#(.N(4)) dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .C(C)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize inputs
        rst =1;
        #(CLK_PERIOD);
        rst = 0;
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 4; j++) begin
                A[i][j] = 0;
                B[i][j] = 0;
            end
        end

        // Apply reset
        #(CLK_PERIOD);
        rst = 1;

        // Apply test vectors
        A[0][0] = 1; A[0][1] = 2; A[0][2] = 3; A[0][3] = 4;
        A[1][0] = 5; A[1][1] = 6; A[1][2] = 7; A[1][3] = 8;
        A[2][0] = 9; A[2][1] = 10; A[2][2] = 11; A[2][3] = 12;
        A[3][0] = 13; A[3][1] = 14; A[3][2] = 15; A[3][3] = 16;

        B[0][0] = 16; B[0][1] = 15; B[0][2] = 14; B[0][3] = 13;
        B[1][0] = 12; B[1][1] = 11; B[1][2] = 10; B[1][3] = 9;
        B[2][0] = 8; B[2][1] = 7; B[2][2] = 6; B[2][3] = 5;
        B[3][0] = 4; B[3][1] = 3; B[3][2] = 2; B[3][3] = 1;

        // Wait for results
        #(20 * CLK_PERIOD);

        // Check results
       
        // Finish simulation
        $finish;
    end

endmodule

