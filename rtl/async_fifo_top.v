`timescale 1ns / 1ps

module async_fifo_top #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 4
    )(
    //write clock domain
    input wire wr_clk,
    input wire wr_rst_n,
    input wire wr_en,
    input wire [DATA_WIDTH-1:0] wdata,
    output wire full,
    
    //read clock domain
    input wire rd_clk,
    input wire rd_rst_n,
    input wire rd_en,
    output wire [DATA_WIDTH-1:0] rdata,
    output wire empty
    );
    
    //internet wires
    wire [ADDR_WIDTH:0] wr_bin, wr_gray;
    wire [ADDR_WIDTH:0] rd_bin, rd_gray;
    wire [ADDR_WIDTH:0] wr_gray_sync, rd_gray_sync;
    
    //write pointer
    gray_counter #(.WIDTH(ADDR_WIDTH)) wptr_cnt (
        .clk(wr_clk),
        .rst_n(wr_rst_n),
        .inc(wr_en && !full),
        .bin(wr_bin),
        .gray(wr_gray)
    );
    
    //read pointer
    gray_counter #(.WIDTH(ADDR_WIDTH)) rptr_cnt (
        .clk(rd_clk),
        .rst_n(rd_rst_n),
        .inc(rd_en && !empty),
        .bin(rd_bin),
        .gray(rd_gray)
    );
    
    //synchronize write pointer to read clock domain
    sync_gray #(.WIDTH(ADDR_WIDTH)) sync_w2r (
        .clk(rd_clk),
        .rst_n(rd_rst_n),
        .gray_in(wr_gray),
        .gray_out(wr_gray_sync)
    );
    
    //synchronize read pointer to write clock domain
    sync_gray #(.WIDTH(ADDR_WIDTH)) sync_r2w (
        .clk(wr_clk),
        .rst_n(wr_rst_n),
        .gray_in(rd_gray),
        .gray_out(rd_gray_sync)
    );
    
    assign empty = (rd_gray == wr_gray_sync);
    
    assign full = (wr_gray == {~rd_gray_sync[ADDR_WIDTH], ~rd_gray_sync[ADDR_WIDTH-1], 
                                rd_gray_sync[ADDR_WIDTH-2:0]});
    
    fifo_mem #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) mem_inst (
        .wr_clk(wr_clk),
        .wr_en(wr_en && !full),
        .wr_addr(wr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        
        .rd_clk(rd_clk),
        .rd_en(rd_en && !empty),
        .rd_addr(rd_bin),
        .rdata(rdata)
    );                           
endmodule
