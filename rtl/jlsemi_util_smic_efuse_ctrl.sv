// ---------------------------------------------------------------------------------
// Copyright (c) 2025 by JLSemi Inc.
// ---------------------------------------------------------------------------------
//
//                     JLSemi
//                     Shanghai, China
//                     Name : Zhiling Guo
//                     Email: zlguo@jlsemi.com
//
// ---------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------
//  Revision History:2.0
//  Date          By            Revision    Design Description
//----------------------------------------------------------------------------------
//  2024-04-18    zlguo         1.0         efuse ctrl init
//  2025-02-13    zlguo         1.1         change main fsm
//  2025-02-20    zlguo         2.0         change efuse ctrl top interface
//  2025-03-14    zlguo         2.1         ifdef register interface or apb interface
// ---------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------

`timescale 1ns/1ps

module jlsemi_util_*Replace*smic_efuse_ctrl #(

`ifdef S40EFUSE_512BITS

    parameter ADDR_WIDTH  = 5,
    parameter EFUSE_DEPTH = 9

`elsif S40EFUSE_1KBITS

    parameter ADDR_WIDTH  = 6,
    parameter EFUSE_DEPTH = 10

`elsif S40EFUSE_2KBITS

    parameter ADDR_WIDTH  = 7,
    parameter EFUSE_DEPTH = 11

`elsif S40EFUSE_4KBITS

    parameter ADDR_WIDTH  = 8,
    parameter EFUSE_DEPTH = 12

`elsif S28EFUSE_512BITS

    parameter ADDR_WIDTH  = 5,
    parameter EFUSE_DEPTH = 9

`elsif S28EFUSE_1KBITS

    parameter ADDR_WIDTH  = 6,
    parameter EFUSE_DEPTH = 10

`elsif S28EFUSE_2KBITS

    parameter ADDR_WIDTH  = 7,
    parameter EFUSE_DEPTH = 11

`elsif S28EFUSE_4KBITS

    parameter ADDR_WIDTH  = 8,
    parameter EFUSE_DEPTH = 12

`else

    parameter ADDR_WIDTH  = 6,
    parameter EFUSE_DEPTH = 10

`endif

)(
    // Clock and Reset(active low)
    input   wire            clk,
    input   wire            rstn,

    // DFT Bypass: Prevent accidental writing or reading efuse
    input   wire            dft_efuse_scan_mode_en,

`ifdef APB_BUS
    // APB Bus access interface
    input   wire            psel,
    input   wire            penable,
    input   wire            pwrite,
    input   wire    [20:0]  paddr,
    input   wire    [15:0]  pwdata,

    output  wire            pready,
    output  wire    [15:0]  prdata,
    output  wire            pslverr,
`else
    // Register config interface
    input   wire            efuse_en,
    input   wire            efuse_write_en,
    input   wire    [ADDR_WIDTH-1:0]    efuse_addr,
    input   wire    [15:0]  efuse_wdata,
    output  wire            efuse_rdata_we,
    output  wire    [15:0]  efuse_rdata,
    output  wire            efuse_ready,
    input   wire    [10:0]  T_PGM,
    input   wire    [10:0]  T_WR_AEN,
    input   wire    [4:0]   T_HP_RD,
    input   wire    [6:0]   T_SP_PG_AVDD,
    input   wire    [1:0]   T_HR_A,
    input   wire    [2:0]   T_HP_A,
    input   wire    [3:0]   T_HP_PGM,
    input   wire    [3:0]   T_HR_RD,
    input   wire    [11:0]  T_AVDD_DLY,
    input   wire    [3:0]   T_SP_PGM,
    input   wire    [3:0]   T_SR_RD,
    input   wire    [5:0]   T_RD,
    input   wire    [6:0]   T_HP_PG_AVDD,
    input   wire    [6:0]   T_RD_AEN,
    input   wire            smi_efuse_sel,
    input   wire            smi_efuse_pgmen,
    input   wire            smi_efuse_rden,
    input   wire            smi_efuse_aen,
    input   wire            smi_efuse_avdd_en,
    input   wire    [EFUSE_DEPTH-1:0]   smi_efuse_a,
    output  logic   [15:0]  smi_efuse_d,
`endif
    // AVDD enable to analog
    output  wire            AVDD_EN
);

