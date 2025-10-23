// --------------------------------------------------------------------
// Copyright (c) 2025 by JLSemi Inc.
// --------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------
//  Revision History:1.1
//  Date          By            Revision    Design Description
//---------------------------------------------------------------------
//  2024-04-18    zlguo         1.0         efuse_adapter init
//  2025-02-13    zlguo         1.1         change write fsm
// --------------------------------------------------------------------
// --------------------------------------------------------------------

`define delay 0.1
`timescale 1ns/1ps

module jlsemi_util_*Replace*smic_efuse_adapter
#(
    parameter ADDR_WIDTH  = 6,
    parameter EFUSE_DEPTH = 10
)
(
    // Clock and Reset(active low)
    input   wire            clk,
    input   wire            rstn,

    // Configuration of efuse setup and hold time
    input   wire    [10:0]  T_PGM,
    input   wire    [10:0]  T_WR_AEN,
    input   wire    [2:0]   T_HP_A,
    input   wire    [3:0]   T_SP_PGM,
    input   wire    [3:0]   T_HP_PGM,
    input   wire    [4:0]   T_HP_RD,
    input   wire    [6:0]   T_SP_PG_AVDD,
    input   wire    [6:0]   T_HP_PG_AVDD,

    input   wire    [5:0]   T_RD,
    input   wire    [6:0]   T_RD_AEN,
    input   wire    [1:0]   T_HR_A,
    input   wire    [3:0]   T_SR_RD,
    input   wire    [3:0]   T_HR_RD,

    input   wire    [11:0]  T_AVDD_DLY,

    // Ctrl interface with register
    input   wire            efuse_en,
    input   wire            write_en,
    input   wire    [ADDR_WIDTH-1:0] addr,
    input   wire    [15:0]  wdata,
    output  logic   [15:0]  rdata,
    output  logic           rdata_vld,
    output  logic           ready,

    // Ctrl interface with efuse
    output  logic           PGMEN,
    output  logic           RDEN,
    output  logic           AEN,
    output  logic   [EFUSE_DEPTH-1:0]   A,
    input   wire    [7:0]   D,

    // AVDD enable to analog
    output  logic           AVDD_EN
);

    logic   [7:0]   Q_HIGH;
    logic   [7:0]   Q_LOW;
    logic   [15:0]  time_cnt;
    logic   [15:0]  mask_data;
    logic   [3:0]   shift_cnt;
    logic   [3:0]   pgm_cnt;

    logic   [ADDR_WIDTH-1:0] reg_addr;

    wire            rd_hi_oct_done;
    wire            rd_lo_oct_done;
    wire            pgm_fst_done;
    wire            pgm_nxt_done;
    wire            pgm_ext_done;
    wire            pgm_done;

    wire    [EFUSE_DEPTH-1:0]     addr_hi_oct;
    wire    [EFUSE_DEPTH-1:0]     addr_lo_oct;

    logic   [15:0]  mask_rdata;
    logic   [3:0]   num_ones;

    logic   [7:0]   efuse_ctrl_sm;
    logic   [7:0]   n_efuse_ctrl_sm;

    /* -----------------------------
     Main FSM localparam
     ---------------------------- */
    localparam  EFUSE_SM_INACTIVE    = 8'h1,
                EFUSE_SM_RD_HI_OCT   = 8'h2,
                EFUSE_SM_RD_LO_OCT   = 8'h4,
                EFUSE_SM_RD_DONE     = 8'h8,
                EFUSE_SM_PGM_INIT    = 8'h10,
                EFUSE_SM_PGM_FST_BIT = 8'h20,
                EFUSE_SM_PGM_NXT_BIT = 8'h40,
                EFUSE_SM_PGM_EXIT    = 8'h80;

    assign rd_hi_oct_done = time_cnt == T_SR_RD + T_RD + T_HR_A;
    assign rd_lo_oct_done = time_cnt == T_RD_AEN + T_HR_RD;

    assign pgm_fst_done = time_cnt == T_SP_PG_AVDD + T_AVDD_DLY + T_SP_PGM + T_PGM + T_HP_A;
    assign pgm_nxt_done = time_cnt == T_WR_AEN + T_HP_A;
    assign pgm_ext_done = time_cnt == T_HP_PGM + T_HP_PG_AVDD + T_AVDD_DLY + T_HP_RD;

    assign pgm_done = pgm_cnt == num_ones;

    assign addr_hi_oct = addr_lo_oct + 1;
    assign addr_lo_oct = reg_addr << 1;

    /* ----------------------------------------------------
     Main FSM
     ---------------------------------------------------- */
    always @(posedge clk or negedge rstn)
    begin
        if (~rstn)
            efuse_ctrl_sm <= #`delay EFUSE_SM_INACTIVE;
        else
            efuse_ctrl_sm <= #`delay n_efuse_ctrl_sm;
    end

    always @(*)
    begin
        n_efuse_ctrl_sm  = efuse_ctrl_sm;

        case(efuse_ctrl_sm)
            EFUSE_SM_INACTIVE: begin
                if (efuse_en)
                    n_efuse_ctrl_sm = EFUSE_SM_RD_HI_OCT;
            end

            EFUSE_SM_RD_HI_OCT: begin
                if (rd_hi_oct_done)
                    n_efuse_ctrl_sm = EFUSE_SM_RD_LO_OCT;
            end

            EFUSE_SM_RD_LO_OCT: begin
                if (rd_lo_oct_done) begin
                    n_efuse_ctrl_sm = EFUSE_SM_RD_DONE;
                end
            end

            EFUSE_SM_RD_DONE: begin
                if (~write_en)
                    n_efuse_ctrl_sm = EFUSE_SM_INACTIVE;
                else
                    n_efuse_ctrl_sm = EFUSE_SM_PGM_INIT;
            end

            EFUSE_SM_PGM_INIT: begin
                if (mask_data[0]) begin
                    if (pgm_cnt == 4'd0)
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_FST_BIT;
                    else
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_NXT_BIT;
                end
                else if (shift_cnt == 4'hf)
                    n_efuse_ctrl_sm = EFUSE_SM_INACTIVE;
                else
                    n_efuse_ctrl_sm = EFUSE_SM_PGM_INIT;
            end

            EFUSE_SM_PGM_FST_BIT: begin
                if (pgm_fst_done) begin
                    if (pgm_done)
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_EXIT;
                    else
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_NXT_BIT;
                end
            end

            EFUSE_SM_PGM_NXT_BIT: begin
                if (pgm_nxt_done) begin
                    if (pgm_done)
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_EXIT;
                    else
                        n_efuse_ctrl_sm = EFUSE_SM_PGM_NXT_BIT;
                end
            end

            EFUSE_SM_PGM_EXIT: begin
                if (pgm_ext_done)
                    n_efuse_ctrl_sm = EFUSE_SM_INACTIVE;
            end

            default: n_efuse_ctrl_sm = EFUSE_SM_INACTIVE;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            AVDD_EN     <= 1'b0;
            PGMEN       <= 1'b0;
            RDEN        <= 1'b0;
            AEN         <= 1'b0;
            A           <= {EFUSE_DEPTH{1'b0}};
            Q_HIGH      <= 8'b0;
            Q_LOW       <= 8'b0;
            rdata_vld   <= 1'b0;
            rdata       <= 16'b0;
            ready       <= 1'b0;
            time_cnt    <= 16'b0;
            mask_data   <= 16'b0;
            shift_cnt   <= 4'b0;
            pgm_cnt     <= 4'b0;
        end
        else
        case (efuse_ctrl_sm)
            EFUSE_SM_INACTIVE: begin
                AVDD_EN     <= #`delay 1'b0;
                PGMEN       <= #`delay 1'b0;
                RDEN        <= #`delay 1'b0;
                AEN         <= #`delay 1'b0;
                A           <= #`delay {EFUSE_DEPTH{1'b0}};
                Q_HIGH      <= #`delay 8'b0;
                Q_LOW       <= #`delay 8'b0;
                rdata_vld   <= #`delay 1'b0;
                rdata       <= #`delay 16'b0;
                ready       <= #`delay 1'b0;
                time_cnt    <= #`delay 16'b0;
                mask_data   <= #`delay 16'b0;
                shift_cnt   <= #`delay 4'b0;
                pgm_cnt     <= #`delay 4'b0;
            end

            EFUSE_SM_RD_HI_OCT: begin
                A    <= #`delay addr_hi_oct;
                RDEN <= #`delay 1'b1;

                if (rd_hi_oct_done)
                    time_cnt <= #`delay 16'd0;
                else
                    time_cnt <= #`delay time_cnt + 1'b1;

                if (time_cnt == T_SR_RD)
                    AEN <= #`delay 1'b1;
                else if (time_cnt == T_SR_RD + T_RD)
                    AEN <= #`delay 1'b0;
                else if (time_cnt == T_SR_RD + T_RD + 1)
                    Q_HIGH <= #`delay D;
            end

            EFUSE_SM_RD_LO_OCT: begin
                A    <= #`delay addr_lo_oct;

                if (rd_lo_oct_done)
                    time_cnt <= #`delay 16'd0;
                else
                    time_cnt <= #`delay time_cnt + 1'b1;

                if (time_cnt == T_RD_AEN - T_RD)
                    AEN   <= #`delay 1'b1;
                else if (time_cnt == T_RD_AEN - T_RD + T_RD)
                    AEN   <= #`delay 1'b0;
                else if (time_cnt == T_RD_AEN - T_RD + T_RD + 1)
                    Q_LOW <= #`delay D;
                else if (time_cnt == T_RD_AEN - T_RD + T_RD + T_HR_RD) begin
                    RDEN  <= #`delay 1'b0;
                    rdata <= #`delay {Q_HIGH, Q_LOW};
                    rdata_vld <= #`delay 1'b1;
                end
            end

            EFUSE_SM_RD_DONE: begin
                mask_data <= #`delay ~rdata & (wdata ^ rdata);
                if (~write_en)
                    ready <= #`delay 1'b1;
            end

            EFUSE_SM_PGM_INIT: begin
                rdata_vld <= #`delay 1'b0;
                if (!mask_data[0]) begin
                    mask_data <= #`delay mask_data >> 1;
                    shift_cnt <= #`delay shift_cnt + 1;
                    if (shift_cnt == 4'hf)
                        ready <= #`delay 1'b1;
                end
            end

            EFUSE_SM_PGM_FST_BIT: begin
                AVDD_EN   <= #`delay 1'b1;

                if (pgm_fst_done) begin
                    time_cnt  <= #`delay 16'd0;
                    mask_data <= #`delay mask_data >> 1;
                    shift_cnt <= #`delay shift_cnt + 1;
                end
                else
                    time_cnt <= #`delay time_cnt + 1'b1;

                if (time_cnt == T_SP_PG_AVDD + T_AVDD_DLY) begin
                    if (mask_data[0]) begin
                        A     <= #`delay { shift_cnt[2:0], reg_addr[ADDR_WIDTH-1:0], shift_cnt[3] };
                        PGMEN <= #`delay 1'b1;
                    end
                end
                else if (time_cnt == T_SP_PG_AVDD + T_AVDD_DLY + T_SP_PGM)
                    AEN <= #`delay 1'b1;
                else if (time_cnt == T_SP_PG_AVDD + T_AVDD_DLY + T_SP_PGM + T_PGM) begin
                    AEN <= #`delay 1'b0;
                    pgm_cnt <= #`delay pgm_cnt + 1'b1;
                end
            end

            EFUSE_SM_PGM_NXT_BIT: begin
                AVDD_EN <= #`delay 1'b1;
                PGMEN   <= #`delay 1'b1;

                if (mask_data[0])
                    A       <= #`delay { shift_cnt[2:0], reg_addr[ADDR_WIDTH-1:0], shift_cnt[3] };

                if (pgm_nxt_done) begin
                    time_cnt  <= #`delay 16'd0;
                end
                else if (mask_data[0])
                    time_cnt <= #`delay time_cnt + 1'b1;

                if (!mask_data[0] || pgm_nxt_done) begin
                    shift_cnt <= #`delay shift_cnt + 1;
                    mask_data <= #`delay mask_data >> 1;
                end

                if (time_cnt == T_WR_AEN - T_PGM)
                    AEN <= #`delay 1'b1;
                else if (time_cnt == T_WR_AEN) begin
                    AEN <= #`delay 1'b0;
                    pgm_cnt <= #`delay pgm_cnt + 1'b1;
                end
            end

            EFUSE_SM_PGM_EXIT: begin
                pgm_cnt <= #`delay 4'd0;

                if (pgm_ext_done)
                    time_cnt <= #`delay 16'd0;
                else
                    time_cnt <= #`delay time_cnt + 1'b1;

                if (time_cnt == T_HP_PGM)
                    PGMEN   <= #`delay 1'b0;
                else if (time_cnt == T_HP_PGM + T_HP_PG_AVDD) begin
                    AVDD_EN <= #`delay 1'b0;
                    A       <= #`delay {EFUSE_DEPTH{1'b0}};
                end
                else if (time_cnt == T_HP_PGM + T_HP_PG_AVDD + T_AVDD_DLY + T_HP_RD)
                    ready   <= #`delay 1'b1;
            end

            default: begin            
                AVDD_EN     <= 1'b0;
                PGMEN       <= 1'b0;
                RDEN        <= 1'b0;
                AEN         <= 1'b0;
                A           <= {EFUSE_DEPTH{1'b0}};
                Q_HIGH      <= 8'b0;
                Q_LOW       <= 8'b0;
                rdata_vld   <= 1'b0;
                rdata       <= 16'b0;
                time_cnt    <= 16'b0;
                mask_data   <= 16'b0;
                shift_cnt   <= 4'b0;
            end
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            reg_addr <= #`delay {ADDR_WIDTH{1'b0}};
        else if (efuse_ctrl_sm == EFUSE_SM_INACTIVE)
            reg_addr <= #`delay addr;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            mask_rdata <= #`delay 16'h0;
        else if (rdata_vld)
            mask_rdata <= #`delay ~rdata & (wdata ^ rdata);
    end

    int i;
    always @(*) begin
        num_ones = 4'd0;
        for (i = 0; i < 16; i++) begin
            num_ones += mask_rdata[i]; // spyglass disable W164a STARC05-2.10.3.2b
        end
    end

endmodule
