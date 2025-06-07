`timescale 1ns / 1ps
module CLOCK(sys_clk,rst,hr_bcd,min_bcd,sec_bcd,AN,display_out);
input sys_clk,rst;
output [7:0] AN,display_out;
output [7:0] hr_bcd,min_bcd,sec_bcd;
reg [5:0] min,sec,hr;
reg clk=0; // For generation clk with 1hz f
integer i=0;
always @(posedge sys_clk)
begin
    if(i==49999999)
    begin
        i<=0;
        clk<=~clk;
    end
    else
        i<=i+1;
end
always @(posedge clk,posedge rst)
begin
    if(rst)
        sec<=0;
    else if(sec<59)
        sec<=sec+1;
    else
        sec<=0;
end
always @(negedge sec[5],posedge rst)
begin
    if(rst)
        min<=0;
    else if(min<59)
        min<=min+1;
    else
        min<=0;
end
always @(negedge min[5],posedge rst)
begin
    if(rst)
        hr<=0;
    else if(hr<23)
        hr<=hr+1;
    else
        hr<=0;
end
BIN_BCD B1(hr,hr_bcd);
BIN_BCD B2(min,min_bcd);
BIN_BCD B3(sec,sec_bcd);
Multi_Seg_Disp M1(sys_clk,6,0,0,hr_bcd[7:4],hr_bcd[3:0],min_bcd[7:4],min_bcd[3:0],sec_bcd[7:4],sec_bcd[3:0],AN,display_out);
endmodule