`ifdef APB_BUS
    // Configuration of efuse setup and hold time 
    wire    [10:0]  T_PGM;
    wire    [10:0]  T_WR_AEN;
    wire    [2:0]   T_HP_A;
    wire    [3:0]   T_SP_PGM;
    wire    [3:0]   T_HP_PGM;
    wire    [4:0]   T_HP_RD;
    wire    [6:0]   T_SP_PG_AVDD;
    wire    [6:0]   T_HP_PG_AVDD;

    wire    [5:0]   T_RD;
    wire    [6:0]   T_RD_AEN;
    wire    [1:0]   T_HR_A;
    wire    [3:0]   T_SR_RD;
    wire    [3:0]   T_HR_RD;
    wire    [11:0]  T_AVDD_DLY;

    // Write or read opration
    wire            efuse_en;
    wire            efuse_write_en;
    wire    [ADDR_WIDTH-1:0] efuse_addr;
    wire    [15:0]  efuse_wdata;
    wire            efuse_ready;
    wire    [15:0]  efuse_rdata;
`else
`endif

    wire            efuse_rdata_vld;

    // Ctrl interface with efuse
    wire            PGMEN;
    wire            RDEN;
    wire            AEN;
    wire    [EFUSE_DEPTH-1:0]   A;
    wire    [7:0]   D;

    wire            pgmen;
    wire            rden;
    wire            aen;
    wire            avdd_en;
    wire    [EFUSE_DEPTH-1:0]   a;

`ifdef APB_BUS
    wire            smi_efuse_sel;
    wire            smi_efuse_pgmen;
    wire            smi_efuse_rden;
    wire            smi_efuse_aen;
    wire            smi_efuse_avdd_en;
    wire    [EFUSE_DEPTH-1:0]   smi_efuse_a;
    logic   [15:0]  smi_efuse_d;
