module jlsemi_util_*Replace*smic_efuse_regmap
#(  parameter ADDR_WIDTH  = 6,
    parameter EFUSE_DEPTH  = 10
)
(
    input   wire             clk,
    input   wire             rstn,
 
    input   wire             psel,
    input   wire             penable,
    input   wire             pwrite,
    input   wire    [31:0]   paddr,
    input   wire    [31:0]   pwdata,
 
    output  wire             pready,
    output  wire    [31:0]   prdata,

    output  wire             pslverr,

    output  wire             efuse_en_rdata,
    output  wire             efuse_write_en_rdata,
    input   wire             sw_rstn,
    input   wire             efuse_ready_wdata,
    output  wire    [ADDR_WIDTH-1:0]    efuse_addr_rdata,
    output  wire    [15:0]   efuse_wdata_rdata,
    input   wire    [15:0]   efuse_rdata_wdata,
    input   wire             efuse_rdata_we,
    output  wire    [10:0]   T_PGM_rdata,
    output  wire    [10:0]   T_WR_AEN_rdata,
    output  wire    [2:0]    T_HP_A_rdata,
    output  wire    [3:0]    T_SP_PGM_rdata,
    output  wire    [3:0]    T_HP_PGM_rdata,
    output  wire    [4:0]    T_HP_RD_rdata,
    output  wire    [6:0]    T_SP_PG_AVDD_rdata,
    output  wire    [6:0]    T_HP_PG_AVDD_rdata,
    output  wire    [5:0]    T_RD_rdata,
    output  wire    [6:0]    T_RD_AEN_rdata,
    output  wire    [1:0]    T_HR_A_rdata,
    output  wire    [3:0]    T_SR_RD_rdata,
    output  wire    [3:0]    T_HR_RD_rdata,
    output  wire    [11:0]   T_AVDD_DLY_rdata,
    output  wire             smi_efuse_sel_rdata,
    output  wire             smi_efuse_pgmen_rdata,
    output  wire             smi_efuse_rden_rdata,
    output  wire             smi_efuse_aen_rdata,
    output  wire             smi_efuse_avdd_en_rdata,
    output  wire    [EFUSE_DEPTH-1:0]   smi_efuse_a_rdata,
    input   wire    [15:0]   smi_efuse_d_wdata
);

    reg     [31:0]  bus_rdata;

    // Bus re Wires
    wire            efuse_ready_bus_re;

    // Bus we Wires
    wire            efuse_en_bus_we;
    wire            efuse_write_en_bus_we;
    wire            efuse_addr_bus_we;
    wire            efuse_wdata_bus_we;
    wire            T_PGM_bus_we;
    wire            T_WR_AEN_bus_we;
    wire            T_HP_A_bus_we;
    wire            T_SP_PGM_bus_we;
    wire            T_HP_PGM_bus_we;
    wire            T_HP_RD_bus_we;
    wire            T_SP_PG_AVDD_bus_we;
    wire            T_HP_PG_AVDD_bus_we;
    wire            T_RD_bus_we;
    wire            T_RD_AEN_bus_we;
    wire            T_HR_A_bus_we;
    wire            T_SR_RD_bus_we;
    wire            T_HR_RD_bus_we;
    wire            T_AVDD_DLY_bus_we;
    wire            smi_efuse_sel_bus_we;
    wire            smi_efuse_pgmen_bus_we;
    wire            smi_efuse_rden_bus_we;
    wire            smi_efuse_aen_bus_we;
    wire            smi_efuse_avdd_en_bus_we;
    wire            smi_efuse_a_bus_we;

    // Bus wdata Wires
    wire            efuse_en_bus_wdata;
    wire            efuse_write_en_bus_wdata;
    wire    [ADDR_WIDTH-1:0]   efuse_addr_bus_wdata;
    wire    [15:0]  efuse_wdata_bus_wdata;
    wire    [10:0]  T_PGM_bus_wdata;
    wire    [10:0]  T_WR_AEN_bus_wdata;
    wire    [2:0]   T_HP_A_bus_wdata;
    wire    [3:0]   T_SP_PGM_bus_wdata;
    wire    [3:0]   T_HP_PGM_bus_wdata;
    wire    [4:0]   T_HP_RD_bus_wdata;
    wire    [6:0]   T_SP_PG_AVDD_bus_wdata;
    wire    [6:0]   T_HP_PG_AVDD_bus_wdata;
    wire    [5:0]   T_RD_bus_wdata;
    wire    [6:0]   T_RD_AEN_bus_wdata;
    wire    [1:0]   T_HR_A_bus_wdata;
    wire    [3:0]   T_SR_RD_bus_wdata;
    wire    [3:0]   T_HR_RD_bus_wdata;
    wire    [11:0]  T_AVDD_DLY_bus_wdata;
    wire            smi_efuse_sel_bus_wdata;
    wire            smi_efuse_pgmen_bus_wdata;
    wire            smi_efuse_rden_bus_wdata;
    wire            smi_efuse_aen_bus_wdata;
    wire            smi_efuse_avdd_en_bus_wdata;
    wire    [EFUSE_DEPTH-1:0]  smi_efuse_a_bus_wdata;

    // Bus rdata Wires
    wire            efuse_ready_bus_rdata;
    wire            efuse_write_en_bus_rdata;
    wire    [ADDR_WIDTH-1:0]   efuse_addr_bus_rdata;
    wire    [15:0]  efuse_wdata_bus_rdata;
    wire    [15:0]  efuse_rdata_bus_rdata;
    wire    [10:0]  T_PGM_bus_rdata;
    wire    [10:0]  T_WR_AEN_bus_rdata;
    wire    [2:0]   T_HP_A_bus_rdata;
    wire    [3:0]   T_SP_PGM_bus_rdata;
    wire    [3:0]   T_HP_PGM_bus_rdata;
    wire    [4:0]   T_HP_RD_bus_rdata;
    wire    [6:0]   T_SP_PG_AVDD_bus_rdata;
    wire    [6:0]   T_HP_PG_AVDD_bus_rdata;
    wire    [5:0]   T_RD_bus_rdata;
    wire    [6:0]   T_RD_AEN_bus_rdata;
    wire    [1:0]   T_HR_A_bus_rdata;
    wire    [3:0]   T_SR_RD_bus_rdata;
    wire    [3:0]   T_HR_RD_bus_rdata;
    wire    [11:0]  T_AVDD_DLY_bus_rdata;
    wire            smi_efuse_sel_bus_rdata;
    wire            smi_efuse_pgmen_bus_rdata;
    wire            smi_efuse_rden_bus_rdata;
    wire            smi_efuse_aen_bus_rdata;
    wire            smi_efuse_avdd_en_bus_rdata;
    wire    [EFUSE_DEPTH-1:0]  smi_efuse_a_bus_rdata;
    wire    [15:0]  smi_efuse_d_bus_rdata;

    // Address Select Wires
    wire            addr_0x0_sel;
    wire            addr_0x1_sel;
    wire            addr_0x3_sel;
    wire            addr_0x5_sel;
    wire            addr_0x6_sel;
    wire            addr_0x7_sel;
    wire            addr_0x8_sel;
    wire            addr_0x9_sel;
    wire            addr_0xa_sel;
    wire            addr_0xb_sel;
    wire            addr_0xc_sel;
    wire            addr_0xd_sel;
    wire            addr_0xe_sel;
    wire            addr_0x10_sel;
    wire            addr_0x11_sel;
    wire            addr_0x12_sel;
    wire            addr_0x13_sel;
    wire            addr_0x20_sel;
    wire            addr_0x21_sel;
    wire            addr_0x22_sel;
    wire            addr_0x23_sel;
    wire            addr_0x24_sel;
    wire            addr_0x25_sel;

    // Bus rdata whitch Address Selected Wires
    wire    [31:0]  addr_0x0_sel_bus_rdata;
    wire    [31:0]  addr_0x1_sel_bus_rdata;
    wire    [31:0]  addr_0x3_sel_bus_rdata;
    wire    [31:0]  addr_0x4_sel_bus_rdata;
    wire    [31:0]  addr_0x5_sel_bus_rdata;
    wire    [31:0]  addr_0x6_sel_bus_rdata;
    wire    [31:0]  addr_0x7_sel_bus_rdata;
    wire    [31:0]  addr_0x8_sel_bus_rdata;
    wire    [31:0]  addr_0x9_sel_bus_rdata;
    wire    [31:0]  addr_0xa_sel_bus_rdata;
    wire    [31:0]  addr_0xb_sel_bus_rdata;
    wire    [31:0]  addr_0xc_sel_bus_rdata;
    wire    [31:0]  addr_0xd_sel_bus_rdata;
    wire    [31:0]  addr_0xe_sel_bus_rdata;
    wire    [31:0]  addr_0x10_sel_bus_rdata;
    wire    [31:0]  addr_0x11_sel_bus_rdata;
    wire    [31:0]  addr_0x12_sel_bus_rdata;
    wire    [31:0]  addr_0x13_sel_bus_rdata;
    wire    [31:0]  addr_0x20_sel_bus_rdata;
    wire    [31:0]  addr_0x21_sel_bus_rdata;
    wire    [31:0]  addr_0x22_sel_bus_rdata;
    wire    [31:0]  addr_0x23_sel_bus_rdata;
    wire    [31:0]  addr_0x24_sel_bus_rdata;
    wire    [31:0]  addr_0x25_sel_bus_rdata;
    wire    [31:0]  addr_0x26_sel_bus_rdata;

    // whitch address be selected: psel * penable * paddr
    assign  addr_0x0_sel   = (paddr == 32'h0) & psel & penable;
    assign  addr_0x1_sel   = (paddr == 32'h1) & psel & penable;
    assign  addr_0x3_sel   = (paddr == 32'h3) & psel & penable;
    assign  addr_0x5_sel   = (paddr == 32'h5) & psel & penable;
    assign  addr_0x6_sel   = (paddr == 32'h6) & psel & penable;
    assign  addr_0x7_sel   = (paddr == 32'h7) & psel & penable;
    assign  addr_0x8_sel   = (paddr == 32'h8) & psel & penable;
    assign  addr_0x9_sel   = (paddr == 32'h9) & psel & penable;
    assign  addr_0xa_sel   = (paddr == 32'ha) & psel & penable;
    assign  addr_0xb_sel   = (paddr == 32'hb) & psel & penable;
    assign  addr_0xc_sel   = (paddr == 32'hc) & psel & penable;
    assign  addr_0xd_sel   = (paddr == 32'hd) & psel & penable;
    assign  addr_0xe_sel   = (paddr == 32'he) & psel & penable;
    assign  addr_0x10_sel  = (paddr == 32'h10) & psel & penable;
    assign  addr_0x11_sel  = (paddr == 32'h11) & psel & penable;
    assign  addr_0x12_sel  = (paddr == 32'h12) & psel & penable;
    assign  addr_0x13_sel  = (paddr == 32'h13) & psel & penable;
    assign  addr_0x20_sel  = (paddr == 32'h20) & psel & penable;
    assign  addr_0x21_sel  = (paddr == 32'h21) & psel & penable;
    assign  addr_0x22_sel  = (paddr == 32'h22) & psel & penable;
    assign  addr_0x23_sel  = (paddr == 32'h23) & psel & penable;
    assign  addr_0x24_sel  = (paddr == 32'h24) & psel & penable;
    assign  addr_0x25_sel  = (paddr == 32'h25) & psel & penable;

    // bus_re: addr_{address}_sel & ~pwrite
    assign  efuse_ready_bus_re             = addr_0x0_sel & ~pwrite;

    // bus_we: addr_{address}_sel & pwrite
    assign  efuse_en_bus_we                = addr_0x0_sel & pwrite;
    assign  efuse_write_en_bus_we          = addr_0x0_sel & pwrite;
    assign  efuse_addr_bus_we              = addr_0x1_sel & pwrite;
    assign  efuse_wdata_bus_we             = addr_0x3_sel & pwrite;
    assign  T_PGM_bus_we                   = addr_0x5_sel & pwrite;
    assign  T_WR_AEN_bus_we                = addr_0x6_sel & pwrite;
    assign  T_HP_A_bus_we                  = addr_0x7_sel & pwrite;
    assign  T_SP_PGM_bus_we                = addr_0x8_sel & pwrite;
    assign  T_HP_PGM_bus_we                = addr_0x9_sel & pwrite;
    assign  T_HP_RD_bus_we                 = addr_0xa_sel & pwrite;
    assign  T_SP_PG_AVDD_bus_we            = addr_0xb_sel & pwrite;
    assign  T_HP_PG_AVDD_bus_we            = addr_0xc_sel & pwrite;
    assign  T_RD_bus_we                    = addr_0xd_sel & pwrite;
    assign  T_RD_AEN_bus_we                = addr_0xe_sel & pwrite;
    assign  T_HR_A_bus_we                  = addr_0x10_sel & pwrite;
    assign  T_SR_RD_bus_we                 = addr_0x11_sel & pwrite;
    assign  T_HR_RD_bus_we                 = addr_0x12_sel & pwrite;
    assign  T_AVDD_DLY_bus_we              = addr_0x13_sel & pwrite;
    assign  smi_efuse_sel_bus_we           = addr_0x20_sel & pwrite;
    assign  smi_efuse_pgmen_bus_we         = addr_0x21_sel & pwrite;
    assign  smi_efuse_rden_bus_we          = addr_0x22_sel & pwrite;
    assign  smi_efuse_aen_bus_we           = addr_0x23_sel & pwrite;
    assign  smi_efuse_avdd_en_bus_we       = addr_0x24_sel & pwrite;
    assign  smi_efuse_a_bus_we             = addr_0x25_sel & pwrite;

    // pwdata: bus_wdata
    assign  efuse_en_bus_wdata             = pwdata[2];
    assign  efuse_write_en_bus_wdata       = pwdata[1];
    assign  efuse_addr_bus_wdata           = pwdata[ADDR_WIDTH-1:0];
    assign  efuse_wdata_bus_wdata          = pwdata[15:0];
    assign  T_PGM_bus_wdata                = pwdata[10:0];
    assign  T_WR_AEN_bus_wdata             = pwdata[10:0];
    assign  T_HP_A_bus_wdata               = pwdata[2:0];
    assign  T_SP_PGM_bus_wdata             = pwdata[3:0];
    assign  T_HP_PGM_bus_wdata             = pwdata[3:0];
    assign  T_HP_RD_bus_wdata              = pwdata[4:0];
    assign  T_SP_PG_AVDD_bus_wdata         = pwdata[6:0];
    assign  T_HP_PG_AVDD_bus_wdata         = pwdata[6:0];
    assign  T_RD_bus_wdata                 = pwdata[5:0];
    assign  T_RD_AEN_bus_wdata             = pwdata[6:0];
    assign  T_HR_A_bus_wdata               = pwdata[1:0];
    assign  T_SR_RD_bus_wdata              = pwdata[3:0];
    assign  T_HR_RD_bus_wdata              = pwdata[3:0];
    assign  T_AVDD_DLY_bus_wdata           = pwdata[11:0];
    assign  smi_efuse_sel_bus_wdata        = pwdata[0];
    assign  smi_efuse_pgmen_bus_wdata      = pwdata[0];
    assign  smi_efuse_rden_bus_wdata       = pwdata[0];
    assign  smi_efuse_aen_bus_wdata        = pwdata[0];
    assign  smi_efuse_avdd_en_bus_wdata    = pwdata[0];
    assign  smi_efuse_a_bus_wdata          = pwdata[EFUSE_DEPTH-1:0];

    // addr_{address}_sel_bus_rdata = {registers bus_rdata}
    assign  addr_0x0_sel_bus_rdata = {30'h0, efuse_write_en_bus_rdata, efuse_ready_bus_rdata};
    assign  addr_0x1_sel_bus_rdata = {{(32-ADDR_WIDTH){1'b0}}, efuse_addr_bus_rdata};
    assign  addr_0x3_sel_bus_rdata = {16'h0, efuse_wdata_bus_rdata};
    assign  addr_0x4_sel_bus_rdata = {16'h0, efuse_rdata_bus_rdata};
    assign  addr_0x5_sel_bus_rdata = {21'h0, T_PGM_bus_rdata};
    assign  addr_0x6_sel_bus_rdata = {21'h0, T_WR_AEN_bus_rdata};
    assign  addr_0x7_sel_bus_rdata = {29'h0, T_HP_A_bus_rdata};
    assign  addr_0x8_sel_bus_rdata = {28'h0, T_SP_PGM_bus_rdata};
    assign  addr_0x9_sel_bus_rdata = {28'h0, T_HP_PGM_bus_rdata};
    assign  addr_0xa_sel_bus_rdata = {27'h0, T_HP_RD_bus_rdata};
    assign  addr_0xb_sel_bus_rdata = {25'h0, T_SP_PG_AVDD_bus_rdata};
    assign  addr_0xc_sel_bus_rdata = {25'h0, T_HP_PG_AVDD_bus_rdata};
    assign  addr_0xd_sel_bus_rdata = {26'h0, T_RD_bus_rdata};
    assign  addr_0xe_sel_bus_rdata = {25'h0, T_RD_AEN_bus_rdata};
    assign  addr_0x10_sel_bus_rdata = {30'h0, T_HR_A_bus_rdata};
    assign  addr_0x11_sel_bus_rdata = {28'h0, T_SR_RD_bus_rdata};
    assign  addr_0x12_sel_bus_rdata = {28'h0, T_HR_RD_bus_rdata};
    assign  addr_0x13_sel_bus_rdata = {20'h0, T_AVDD_DLY_bus_rdata};
    assign  addr_0x20_sel_bus_rdata = {31'h0, smi_efuse_sel_bus_rdata};
    assign  addr_0x21_sel_bus_rdata = {31'h0, smi_efuse_pgmen_bus_rdata};
    assign  addr_0x22_sel_bus_rdata = {31'h0, smi_efuse_rden_bus_rdata};
    assign  addr_0x23_sel_bus_rdata = {31'h0, smi_efuse_aen_bus_rdata};
    assign  addr_0x24_sel_bus_rdata = {31'h0, smi_efuse_avdd_en_bus_rdata};
    assign  addr_0x25_sel_bus_rdata = {{(32-EFUSE_DEPTH){1'b0}}, smi_efuse_a_bus_rdata};
    assign  addr_0x26_sel_bus_rdata = {16'h0, smi_efuse_d_bus_rdata};

    // prdata: bus_rdata
    assign prdata  =  bus_rdata;

    // pready: bus_ready
    assign  pready = penable;

    // Generate pslverr
    assign  pslverr = 1'b0;


    always @(*) begin
        bus_rdata = 32'h0;
        if (psel & penable & ~pwrite) begin
            case (paddr)
                32'h0: bus_rdata = addr_0x0_sel_bus_rdata;
                32'h1: bus_rdata = addr_0x1_sel_bus_rdata;
                32'h3: bus_rdata = addr_0x3_sel_bus_rdata;
                32'h4: bus_rdata = addr_0x4_sel_bus_rdata;
                32'h5: bus_rdata = addr_0x5_sel_bus_rdata;
                32'h6: bus_rdata = addr_0x6_sel_bus_rdata;
                32'h7: bus_rdata = addr_0x7_sel_bus_rdata;
                32'h8: bus_rdata = addr_0x8_sel_bus_rdata;
                32'h9: bus_rdata = addr_0x9_sel_bus_rdata;
                32'ha: bus_rdata = addr_0xa_sel_bus_rdata;
                32'hb: bus_rdata = addr_0xb_sel_bus_rdata;
                32'hc: bus_rdata = addr_0xc_sel_bus_rdata;
                32'hd: bus_rdata = addr_0xd_sel_bus_rdata;
                32'he: bus_rdata = addr_0xe_sel_bus_rdata;
                32'h10: bus_rdata = addr_0x10_sel_bus_rdata;
                32'h11: bus_rdata = addr_0x11_sel_bus_rdata;
                32'h12: bus_rdata = addr_0x12_sel_bus_rdata;
                32'h13: bus_rdata = addr_0x13_sel_bus_rdata;
                32'h20: bus_rdata = addr_0x20_sel_bus_rdata;
                32'h21: bus_rdata = addr_0x21_sel_bus_rdata;
                32'h22: bus_rdata = addr_0x22_sel_bus_rdata;
                32'h23: bus_rdata = addr_0x23_sel_bus_rdata;
                32'h24: bus_rdata = addr_0x24_sel_bus_rdata;
                32'h25: bus_rdata = addr_0x25_sel_bus_rdata;
                32'h26: bus_rdata = addr_0x26_sel_bus_rdata;
                default: bus_rdata = 32'h0;
            endcase
        end else begin
            bus_rdata = 32'h0;
        end
    end


    // ********************************************************************
    // desc:EFUSE_CTRL reg_name:efuse_op address:0x0
    // ********************************************************************
    regmap_smic_efuse_efuse_en_SCREG
    u_efuse_en
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (efuse_en_bus_we),
    .bus_wdata          (efuse_en_bus_wdata),
    .dev_rdata          (efuse_en_rdata)
    );

    regmap_smic_efuse_write_en_RWR
    u_efuse_write_en
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (efuse_write_en_bus_we),
    .bus_wdata          (efuse_write_en_bus_wdata),
    .bus_rdata          (efuse_write_en_bus_rdata),
    .dev_rdata          (efuse_write_en_rdata)
    );

    regmap_smic_efuse_efuse_ready_ROLH
    u_efuse_ready
    (
    .clk                (clk),
    .rstn               (rstn),
    .sw_rstn            (sw_rstn),
    .bus_re             (efuse_ready_bus_re),
    .bus_rdata          (efuse_ready_bus_rdata),
    .dev_wdata          (efuse_ready_wdata)
    );

    // ********************************************************************
    // desc:EFUSE_CTRL reg_name:efuse_addr address:0x1
    // ********************************************************************
    regmap_smic_efuse_efuse_addr_RWR #(ADDR_WIDTH)
    u_efuse_addr
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (efuse_addr_bus_we),
    .bus_wdata          (efuse_addr_bus_wdata),
    .bus_rdata          (efuse_addr_bus_rdata),
    .dev_rdata          (efuse_addr_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CTRL reg_name:efuse_wdata address:0x3
    // ********************************************************************
    regmap_smic_efuse_efuse_wdata_RWR_16
    u_efuse_wdata
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (efuse_wdata_bus_we),
    .bus_wdata          (efuse_wdata_bus_wdata),
    .bus_rdata          (efuse_wdata_bus_rdata),
    .dev_rdata          (efuse_wdata_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CTRL reg_name:efuse_rdata address:0x4
    // ********************************************************************
    regmap_smic_efuse_efuse_rdata_RODEV_16
    u_efuse_rdata
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_rdata          (efuse_rdata_bus_rdata),
    .dev_we             (efuse_rdata_we),
    .dev_wdata          (efuse_rdata_wdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_PGM address:0x5
    // ********************************************************************
    regmap_smic_efuse_T_PGM_RWR_11
    u_T_PGM
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_PGM_bus_we),
    .bus_wdata          (T_PGM_bus_wdata),
    .bus_rdata          (T_PGM_bus_rdata),
    .dev_rdata          (T_PGM_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_WR_AEN address:0x6
    // ********************************************************************
    regmap_smic_efuse_T_WR_AEN_RWR_11
    u_T_WR_AEN
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_WR_AEN_bus_we),
    .bus_wdata          (T_WR_AEN_bus_wdata),
    .bus_rdata          (T_WR_AEN_bus_rdata),
    .dev_rdata          (T_WR_AEN_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HP_A address:0x7
    // ********************************************************************
    regmap_smic_efuse_T_HP_A_RWR_3
    u_T_HP_A
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HP_A_bus_we),
    .bus_wdata          (T_HP_A_bus_wdata),
    .bus_rdata          (T_HP_A_bus_rdata),
    .dev_rdata          (T_HP_A_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_SP_PGM address:0x8
    // ********************************************************************
    regmap_smic_efuse_T_SP_PGM_RWR_4
    u_T_SP_PGM
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_SP_PGM_bus_we),
    .bus_wdata          (T_SP_PGM_bus_wdata),
    .bus_rdata          (T_SP_PGM_bus_rdata),
    .dev_rdata          (T_SP_PGM_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HP_PGM address:0x9
    // ********************************************************************
    regmap_smic_efuse_T_HP_PGM_RWR_4
    u_T_HP_PGM
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HP_PGM_bus_we),
    .bus_wdata          (T_HP_PGM_bus_wdata),
    .bus_rdata          (T_HP_PGM_bus_rdata),
    .dev_rdata          (T_HP_PGM_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HP_RD address:0xa
    // ********************************************************************
    regmap_smic_efuse_T_HP_RD_RWR_4
    u_T_HP_RD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HP_RD_bus_we),
    .bus_wdata          (T_HP_RD_bus_wdata),
    .bus_rdata          (T_HP_RD_bus_rdata),
    .dev_rdata          (T_HP_RD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_SP_PG_AVDD address:0xb
    // ********************************************************************
    regmap_smic_efuse_T_SP_PG_AVDD_RWR_7
    u_T_SP_PG_AVDD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_SP_PG_AVDD_bus_we),
    .bus_wdata          (T_SP_PG_AVDD_bus_wdata),
    .bus_rdata          (T_SP_PG_AVDD_bus_rdata),
    .dev_rdata          (T_SP_PG_AVDD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HP_PG_AVDD address:0xc
    // ********************************************************************
    regmap_smic_efuse_T_HP_PG_AVDD_RWR_7
    u_T_HP_PG_AVDD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HP_PG_AVDD_bus_we),
    .bus_wdata          (T_HP_PG_AVDD_bus_wdata),
    .bus_rdata          (T_HP_PG_AVDD_bus_rdata),
    .dev_rdata          (T_HP_PG_AVDD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_RD address:0xd
    // ********************************************************************
    regmap_smic_efuse_T_RD_RWR_6
    u_T_RD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_RD_bus_we),
    .bus_wdata          (T_RD_bus_wdata),
    .bus_rdata          (T_RD_bus_rdata),
    .dev_rdata          (T_RD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_RD_AEN address:0xe
    // ********************************************************************
    regmap_smic_efuse_T_RD_AEN_RWR_7
    u_T_RD_AEN
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_RD_AEN_bus_we),
    .bus_wdata          (T_RD_AEN_bus_wdata),
    .bus_rdata          (T_RD_AEN_bus_rdata),
    .dev_rdata          (T_RD_AEN_rdata)
    );


    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HR_A address:0x10
    // ********************************************************************
    regmap_smic_efuse_T_HR_A_RWR_2
    u_T_HR_A
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HR_A_bus_we),
    .bus_wdata          (T_HR_A_bus_wdata),
    .bus_rdata          (T_HR_A_bus_rdata),
    .dev_rdata          (T_HR_A_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_SR_RD address:0x11
    // ********************************************************************
    regmap_smic_efuse_T_SR_RD_RWR_4
    u_T_SR_RD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_SR_RD_bus_we),
    .bus_wdata          (T_SR_RD_bus_wdata),
    .bus_rdata          (T_SR_RD_bus_rdata),
    .dev_rdata          (T_SR_RD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_HR_RD address:0x12
    // ********************************************************************
    regmap_smic_efuse_T_HR_RD_RWR_4
    u_T_HR_RD
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_HR_RD_bus_we),
    .bus_wdata          (T_HR_RD_bus_wdata),
    .bus_rdata          (T_HR_RD_bus_rdata),
    .dev_rdata          (T_HR_RD_rdata)
    );

    // ********************************************************************
    // desc:EFUSE_CFG reg_name:T_AVDD_DLY address:0x13
    // ********************************************************************
    regmap_smic_efuse_T_AVDD_DLY_RWR_12
    u_T_AVDD_DLY
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (T_AVDD_DLY_bus_we),
    .bus_wdata          (T_AVDD_DLY_bus_wdata),
    .bus_rdata          (T_AVDD_DLY_bus_rdata),
    .dev_rdata          (T_AVDD_DLY_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_sel reg_name:smi_efuse_sel address:0x20
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_sel_RWR
    u_smi_efuse_sel
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_sel_bus_we),
    .bus_wdata          (smi_efuse_sel_bus_wdata),
    .bus_rdata          (smi_efuse_sel_bus_rdata),
    .dev_rdata          (smi_efuse_sel_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_pgmen reg_name:smi_efuse_pgmen address:0x21
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_pgmen_RWR
    u_smi_efuse_pgmen
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_pgmen_bus_we),
    .bus_wdata          (smi_efuse_pgmen_bus_wdata),
    .bus_rdata          (smi_efuse_pgmen_bus_rdata),
    .dev_rdata          (smi_efuse_pgmen_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_rden reg_name:smi_efuse_rden address:0x22
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_rden_RWR
    u_smi_efuse_rden
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_rden_bus_we),
    .bus_wdata          (smi_efuse_rden_bus_wdata),
    .bus_rdata          (smi_efuse_rden_bus_rdata),
    .dev_rdata          (smi_efuse_rden_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_aen reg_name:smi_efuse_aen address:0x23
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_aen_RWR
    u_smi_efuse_aen
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_aen_bus_we),
    .bus_wdata          (smi_efuse_aen_bus_wdata),
    .bus_rdata          (smi_efuse_aen_bus_rdata),
    .dev_rdata          (smi_efuse_aen_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_avdd_en reg_name:smi_efuse_avdd_en address:0x24
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_avdd_en_RWR
    u_smi_efuse_avdd_en
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_avdd_en_bus_we),
    .bus_wdata          (smi_efuse_avdd_en_bus_wdata),
    .bus_rdata          (smi_efuse_avdd_en_bus_rdata),
    .dev_rdata          (smi_efuse_avdd_en_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_a reg_name:smi_efuse_a address:0x25
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_a_RWR #(EFUSE_DEPTH)
    u_smi_efuse_a
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_we             (smi_efuse_a_bus_we),
    .bus_wdata          (smi_efuse_a_bus_wdata),
    .bus_rdata          (smi_efuse_a_bus_rdata),
    .dev_rdata          (smi_efuse_a_rdata)
    );

    // ********************************************************************
    // desc:smi_efuse_d reg_name:smi_efuse_d address:0x26
    // ********************************************************************
    regmap_smic_efuse_smi_efuse_d_ROR_16
    u_smi_efuse_d
    (
    .clk                (clk),
    .rstn               (rstn),
    .bus_rdata          (smi_efuse_d_bus_rdata),
    .dev_wdata          (smi_efuse_d_wdata)
    );

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  SCREG         write clear     write clear   read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_efuse_en_SCREG
(
    input   wire    clk,
    input   wire    rstn,

    input   wire    bus_we,
    input   wire    bus_wdata,

    output  reg     dev_rdata
);

    reg             bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data <= 1'b0;
        else
            bus_cell_data <= bus_we & bus_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dev_rdata <= 1'b0;
        else
            dev_rdata <= ~bus_cell_data & bus_we & bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_write_en_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROLH          Latch high      Latch high    write            True
// ---------------------------------------------------------------------
module regmap_smic_efuse_efuse_ready_ROLH
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    input            bus_re,
    output           bus_rdata,

    input            dev_wdata
);

    reg   bus_cell_data;
    reg   cell_lock;

    assign  bus_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_lock   <=  1'b0;
        else if (~sw_rstn)
            cell_lock   <=  1'b0;
        else if (~cell_lock)
            cell_lock   <=  dev_wdata;
        else begin
            if(bus_re)
                cell_lock   <=  1'b0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'b0;
        else if (~sw_rstn)
            bus_cell_data   <=  1'b0;
        else if (~cell_lock)
            bus_cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_efuse_addr_RWR
#(parameter ADDR_WIDTH = 6)
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [ADDR_WIDTH-1:0]    bus_wdata,
    output  [ADDR_WIDTH-1:0]    bus_rdata,

    output  [ADDR_WIDTH-1:0]    dev_rdata
);

    reg     [ADDR_WIDTH-1:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  {ADDR_WIDTH{1'b0}};
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_efuse_wdata_RWR_16
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [15:0]   bus_wdata,
    output  [15:0]   bus_rdata,

    output  [15:0]   dev_rdata
);

    reg     [15:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  16'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODEV         read            read          write/we         False
// ---------------------------------------------------------------------
module regmap_smic_efuse_efuse_rdata_RODEV_16
(
    input            clk,
    input            rstn,

    output  [15:0]   bus_rdata,

    input            dev_we,
    input   [15:0]   dev_wdata
);

    reg     [15:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  16'h0;
        else if (dev_we)
            bus_cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_PGM_RWR_11
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [10:0]   bus_wdata,
    output  [10:0]   bus_rdata,

    output  [10:0]   dev_rdata
);

    reg     [10:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  11'hfb;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  11'h1f5;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  11'h3e9;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  11'h12d;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  11'h259;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  11'h4b1;
        `else
            bus_cell_data   <=  11'hfb;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_WR_AEN_RWR_11
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [10:0]   bus_wdata,
    output  [10:0]   bus_rdata,

    output  [10:0]   dev_rdata
);

    reg     [10:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  11'h12a;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  11'h254;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  11'h4a7;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  11'h18c;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  11'h317;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  11'h62d;
        `else
            bus_cell_data   <=  11'h12a;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HP_A_RWR_3
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [2:0]    bus_wdata,
    output  [2:0]    bus_rdata,

    output  [2:0]    dev_rdata
);

    reg     [2:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  3'h2;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  3'h3;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  3'h6;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  3'h2;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  3'h3;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  3'h6;
        `else
            bus_cell_data   <=  3'h2;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_SP_PGM_RWR_4
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [3:0]    bus_wdata,
    output  [3:0]    bus_rdata,

    output  [3:0]    dev_rdata
);

    reg     [3:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `else
            bus_cell_data   <=  4'h3;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HP_PGM_RWR_4
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [3:0]    bus_wdata,
    output  [3:0]    bus_rdata,

    output  [3:0]    dev_rdata
);

    reg     [3:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `else
            bus_cell_data   <=  4'h3;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HP_RD_RWR_4
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [4:0]    bus_wdata,
    output  [4:0]    bus_rdata,

    output  [4:0]    dev_rdata
);

    reg     [4:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  5'h4;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  5'h8;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  5'h10;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  5'h4;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  5'h8;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  5'h10;
        `else
            bus_cell_data   <=  5'h4;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_SP_PG_AVDD_RWR_7
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [6:0]    bus_wdata,
    output  [6:0]    bus_rdata,

    output  [6:0]    dev_rdata
);

    reg     [6:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  7'h1a;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  7'h33;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  7'h65;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  7'h1a;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  7'h33;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  7'h65;
        `else
            bus_cell_data   <=  7'h1a;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HP_PG_AVDD_RWR_7
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [6:0]    bus_wdata,
    output  [6:0]    bus_rdata,

    output  [6:0]    dev_rdata
);

    reg     [6:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  7'h1a;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  7'h33;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  7'h65;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  7'h1a;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  7'h33;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  7'h65;
        `else
            bus_cell_data   <=  7'h1a;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_RD_RWR_6
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [5:0]    bus_wdata,
    output  [5:0]    bus_rdata,

    output  [5:0]    dev_rdata
);

    reg     [5:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  6'h2;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  6'h3;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  6'h5;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  6'hd;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  6'h1a;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  6'h33;
        `else
            bus_cell_data   <=  6'h2;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_RD_AEN_RWR_7
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [6:0]    bus_wdata,
    output  [6:0]    bus_rdata,

    output  [6:0]    dev_rdata
);

    reg     [6:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  7'h2;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  7'h4;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  7'h8;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  7'h1a;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  7'h33;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  7'h65;
        `else
            bus_cell_data   <=  7'h2;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HR_A_RWR_2
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [1:0]    bus_wdata,
    output  [1:0]    bus_rdata,

    output  [1:0]    dev_rdata
);

    reg     [1:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  2'h1;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  2'h1;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  2'h2;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  2'h1;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  2'h1;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  2'h2;
        `else
            bus_cell_data   <=  2'h1;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_SR_RD_RWR_4
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [3:0]    bus_wdata,
    output  [3:0]    bus_rdata,

    output  [3:0]    dev_rdata
);

    reg     [3:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `else
            bus_cell_data   <=  4'h3;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_HR_RD_RWR_4
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [3:0]    bus_wdata,
    output  [3:0]    bus_rdata,

    output  [3:0]    dev_rdata
);

    reg     [3:0]     bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  4'h3;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  4'h6;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  4'hb;
        `else
            bus_cell_data   <=  4'h3;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_T_AVDD_DLY_RWR_12
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [11:0]   bus_wdata,
    output  [11:0]   bus_rdata,

    output  [11:0]   dev_rdata
);

    reg     [11:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
        `ifdef SMIC40_EFUSE_25MHZ
            bus_cell_data   <=  12'h36c;
        `elsif SMIC40_EFUSE_50MHZ
            bus_cell_data   <=  12'h6d7;
        `elsif SMIC40_EFUSE_100MHZ
            bus_cell_data   <=  12'hdad;
        `elsif SMIC28_EFUSE_25MHZ
            bus_cell_data   <=  12'h36c;
        `elsif SMIC28_EFUSE_50MHZ
            bus_cell_data   <=  12'h6d7;
        `elsif SMIC28_EFUSE_100MHZ
            bus_cell_data   <=  12'hdad;
        `else
            bus_cell_data   <=  12'h36c;
        `endif
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_sel_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_pgmen_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_rden_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_aen_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_avdd_en_RWR
(
    input            clk,
    input            rstn,

    input            bus_we,
    input            bus_wdata,
    output           bus_rdata,

    output           dev_rdata
);

    reg               bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  1'h0;
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_a_RWR
#(  parameter EFUSE_DEPTH = 10)
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [EFUSE_DEPTH-1:0]   bus_wdata,
    output  [EFUSE_DEPTH-1:0]   bus_rdata,

    output  [EFUSE_DEPTH-1:0]   dev_rdata
);

    reg     [EFUSE_DEPTH-1:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;
    assign  dev_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  {EFUSE_DEPTH{1'b0}};
        else if (bus_we)
            bus_cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROR           read            read          write            False
// ---------------------------------------------------------------------
module regmap_smic_efuse_smi_efuse_d_ROR_16
(
    input            clk,
    input            rstn,

    output  [15:0]   bus_rdata,

    input   [15:0]   dev_wdata
);

    reg     [15:0]    bus_cell_data;

    assign  bus_rdata = bus_cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            bus_cell_data   <=  16'h0;
        else
            bus_cell_data   <=  dev_wdata;
    end

endmodule
