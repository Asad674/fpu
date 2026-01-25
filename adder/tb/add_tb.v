`timescale 1ns / 1ps

module add_tb;
    // Inputs
    reg [31:0] in1, in2;
    reg RDN, RUP, RTZ, RNE, RMM;
    reg [8*8:1] mode_str;
    reg [8*16:1] test_status;
    reg [31:0] exp_res;
    // Outputs
    wire [1:0] unused;
    wire out_sign, out_sign_round;
    wire [7:0] out_exp, out_exp_round;
    wire [25:0] out_mant;
    wire [22:0] out_mant_round;
    wire [31:0] out;
    wire overflow, underflow, inexact;
    wire is_normal1;
    wire is_subnormal1;
    wire is_zero1;
    wire is_inf1;
    wire is_signalling1;
    wire is_quiet1;
    wire is_normal2;
    wire is_subnormal2;
    wire is_zero2;
    wire is_inf2;
    wire is_signalling2;
    wire is_quiet2;

    integer infile, outfile, err_cnt, test_cnt, ok1, ok2, n; 


    reg [1023:0] in_path;
    reg [1023:0] out_path;

    fp_type type(
        .in1 (in1),
        .in2 (in2),
        .is_normal1    (is_normal1),
        .is_subnormal1(is_subnormal1),
        .is_zero1      (is_zero1),
        .is_inf1       (is_inf1),
        .is_signalling1(is_signalling1),
        .is_quiet1     (is_quiet1),
        .is_normal2    (is_normal2),
        .is_subnormal2(is_subnormal2),
        .is_zero2      (is_zero2),
        .is_inf2       (is_inf2),
        .is_signalling2(is_signalling2),
        .is_quiet2(is_quiet2)
    );
    // Instantiate the Unit Under Test (UUT)
    add adder (
        .in1 (in1),
        .in2 (in2),
        .is_sub1(is_subnormal1),
        .is_sub2(is_subnormal2),
        .is_zero1(is_zero1),
        .is_zero2(is_zero2),
        .is_snan1(is_signalling1),
        .is_snan2(is_signalling2),
        .is_qnan1(is_quiet1),
        .is_qnan2(is_quiet2),
        .is_inf1 (is_inf1),
        .is_inf2 (is_inf2),
        .out_sign(out_sign),
        .out_exp(out_exp),
        .out_mant(out_mant),
        .overflow (overflow),
        .underflow (underflow),
        .inexact (inexact)
    );


    rounding rounding (
        .result_mant(out_mant),
        .result_sign(out_sign),
        .result_exp (out_exp),
        .in1_sign (in1[31]),
        .in2_sign (in2[31]),
        .RTZ(RTZ),
        .RUP(RUP),
        .RDN(RDN),
        .RNE(RNE),
        .RMM(RMM),
        .is_zero1(is_zero1),
        .is_zero2(is_zero2),
        .overflow (overflow),
        .out_sign (out_sign_round),
        .out_exp (out_exp_round),
        .out_mant(out_mant_round)
    );

    assign out = {out_sign_round, out_exp_round, out_mant_round};


    initial begin
        in_path = "adder/vectors/test_rne.txt";
        out_path = "adder/vectors/test_rne_result.txt";
        if ($value$plusargs("IN=%s", in_path)) begin
            $display("IN = %s", in_path);
        end
        else begin
          $display("No user entered infile path found. Using default infile path");
        end

        if ($value$plusargs("OUT=%s", out_path)) begin
            $display("OUT = %s", out_path);
        end
        else begin
          $display("No user entered outfile path found. Using default outfile path");
        end
        

        infile = $fopen(in_path, "r");
        if (infile == 0) begin
        $display("ERROR: Cannot open input file: %s", in_path);
        $finish;
        end


        outfile = $fopen(out_path, "w");
        if (outfile == 0) begin
        $display("ERROR: Cannot open output file: %s", out_path);
        $finish;
        end
        err_cnt = 0;
        test_cnt = 0;
        mode_str = "RNE";
        if ($value$plusargs("MODE=%s", mode_str)) begin
            $display("MODE = %s", mode_str);
        end
        else begin
            $display("No user entered MODE found. Using default %s MODE", mode_str);
        end
        
        
            
        RTZ=0; RUP=0; RDN=0; RNE=0; RMM=0;
        if (mode_str == "RTZ") RTZ=1;
        else if (mode_str == "RUP") RUP=1;
        else if (mode_str == "RDN") RDN=1;
        else if (mode_str == "RMM") RMM=1;
        else RNE=1;
        
        while (! $feof(infile)) begin
            n = $fscanf(infile,"%h %h %h %h\n",in1,in2, exp_res, unused);
             #10;
            test_cnt = test_cnt + 1;
                if(exp_res != out)
                begin
                    $display("in1=%h in2=%h Expected=%h Actual=%h \t", in1, in2, exp_res, out);
            
                    $fwrite(outfile, "in1=%b in2=%b Expected=%b Actual=%b GRS=%b\n", in1, in2, exp_res, out, out_mant);

                end
                if (exp_res != out) begin
                    err_cnt = err_cnt + 1;
                end
                // end
        end
        if ($err_cnt == 0)begin
            test_status="\033[32mPASSED\033[0m";
        end
        else begin
            test_status="\033[31mFAILED\033[0m";
        end
        $display("MODE: %s | TOTAL ERRORS: %d/%d\t(%0.2f%%) | \033[32m%s\033[0m ", mode_str, err_cnt, test_cnt, err_cnt*100.0/test_cnt, test_status);
        $fclose(infile);
        $stop();
    end


endmodule
