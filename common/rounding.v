module rounding(
    input [25:0] result_mant,
    input [7:0] result_exp,
    input result_sign,
    input in1_sign,
    input in2_sign,
    input is_zero1,
    input is_zero2,
    input RTZ,
    input RNE,
    input RUP,
    input RDN,
    input RMM,
    input overflow,
    input is_add,
    output out_sign,
    output reg [22:0] out_mant,
    output reg [7:0] out_exp
);

reg result_is_zero;
wire add_one_flag; 


assign add_one_flag = (RUP && !result_sign && |result_mant[2:0]) ||
                      (RDN && result_sign && |result_mant[2:0]) ||
                      (RNE && ((result_mant[2:0] > 3'b100) || (result_mant[3:0] == 4'b1100))) ||
                      (RMM && (result_mant[2:0] > 3'b011));

assign out_sign = (is_add && (result_is_zero || (RDN && is_zero1 && is_zero2 && (in1_sign || in2_sign)))) ? RDN : result_sign;

always @(*)begin
    if (result_exp == 8'd0 && result_mant == 26'd0 && ~is_zero1 && ~is_zero2)begin
        result_is_zero = 1'b1;
    end
    else begin
        result_is_zero = 1'b0;
    end
end

always @(*)begin
    if (!overflow)begin
        if (add_one_flag) begin
            out_mant = result_mant[25:3] + 23'd1;
            if (result_mant[25:3] == 23'b11111111111111111111111)begin
                out_exp = result_exp + 8'd1;
                out_mant = 23'd0;
            end
            else begin
                out_exp = result_exp;
            end
        end
        else begin
            out_mant = result_mant[25:3];
            out_exp = result_exp;          
        end
    end

    else begin
        if (RNE || RMM || (!result_sign && RUP) || (result_sign && RDN))begin
            if (is_add) begin
                out_exp = 8'b11111111;
                out_mant = result_mant[25:3];
            end
            else begin
                out_exp = 8'b11111111;
                out_mant = 23'd0;
            end
        end
        else begin
            out_exp = 8'b11111110;
            out_mant = 23'b11111111111111111111111;
        end       
    end

end
endmodule