`else
`endif

    logic   [7:0]   smi_efuse_d_hi;
    logic   [7:0]   smi_efuse_d_lo;

    assign PGMEN    = dft_efuse_scan_mode_en ? 1'b0 : smi_efuse_sel ? smi_efuse_pgmen   : pgmen;
    assign RDEN     = dft_efuse_scan_mode_en ? 1'b0 : smi_efuse_sel ? smi_efuse_rden    : rden;
    assign AEN      = dft_efuse_scan_mode_en ? 1'b0 : smi_efuse_sel ? smi_efuse_aen     : aen;
    assign AVDD_EN  = dft_efuse_scan_mode_en ? 1'b0 : smi_efuse_sel ? smi_efuse_avdd_en : avdd_en;
    assign A        = dft_efuse_scan_mode_en ? {EFUSE_DEPTH{1'b0}} : smi_efuse_sel ? smi_efuse_a : a;

    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            smi_efuse_d_hi <= 8'h0;
            smi_efuse_d_lo <= 8'h0;
            smi_efuse_d    <= 16'h0;
        end
        else if (smi_efuse_rden & smi_efuse_aen) begin
            smi_efuse_d    <= {smi_efuse_d_hi, smi_efuse_d_lo};

            if (smi_efuse_a[0])
                smi_efuse_d_hi <= D;
            else
                smi_efuse_d_lo <= D;
        end
        else begin
            smi_efuse_d_hi <= 8'h0;
            smi_efuse_d_lo <= 8'h0;
        end
    end

    jlsemi_util_*Replace*smic_efuse_adapter
    #(
    .ADDR_WIDTH     (ADDR_WIDTH     ),
    .EFUSE_DEPTH    (EFUSE_DEPTH    )
    )
    u_smic_efuse_adapter
    (
    .clk            (clk            ),
    .rstn           (rstn           ),

    // Configuration of efuse setup and hold time 
    .T_PGM          (T_PGM          ),       
    .T_WR_AEN       (T_WR_AEN       ),        
    .T_HP_A         (T_HP_A         ),       
    .T_SP_PGM       (T_SP_PGM       ),     
    .T_HP_PGM       (T_HP_PGM       ),     
    .T_HP_RD        (T_HP_RD        ),
    .T_SP_PG_AVDD   (T_SP_PG_AVDD   ), 
    .T_HP_PG_AVDD   (T_HP_PG_AVDD   ), 
                                    
    .T_RD           (T_RD           ),         
    .T_RD_AEN       (T_RD_AEN       ),        
    .T_HR_A         (T_HR_A         ),       
    .T_SR_RD        (T_SR_RD        ),      
    .T_HR_RD        (T_HR_RD        ),      
    .T_AVDD_DLY     (T_AVDD_DLY     ),

    // Write or read opration
    .efuse_en       (efuse_en       ),
    .write_en       (efuse_write_en ),
    .addr           (efuse_addr     ),
    .wdata          (efuse_wdata    ),
    .rdata          (efuse_rdata    ),
    .rdata_vld      (efuse_rdata_vld),
    .ready          (efuse_ready    ),

    // Ctrl interface with efuse
    .PGMEN          (pgmen          ),
    .RDEN           (rden           ),
    .AEN            (aen            ),
    .A              (a              ),
    .D              (D              ),

    // AVDD enable to analog
    .AVDD_EN        (avdd_en        )
    );

`ifdef APB_BUS
    jlsemi_util_*Replace*smic_efuse_regmap #(ADDR_WIDTH,EFUSE_DEPTH)
    u_smic_efuse_rf
    (
    .clk                    (clk                    ),
    .rstn                   (rstn                   ),
    .sw_rstn                (1'b1                   ),
    .psel                   (psel                   ),
    .penable                (penable                ),
    .pwrite                 (pwrite                 ),
    .paddr                  ({ 11'h0, paddr }       ),
    .pwdata                 ({ 16'h0, pwdata }      ),
    .pready                 (pready                 ),
    .prdata                 (prdata                 ),
    .pslverr                (pslverr                ),
    .efuse_en_rdata         (efuse_en               ),
    .efuse_write_en_rdata   (efuse_write_en         ),
    .efuse_addr_rdata       (efuse_addr             ),
    .efuse_wdata_rdata      (efuse_wdata            ),
    .efuse_rdata_we         (efuse_rdata_vld & ~efuse_write_en),
    .efuse_rdata_wdata      (efuse_rdata            ),
    .efuse_ready_wdata      (efuse_ready            ),
    .T_HR_A_rdata           (T_HR_A                 ),
    .T_PGM_rdata            (T_PGM                  ),
    .T_WR_AEN_rdata         (T_WR_AEN               ),
    .T_HP_RD_rdata          (T_HP_RD                ),
    .T_HP_A_rdata           (T_HP_A                 ),
    .T_RD_AEN_rdata         (T_RD_AEN               ),
    .T_HP_PGM_rdata         (T_HP_PGM               ),
    .T_HR_RD_rdata          (T_HR_RD                ),
    .T_AVDD_DLY_rdata       (T_AVDD_DLY             ),
    .T_SP_PGM_rdata         (T_SP_PGM               ),
    .T_SR_RD_rdata          (T_SR_RD                ),
    .T_RD_rdata             (T_RD                   ),
    .T_HP_PG_AVDD_rdata     (T_HP_PG_AVDD           ),
    .T_SP_PG_AVDD_rdata     (T_SP_PG_AVDD           ),
    .smi_efuse_sel_rdata    (smi_efuse_sel          ),
    .smi_efuse_pgmen_rdata  (smi_efuse_pgmen        ),
    .smi_efuse_rden_rdata   (smi_efuse_rden         ),
    .smi_efuse_aen_rdata    (smi_efuse_aen          ),
    .smi_efuse_avdd_en_rdata(smi_efuse_avdd_en      ),
    .smi_efuse_a_rdata      (smi_efuse_a            ),
    .smi_efuse_d_wdata      (smi_efuse_d            )
    );
`else
    assign efuse_rdata_we = efuse_rdata_vld & ~efuse_write_en;
`endif

/* DVDD: Digital power: S40-1.1V(S28-0.9V)
         -Note: Simulation needs to force 1'b1
   AVDD: Analog power: S40-2.5V(S28-1.8V)1.8V
         -Note: Simulation needs to force analog LDO_2P5V(LDO_1P8V) signal which be controlled by ctrl signal AVDD_EN
   DVSS: Ground
         -Note: Simulation needs to force 1'b0
*/
`ifdef S40EFUSE_512BITS

    S40NLLEFUSE_PIPO512B_F2

`elsif S40EFUSE_1KBITS

    S40NLLEFUSE_PIPO1KB_F2

`elsif S40EFUSE_2KBITS

    S40NLLEFUSE_PIPO2KB_F2

`elsif S40EFUSE_4KBITS

    S40NLLEFUSE_PIPO4KB_F2

`elsif S28EFUSE_512BITS

    S28NHKCPEFUSE_PIPO512B

`elsif S28EFUSE_1KBITS

    S28NHKCPEFUSE_PIPO1KB

`elsif S28EFUSE_2KBITS

    S28NHKCPEFUSE_PIPO2KB

`elsif S28EFUSE_4KBITS

    S28NHKCPEFUSE_PIPO4KB

`else

    S40NLLEFUSE_PIPO1KB_F2
    
`endif

    u_efuse
    (
    .DVDD   (       ), 
    .AVDD   (       ), 
    .DVSS   (       ), 
    .AEN    (AEN    ),
    .RDEN   (RDEN   ),
    .PGMEN  (PGMEN  ),
    .A      (A      ),
    .D      (D      )
    );

endmodule
