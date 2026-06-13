`timescale 1ns / 1ps

module tb_async_fifo();
    reg wr_clk, wr_rst_n, wr_en;
    reg [7:0] wdata;
    wire full;
    reg rd_clk, rd_rst_n, rd_en;
    wire [7:0] rdata;
    wire empty;
    
    async_fifo_top #(.DATA_WIDTH(8), .ADDR_WIDTH(4)) dut (
        .wr_clk(wr_clk), 
        .wr_rst_n(wr_rst_n), 
        .wr_en(wr_en), 
        .wdata(wdata), 
        .full(full),
        
        .rd_clk(rd_clk), 
        .rd_rst_n(rd_rst_n), 
        .rd_en(rd_en), 
        .rdata(rdata), 
        .empty(empty)
    );
    
    // No overflow assertion
    assert property (@(posedge wr_clk) disable iff (!wr_rst_n)
        full |=> !wr_en) else $error("OVERFLOW");
    // No underflow assertion
    assert property (@(posedge rd_clk) disable iff (!rd_rst_n)
        empty |-> !rd_en) else $error("UNDERFLOW");
    
    // Empty after reset assertion
    assert property (@(posedge rd_clk)
        $fell(rd_rst_n) |-> ##2 empty) else $error("Not empty after reset!");
        
    always #5 wr_clk = ~wr_clk;
    always #10 rd_clk = ~rd_clk;
    
    initial begin
        wr_clk = 0; wr_rst_n = 0; wr_en = 0; wdata = 0;
        rd_clk = 0; rd_rst_n = 0; rd_en = 0;
        #20;
        wr_rst_n = 1; rd_rst_n = 1;
        #20;
        
        wr_en = 1;
        repeat (16) begin
            @(posedge wr_clk);
            wdata = wdata + 1;
        end
        @(posedge wr_clk) wr_en = 0;
        
        repeat (16) begin
            @(posedge rd_clk) rd_en = 1;
        end
        @(posedge rd_clk) rd_en = 0;
        
        #200;
        $finish;
    end
    
    initial begin
        $monitor("time=%0t: full=%b empty=%b wdata=%d rdata=%d", $time, full, empty, wdata, rdata);
    end
endmodule
