module TOP_NAMES(sys_clk,AN,display_out,red,green,blue,hsync,vsync);
input sys_clk;
output [3:0] red,green,blue;
output [7:0] AN,display_out;
output hsync,vsync;
wire clk_25MHz;
wire clk_100;
wire [9:0]hcount,vcount;
wire [0:19] sec_data,sec_data1,min_data,min_data1,hr_data,hr_data1,isto_data;
wire [9:0] block=550;
wire [9:0] vblock=250;
wire [9:0] min_block=460;
wire [9:0] hr_block=370;
wire [4:0] data_adrs;
wire [7:0] hr_bcd,min_bcd,sec_bcd;
wire [5:0] title_adrs,name_adrs;
wire [0:499] title;
wire [0:199] name;
wire hello;
CLOCK Clok(sys_clk,rst,hr_bcd,min_bcd,sec_bcd,AN,display_out);
DISP_COUNT Count(clk_25MHz,hcount,vcount,hsync,vsync);
CLK_25MHz Clk25M(sys_clk,clk_25MHz);
DISP_WRITE(clk_25MHz,hcount,vcount,block,vblock,min_block,hr_block,sec_data,sec_data1,min_data,min_data1,hr_data,hr_data1,isto_data,data_adrs,red,green,blue,title_adrs,title,name_adrs,name);
DATA Data(clk_25MHz,sec_bcd[3:0],sec_data,data_adrs);
DATA Data1(clk_25MHz,sec_bcd[7:4],sec_data1,data_adrs);
DATA MinData(clk_25MHz,min_bcd[3:0],min_data,data_adrs);
DATA MinData1(clk_25MHz,min_bcd[7:4],min_data1,data_adrs);
DATA HrData(clk_25MHz,hr_bcd[3:0],hr_data,data_adrs);
DATA HrData1(clk_25MHz,hr_bcd[7:4],hr_data1,data_adrs);
DATA ISTOData(clk_25MHz,4'd10,isto_data,data_adrs);
TITLE Title(clk_25MHz,title_adrs,title,name_adrs,name);
endmodule
module DISP_WRITE(clk_25MHz,hcount,vcount,block,vblock,min_block,hr_block,sec_data,sec_data1,min_data,min_data1,hr_data,hr_data1,isto_data,data_adrs,red,green,blue,title_adrs,title,name_adrs,name);
input clk_25MHz;
input [9:0] hcount,vcount,block,vblock,min_block,hr_block;
input [0:19] sec_data,sec_data1,min_data,min_data1,hr_data,hr_data1,isto_data;
output [4:0] data_adrs;
reg[4:0] data_adrs_temp;
output reg [3:0] red,green,blue;
output reg [5:0] title_adrs,name_adrs;
input [0:499] title;
input [0:199] name;
assign data_adrs=data_adrs_temp;
always @(posedge clk_25MHz)
begin
    if((hcount>=144 && hcount<=784) && (vcount>=35 && vcount<=521))
        begin
            data_adrs_temp<=vcount-vblock;
            title_adrs<=vcount-60;
            name_adrs<=vcount-460;
            if((hcount>=block && hcount<=block+19) && (vcount>=vblock && vcount<=vblock+31) && sec_data[hcount-block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=214 && hcount<=713) && (vcount>=60 && vcount<=117)&& title[hcount-214]==1) // Title 
            begin
                    {red,green,blue}={4'b0111,4'b0001,4'b0100};
            end
            else if((hcount>=550 && hcount<=749) && (vcount>=450 && vcount<=489)&& name[hcount-580]==1) // Names
            begin
                    {red,green,blue}={4'b0000,4'b0100,4'b0100};
            end
            else if((hcount>=block-30 && hcount<=block-11) && (vcount>=vblock && vcount<=vblock+31)&& sec_data1[hcount-block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=min_block && hcount<=min_block+19) && (vcount>=vblock && vcount<=vblock+31) && min_data[hcount-min_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=min_block-30 && hcount<=min_block-11) && (vcount>=vblock && vcount<=vblock+31)&& min_data1[hcount-min_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=min_block+30 && hcount<=min_block+49) && (vcount>=vblock && vcount<=vblock+31)&& isto_data[hcount-min_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=hr_block && hcount<=hr_block+19) && (vcount>=vblock && vcount<=vblock+31) && hr_data[hcount-hr_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=hr_block-30 && hcount<=hr_block-11) && (vcount>=vblock && vcount<=vblock+31)&& hr_data1[hcount-hr_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else if((hcount>=hr_block+30 && hcount<=hr_block+49) && (vcount>=vblock && vcount<=vblock+31)&& isto_data[hcount-hr_block]==1)
            begin
                    {red,green,blue}={4'b0000,4'b0000,4'b0000};
            end
            else
                {red,green,blue}={4'b1111,4'b1111,4'b1111}; 
        end
    else
        begin
            {red,green,blue}={4'b0000,4'b0000,4'b0000};   
        end
end
endmodule
// Clock Division for 25MHz
module CLK_25MHz(clk_in,clk_out);
input clk_in;
output reg clk_out=0;
integer i;
always @(posedge clk_in)
begin
    if(i==1)
    begin
        clk_out<=~clk_out;
        i<=0;
    end
    else
        i<=i+1;
end
endmodule

// Clock Division for 25MHz
//module CLK_100Hz(clk_in,clk_out);
//input clk_in;
//output reg clk_out=0;
//integer i;
//always @(posedge clk_in)
//begin
//    if(i==49999999)
//    begin
//        clk_out<=~clk_out;
//        i<=0;
//    end
//    else
//        i<=i+1;
//end
//endmodule

// Access the display
module DISP_COUNT(clk,hcount,vcount,hsync,vsync);
input clk;
output hsync,vsync;
output reg [9:0] hcount=0;
output reg [9:0] vcount=0;
always @(posedge clk)
begin
    if(vcount<521)
    begin
        if(hcount<799)
            hcount<=hcount+1;
        else
        begin
            hcount<=0;
            vcount<=vcount+1;
        end
    end
    else
        vcount<=0;
end
assign vsync=(vcount<=1)?1:0; 
assign hsync=(hcount<=95)?1:0;
endmodule