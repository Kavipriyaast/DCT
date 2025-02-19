`timescale 1ns/1ps

// Testbench for the DCT top module
module tb_dct_top;
    reg clk, rst, enable;  // Clock, reset, and enable signals
    reg signed [15:0] data_in;  // Input data
    wire signed [15:0] dct_out;  // Output data

    // Instantiate the DCT top module
    dct_top dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .dct_out(dct_out)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test input vectors (100 values) using pure Verilog logic
    reg signed [15:0] test_vectors [0:99];
    integer i;

    initial begin
        // Initialize test vectors
        test_vectors[0] = 16'd115; 
        test_vectors[1] = 16'd256;
        test_vectors[2] = 16'd318;
        test_vectors[3] = -16'd512;
        test_vectors[4] = -16'd223;
        test_vectors[5] = 16'd123;
        test_vectors[6] = 16'd502; 
        test_vectors[7] = -16'd513; 
        test_vectors[8] = 16'd755;
        test_vectors[9] = -16'd789; 
        test_vectors[10] = 16'd421;
        test_vectors[11] = -16'd411;
        test_vectors[12] = 16'd525; 
        test_vectors[13] = -16'd412;
        test_vectors[14] = 16'd658;
        test_vectors[15] = -16'd629;
        test_vectors[16] = 16'd723; 
        test_vectors[17] = -16'd777;
        test_vectors[18] = 16'd875; 
        test_vectors[19] = -16'd863; 
        test_vectors[20] = 16'd901;
        test_vectors[21] = -16'd912; 
        test_vectors[22] = 16'd15165; 
        test_vectors[23] = -16'd145;
        test_vectors[24] = 16'd1148; 
        test_vectors[25] = -16'd1103;
        test_vectors[26] = 16'd12548;
        test_vectors[27] = -16'd1289;
        test_vectors[28] = 16'd1348; 
        test_vectors[29] = -16'd13489;
        test_vectors[30] = 16'd1487;
        test_vectors[31] = -16'd14687;
        test_vectors[32] = 16'd1578;
        test_vectors[33] = -16'd1521;
        test_vectors[34] = 16'd16165; 
        test_vectors[35] = -16'd1652;
        test_vectors[36] = 16'd1752; 
        test_vectors[37] = -16'd17654;
        test_vectors[38] = 16'd18231;
        test_vectors[39] = -16'd1821;
        test_vectors[40] = 16'd1921; 
        test_vectors[41] = -16'd19321;
        test_vectors[42] = 16'd25412; 
        test_vectors[43] = -16'd2852; 
        test_vectors[44] = 16'd2100;
        test_vectors[45] = -16'd2101; 
        test_vectors[46] = 16'd22564; 
        test_vectors[47] = -16'd22674;
        test_vectors[48] = 16'd2367; 
        test_vectors[49] = -16'd2354; 
        test_vectors[50] = 16'd2467;
        test_vectors[51] = -16'd248; 
        test_vectors[52] = 16'd2575; 
        test_vectors[53] = -16'd2545;
        test_vectors[54] = 16'd2645;
        test_vectors[55] = -16'd2621; 
        test_vectors[56] = 16'd2700;
        test_vectors[57] = -16'd2777;
        test_vectors[58] = 16'd28321; 
        test_vectors[59] = -16'd2231;
        test_vectors[60] = 16'd29312; 
        test_vectors[61] = -16'd2968;
        test_vectors[62] = 16'd3065;
        test_vectors[63] = -16'd3044;
        test_vectors[64] = 16'd3111; 
        test_vectors[65] = -16'd3133;
        test_vectors[66] = 16'd32654; 
        test_vectors[67] = -16'd3202; 
        test_vectors[68] = 16'd33065;
        test_vectors[69] = -16'd3300;
        test_vectors[70] = 16'd3400; 
        test_vectors[71] = -16'd3400;
        test_vectors[72] = 16'd3508; 
        test_vectors[73] = -16'd3550;
        test_vectors[74] = 16'd3689;
        test_vectors[75] = -16'd36580; 
        test_vectors[76] = 16'd370654; 
        test_vectors[77] = -16'd376;
        test_vectors[78] = 16'd3868; 
        test_vectors[79] = -16'd3850;
        test_vectors[80] = 16'd3905;
        test_vectors[81] = -16'd3950; 
        test_vectors[82] = 16'd4055; 
        test_vectors[83] = -16'd46540;
        test_vectors[84] = 16'd4645; 
        test_vectors[85] = -16'd4150;
        test_vectors[86] = 16'd4205;
        test_vectors[87] = -16'd4280; 
        test_vectors[88] = 16'd4305; 
        test_vectors[89] = -16'd4560;
        test_vectors[90] = 16'd4456; 
        test_vectors[91] = -16'd4440; 
        test_vectors[92] = 16'd455;
        test_vectors[93] = -16'd400; 
        test_vectors[94] = 16'd0; 
        test_vectors[95] = -16'd46500;
        test_vectors[96] = 16'd47654; 
        test_vectors[97] = -16'd47654; 
        test_vectors[98] = 16'd486;
        test_vectors[99] = -16'd480;

        // Initialize control signals
        rst = 1; enable = 0; data_in = 0;
        #10 rst = 0; enable = 1;

        // Apply test vectors
        for (i = 0; i < 100; i = i + 1) begin
            data_in = test_vectors[i];
            #10;
        end

        // Finish simulation
        #100 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %d, data_in = %d, dct_out = %d", $time, data_in, dct_out);
    end
endmodule
