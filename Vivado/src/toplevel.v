// system verilog file
// takes in all clocks and measures their frequency. 
// information is available via a vio (for some) and 
// via an i2c interface. On apollo that interface is routed
// to the generic FPGA i2c data path.
//
// wittich 2/2025

// the inputs are kept the same to map them to the
// names that Charlie used in the contraint file.
// they are reassigned to their local purpose in the 
// verilog file.

// the ones that are not used are (mostly) commented out in the module 
// interface. 
`default_nettype none
`define C_GTY_REFCLKS_USED 14
`define C_LOGIC_CLK_USED 7

module top (
    input  wire p_clk_200,
    input  wire n_clk_200,
    input  wire p_lf_x12_r0_clk,
    input  wire n_lf_x12_r0_clk,
    input  wire p_lf_x4_r0_clk,
    input  wire n_lf_x4_r0_clk,
    input  wire p_rt_x12_r0_clk,
    input  wire n_rt_x12_r0_clk,
    input  wire p_rt_x4_r0_clk,
    input  wire n_rt_x4_r0_clk,
    //input  wire fpga_identity,
    output wire led_f1_blue,
    output wire led_f1_green,
    output wire led_f1_red,
    output wire led_f2_blue,
    output wire led_f2_green,
    output wire led_f2_red,
    input  wire mcu_to_f,
    output wire f_to_mcu,
    //output wire c2c_ok,
    inout  wire i2c_scl_f_sysmon,
    inout  wire i2c_sda_f_sysmon,
    inout  wire i2c_scl_f_generic,
    inout  wire i2c_sda_f_generic,
    // input  wire p_tcds_in,
    // input  wire n_tcds_in,
    // output wire p_tcds_out,
    // output wire n_tcds_out,
    // input  wire p_tcds_from_zynq_a,
    // input  wire n_tcds_from_zynq_a,
    // output wire p_tcds_to_zynq_a,
    // output wire n_tcds_to_zynq_a,
    // input  wire p_tcds_cross_recv_a,
    // input  wire n_tcds_cross_recv_a,
    // output wire p_tcds_cross_xmit_a,
    // output wire n_tcds_cross_xmit_a,
    // output wire p_tcds_recov_clk,
    // output wire n_tcds_recov_clk,
    input  wire p_tcds40_clk,
    input  wire n_tcds40_clk,
    input  wire p_lhc_clk,
    input  wire n_lhc_clk,

    input  wire p_rt_r0_l,
    input  wire n_rt_r0_l,
    input  wire p_rt_r1_l,
    input  wire n_rt_r1_l,
    //input  wire p_mgt_sm_to_f_1,
    //input  wire n_mgt_sm_to_f_1,
    // output wire p_mgt_f_to_sm_1,
    // output wire n_mgt_f_to_sm_1,
    // input  wire p_mgt_sm_to_f_2,
    // input  wire n_mgt_sm_to_f_2,
    // // output wire p_mgt_f_to_sm_2,
    // output wire n_mgt_f_to_sm_2,
    // input  wire p_c2c_cross_recv_b,
    // input  wire n_c2c_cross_recv_b,
    // // output wire p_c2c_cross_xmit_b,
    // output wire n_c2c_cross_xmit_b,
    input  wire p_lf_r0_ad,
    input  wire p_lf_r0_ab,
    input  wire n_lf_r0_ab,
    input  wire n_lf_r0_ad,
    input  wire p_lf_r1_ad,
    input  wire n_lf_r1_ad,
    input  wire p_lf_r1_ab,
    input  wire n_lf_r1_ab,
    input  wire p_lf_r0_r,
    input  wire n_lf_r0_r,
    input  wire p_lf_r1_r,
    input  wire n_lf_r1_r,
    input  wire p_lf_r0_u,
    input  wire n_lf_r0_u,
    input  wire p_lf_r1_u,
    input  wire n_lf_r1_u,
    input  wire p_lf_r0_y,
    input  wire n_lf_r0_y,
    input  wire p_lf_r1_y,
    input  wire n_lf_r1_y,
    input  wire p_lf_r0_af,
    input  wire n_lf_r0_af,
    input  wire p_lf_r1_af,
    input  wire n_lf_r1_af,
    input  wire p_lf_r0_w,
    input  wire n_lf_r0_w,
    input  wire p_lf_r1_w,
    input  wire n_lf_r1_w,
    input  wire p_rt_r0_n,
    input  wire n_rt_r0_n,
    input  wire p_rt_r1_n,
    input  wire n_rt_r1_n,
    input  wire p_rt_r0_b,
    input  wire n_rt_r0_b,
    input  wire p_rt_r1_b,
    input  wire n_rt_r1_b,
    input  wire p_rt_r0_e,
    input  wire n_rt_r0_e,
    input  wire p_rt_r1_e,
    input  wire n_rt_r1_e,
    input  wire p_rt_r0_g,
    input  wire n_rt_r0_g,
    input  wire p_rt_r1_g,
    input  wire n_rt_r1_g,
    input  wire p_rt_r0_p,
    input  wire n_rt_r0_p,
    input  wire p_rt_r1_p,
    input  wire n_rt_r1_p,
    input  wire p_rt_r0_i,
    input  wire n_rt_r0_i,
    input  wire p_rt_r1_i,
    input  wire n_rt_r1_i,

    // input  wire p_ff1_recv[11:0],
    // input  wire n_ff1_recv[11:0],
    // output wire p_ff1_xmit[11:0],
    // output wire n_ff1_xmit[11:0],
    // input  wire p_ff2_recv[11:0],
    // input  wire n_ff2_recv[11:0],
    // output wire p_ff2_xmit[11:0],
    // output wire n_ff2_xmit[11:0],
    // input  wire p_ff3_recv[11:0],
    // input  wire n_ff3_recv[11:0],
    // output wire p_ff3_xmit[11:0],
    // output wire n_ff3_xmit[11:0],
    // input  wire p_ff4_recv[11:0],
    // input  wire n_ff4_recv[11:0],
    // output wire p_ff4_xmit[11:0],
    // output wire n_ff4_xmit[11:0],
    // input  wire p_ff5_recv[3:0],
    // input  wire n_ff5_recv[3:0],
    // output wire p_ff5_xmit[3:0],
    // output wire n_ff5_xmit[3:0],
    // input  wire p_ff6_recv[3:0],
    // input  wire n_ff6_recv[3:0],
    // output wire p_ff6_xmit[3:0],
    // output wire n_ff6_xmit[3:0],
    // input  wire p_a_recv[3:0],
    // input  wire n_a_recv[3:0],
    // output wire p_a_xmit[3:0],
    // output wire n_a_xmit[3:0],
    // input  wire p_b_recv[3:0],
    // input  wire n_b_recv[3:0],
    // output wire p_b_xmit[3:0],
    // output wire n_b_xmit[3:0],
    // input  wire p_c_recv[3:0],
    // input  wire n_c_recv[3:0],
    // output wire p_c_xmit[3:0],
    // output wire n_c_xmit[3:0],
    // input  wire p_d_recv[3:0],
    // input  wire n_d_recv[3:0],
    // output wire p_d_xmit[3:0],
    // output wire n_d_xmit[3:0],
    // input  wire p_e_recv[3:0],
    // input  wire n_e_recv[3:0],
    // output wire p_e_xmit[3:0],
    // output wire n_e_xmit[3:0],
    // input  wire p_f_recv[3:0],
    // input  wire n_f_recv[3:0],
    // output wire p_f_xmit[3:0],
    // output wire n_f_xmit[3:0],
    // input  wire p_g_recv[3:0],
    // input  wire n_g_recv[3:0],
    // output wire p_g_xmit[3:0],
    // output wire n_g_xmit[3:0],
    // input  wire p_h_recv[3:0],
    // input  wire n_h_recv[3:0],
    // output wire p_h_xmit[3:0],
    // output wire n_h_xmit[3:0],
    // input  wire p_i_recv[3:0],
    // input  wire n_i_recv[3:0],
    // output wire p_i_xmit[3:0],
    // output wire n_i_xmit[3:0],
    // input  wire p_j_recv[3:0],
    // input  wire n_j_recv[3:0],
    // output wire p_j_xmit[3:0],
    // output wire n_j_xmit[3:0],
    // input  wire p_m_recv[3:0],
    // input  wire n_m_recv[3:0],
    // output wire p_m_xmit[3:0],
    // output wire n_m_xmit[3:0],
    // input  wire p_n_recv[3:0],
    // input  wire n_n_recv[3:0],
    // output wire p_n_xmit[3:0],
    // output wire n_n_xmit[3:0],
    // input  wire p_o_recv[3:0],
    // input  wire n_o_recv[3:0],
    // output wire p_o_xmit[3:0],
    // output wire n_o_xmit[3:0],
    // input  wire p_p_recv[3:0],
    // input  wire n_p_recv[3:0],
    // output wire p_p_xmit[3:0],
    // output wire n_p_xmit[3:0],
       //input  wire p_test_conn_0,
       //input  wire n_test_conn_0,
       //output wire p_test_conn_1,
       //output wire n_test_conn_1,
    // input  wire p_test_conn_2,
    // input  wire n_test_conn_2,
    // input  wire p_test_conn_3,
    // input  wire n_test_conn_3,
    // input  wire p_test_conn_4,
    // input  wire n_test_conn_4,
    // input  wire test_conn_5,
    // output wire test_conn_6//,
    input  wire p_in_spare[2:0],
    input  wire n_in_spare[2:0],
    output wire p_out_spare[2:0],
    output wire n_out_spare[2:0]
    //input  wire hdr1,
    //output  wire hdr2
    // input  wire hdr3,
    // input  wire hdr4,
    // input  wire hdr5,
    // input  wire hdr6,
    // input  wire hdr7,
    // input  wire hdr8,
    // input  wire hdr9,
    // input  wire hdr10

);

        //blinky
    (* keep = "true" *) wire led_out100; // see if (* keep = "true" *) prevents FPGA 2 from losing led_out100
    (* keep = "true" *) wire led_out200;

    wire reset;
    assign reset = mcu_to_f;    

    wire p_clk_200_ext;
    wire n_clk_200_ext;
    assign p_clk_200_ext = p_in_spare[2];
    assign n_clk_200_ext = n_in_spare[2];

    wire clk_200; // system clock @ 200 MHz
    IBUFDS #(
        .DIFF_TERM("TRUE"),
        .IBUF_LOW_PWR("TRUE")
    ) IBUFDS_clk_200 (
        .I(p_clk_200),
        .IB(n_clk_200),
        .O(clk_200)
    );

    wire clk_100, clk_325, clk_7;
    clk_wiz_0 clkwizard(
        .clk_200_in(clk_200),
        .clk_100(clk_100), // Microblaze
        .clk_325(clk_325), // testing/unused
        .clk_7(clk_7), // used for I2C, really more like 6.9 MHz
        .reset(reset)
    );

    // send the 200 MHz clock to the other FPGA via the spare pins
    OBUFDS #(
        .IOSTANDARD("DEFAULT")
    ) OBUFDS_clk_200 (
        .I(clk_200),
        .O(p_out_spare[2]),
        .OB(n_out_spare[2])
    );
    // It appears I need to make the other two entries in spare array differential
    // explicitly for the bitstream generation to work
    OBUFDS #(
        .IOSTANDARD("DEFAULT")
    ) OBUFDS_clk_100 (
        .I(clk_100),
        .O(p_out_spare[1]),
        .OB(n_out_spare[1])
    );
    OBUFDS #(
        .IOSTANDARD("DEFAULT")
    ) OBUFDS_clk_325 (
        .I(clk_325),
        .O(p_out_spare[0]),
        .OB(n_out_spare[0])
    );


    // Differential clock input buffers -- logic clocks

    wire p_logic_clk [`C_LOGIC_CLK_USED-1:0];
    wire n_logic_clk [`C_LOGIC_CLK_USED-1:0];
    wire logic_clk [`C_LOGIC_CLK_USED-1:0];
    assign p_logic_clk = {p_lf_x12_r0_clk, p_lf_x4_r0_clk, p_rt_x12_r0_clk, p_rt_x4_r0_clk, p_tcds40_clk, p_lhc_clk,
                          p_clk_200_ext};
    assign n_logic_clk = {n_lf_x12_r0_clk, n_lf_x4_r0_clk, n_rt_x12_r0_clk, n_rt_x4_r0_clk, n_tcds40_clk, n_lhc_clk,
                          n_clk_200_ext};

    wire [31:0] freq_logic_clk [`C_LOGIC_CLK_USED-1:0];

    genvar gj;
    generate
        for (gj = 0; gj < `C_LOGIC_CLK_USED; gj = gj + 1) 
        begin
            IBUFDS #(
                .DIFF_TERM("TRUE"),
                .IBUF_LOW_PWR("TRUE")
            ) IBUFDS_logic_clk (
                .I(p_logic_clk[gj]),
                .IB(n_logic_clk[gj]),
                .O(logic_clk[gj])
            );

            frequency_counter #(
                .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
            ) freq_counter_logic_clk (
                .ref_clk(clk_200),
                .reset(reset),
                .f(logic_clk[gj]),
                .freq(freq_logic_clk[gj])
            );
        end
    endgenerate


    

    // refclocks -- receive the refclocks and add frequency counters. 

    wire [`C_GTY_REFCLKS_USED-1:0] refclkp [1:0];
    wire [`C_GTY_REFCLKS_USED-1:0] refclkn [1:0];
    wire [`C_GTY_REFCLKS_USED-1:0] refclk [1:0];

    assign refclkp[0] = {p_lf_r0_ab, p_lf_r0_ad, p_lf_r0_af, p_lf_r0_r, p_lf_r0_u, p_lf_r0_w, p_lf_r0_y,
                         p_rt_r0_b, p_rt_r0_e, p_rt_r0_g, p_rt_r0_i, p_rt_r0_l, p_rt_r0_n, p_rt_r0_p};
    assign refclkn[0] = {n_lf_r0_ab, n_lf_r0_ad, n_lf_r0_af, n_lf_r0_r, n_lf_r0_u, n_lf_r0_w, n_lf_r0_y,
                         n_rt_r0_b, n_rt_r0_e, n_rt_r0_g, n_rt_r0_i, n_rt_r0_l, n_rt_r0_n, n_rt_r0_p};

    assign refclkp[1] = {p_lf_r1_ab, p_lf_r1_ad, p_lf_r1_af, p_lf_r1_r, p_lf_r1_u, p_lf_r1_w, p_lf_r1_y,
                         p_rt_r1_b, p_rt_r1_e, p_rt_r1_g, p_rt_r1_i, p_rt_r1_l, p_rt_r1_n, p_rt_r1_p};
    assign refclkn[1] = {n_lf_r1_ab, n_lf_r1_ad, n_lf_r1_af, n_lf_r1_r, n_lf_r1_u, n_lf_r1_w, n_lf_r1_y,
                         n_rt_r1_b, n_rt_r1_e, n_rt_r1_g, n_rt_r1_i, n_rt_r1_l, n_rt_r1_n, n_rt_r1_p};

    wire  [`C_GTY_REFCLKS_USED-1:0] clk_odiv2 [1:0];
    wire  [`C_GTY_REFCLKS_USED-1:0] clk_odiv2_b [1:0];

    wire [31:0] freqs0 [`C_GTY_REFCLKS_USED-1:0];
    wire [31:0] freqs1 [`C_GTY_REFCLKS_USED-1:0];


    genvar gi;
    generate
    for (gi = 0; gi < `C_GTY_REFCLKS_USED; gi = gi + 1)
        begin
            IBUFDS_GTE4 u_buf_q1_clk0
            (
                .O            (refclk      [0][gi]),
                .ODIV2        (clk_odiv2_b [0][gi]),
                .CEB          (1'b0),
                .I            (refclkp [0][gi]),
                .IB           (refclkn [0][gi])
            );
        
            IBUFDS_GTE4 u_buf_q1_clk1
            (
                .O            (refclk      [1][gi]),
                .ODIV2        (clk_odiv2_b [1][gi]),
                .CEB          (1'b0),
                .I            (refclkp [1][gi]),
                .IB           (refclkn [1][gi])
            );
            BUFG_GT odiv2_buf0
            (
                .I        (clk_odiv2_b [0][gi]),
                .O        (clk_odiv2   [0][gi]),
                .CE       (1'b1),
                .CEMASK   (1'b0),
                .CLR      (1'b0),
                .CLRMASK  (1'b0),
                .DIV      (3'b000)
            );
            BUFG_GT odiv2_buf1
            (
                .I        (clk_odiv2_b [1][gi]),
                .O        (clk_odiv2   [1][gi]),
                .CE       (1'b1),
                .CEMASK   (1'b0),
                .CLR      (1'b0),
                .CLRMASK  (1'b0),
                .DIV      (3'b000)
            );

            frequency_counter #(
                .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
            ) freq_counter_refclk0 (
                .ref_clk(clk_200),
                .reset(reset),
                .f(clk_odiv2[0][gi]),
                .freq(freqs0[gi])
            );

            frequency_counter #(
                .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
            ) freq_counter_refclk1 (
                .ref_clk(clk_200),
                .reset(reset),
                .f(clk_odiv2[1][gi]),
                .freq(freqs1[gi])
            );
        end
    endgenerate

    // Frequency counters for clocks used internally. 
    // really only clk_7 is needed for I2C module
    // clk_100
    wire [31:0] freq_clk_100;
    frequency_counter #(
        .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
    ) freq_counter_clk_100 (
        .ref_clk(clk_200),
        .reset(reset),
        .f(clk_100),
        .freq(freq_clk_100)
    );
    
    // clk_325
    wire [31:0] freq_clk_325;
    frequency_counter #(
        .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
    ) freq_counter_clk_325 (
        .ref_clk(clk_200),
        .reset(reset),
        .f(clk_325),
        .freq(freq_clk_325)
    );



    // concatenate the frequency buses into a single array to pass
    // to the register map module.
    // 'status' array since it is modeled after status registers.
    // Define the status array
    wire [31:0] status_array [0:2*`C_GTY_REFCLKS_USED+`C_LOGIC_CLK_USED+2-1];

    // Assign the values to the status array using a generate block
    genvar i;
    generate
        for (i = 0; i < `C_LOGIC_CLK_USED; i = i + 1) begin
            assign status_array[i] = freq_logic_clk[i];
        end
        assign status_array[`C_LOGIC_CLK_USED] = freq_clk_100;
        assign status_array[`C_LOGIC_CLK_USED+1] = freq_clk_325;
        for (i = 0; i < `C_GTY_REFCLKS_USED; i = i + 1) begin
            assign status_array[`C_LOGIC_CLK_USED+2+i] = freqs0[i];
            assign status_array[`C_LOGIC_CLK_USED+2+`C_GTY_REFCLKS_USED+i] = freqs1[i];
        end
    endgenerate




    wire [31:0] freq;
    wire [7:0] address;

    reg_map #(
        .NUM_RW(2),
        .NUM_RO(2*`C_GTY_REFCLKS_USED+`C_LOGIC_CLK_USED+2)
    ) rmap (
        .clk(clk_200),
        .rst(reset),
        .addr(address[7:2]),
        .wdata(longword),
        .write_en(i2c_dout_dv_delayed),
        .rdata(freq),
        .status(status_array)
    );

    // One-to-four demux that puts an input byte into the right position in a longword
    reg [31:0] longword;
    reg [7:0] i2c_byte;
    reg i2c_dout_dv_delayed;
    wire i2c_dout_dv;

    always @(posedge clk_200 or posedge reset) begin
        if (reset) begin
            longword <= 32'b0; // Initialize longword to zero on reset
        end else if (i2c_dout_dv) begin
            case (address[1:0])
                2'b00: longword[7:0] <= i2c_byte;
                2'b01: longword[15:8] <= i2c_byte;
                2'b10: longword[23:16] <= i2c_byte;
                2'b11: longword[31:24] <= i2c_byte;
                default: longword <= 32'b0;
            endcase
        end
    end
    // Delayed version of i2c_dout_dv
    always @(posedge clk_200 or posedge reset) begin
        if (reset) begin
            i2c_dout_dv_delayed <= 1'b0;
        end else begin
            i2c_dout_dv_delayed <= i2c_dout_dv;
        end
    end



    wire i2c_scl_f_generic_o, i2c_scl_f_generic_i, i2c_scl_f_generic_t;
    IOBUF IOBUF_i2c_scl_f_generic (
        .O(i2c_scl_f_generic_i),
        .I(1'b0),
        .T(1'b1),
        .IO(i2c_scl_f_generic)
    );
    wire i2c_sda_f_generic_o, i2c_sda_f_generic_i, i2c_sda_f_generic_t;
    IOBUF IOBUF_i2c_sda_f_generic (
        .O(i2c_sda_f_generic_i),
        .I(i2c_sda_f_generic_o),
        .T(~i2c_sda_f_generic_t),
        .IO(i2c_sda_f_generic)
    );
    // instantiate i2c slave
    wire [6:0] i2c_address ;
    wire [7:0] i2c_dout;

    
    assign i2c_address = 7'h2b;
    i2c_slave  #(
        .REGISTER_COUNT_BIT_SIZE(8)
    ) i2c_slave_f_generic (
        .reset(reset),
        .clk(clk_7),
        .sda_in(i2c_sda_f_generic_i),
        .sda_out(i2c_sda_f_generic_o),
        .sda_en(i2c_sda_f_generic_t),
        .scl(i2c_scl_f_generic_i),
        .address(i2c_address),
        .data_out(i2c_dout),
        .data_out_dv(i2c_dout_dv),
        .data_in(freq_byte),
        .register_address(address)
    );

    always @(posedge clk_200 or posedge reset) begin
        if (reset) begin
            i2c_byte <= 8'b0;
        end else if (i2c_dout_dv) begin
            i2c_byte <= i2c_dout;
        end
    end

    // mux to select byte within freq bus
    reg [7:0] freq_byte;
    always @* begin
        case (address[1:0])
            2'b00: freq_byte = freq[7:0];
            2'b01: freq_byte = freq[15:8];
            2'b10: freq_byte = freq[23:16];
            2'b11: freq_byte = freq[31:24];
            default: freq_byte = 8'b0; // not needed -- all cases specified
        endcase
    end

    // blinky module
    blinky #(
        .CLOCK_FREQ(100_000_000) // Set clock frequency to 100 MHz
    ) blinky100 (
        .i_clock(clk_100),
        .i_enable(1'b1),
        .o_led_drive(led_out100)
    );

    blinky #(
        .CLOCK_FREQ(200_000_000) // Set clock frequency to 200 MHz
    ) blinky200 (
        .i_clock(clk_200),
        .i_enable(1'b1),
        .o_led_drive(led_out200)
    );
    
    // instantiate VIO block
    vio_freq (
        .clk(clk_200),
        .probe_in0(freq_logic_clk[0]),
        .probe_in1(freq_logic_clk[1]),
        .probe_in2(freq_logic_clk[2]),
        .probe_in3(freq_logic_clk[3]),
        .probe_in4(freq_logic_clk[4]),
        .probe_in5(freq_logic_clk[5]),
        .probe_in6(freq_clk_100),
        .probe_in7(freq_clk_325),
        .probe_out0()
    );

    // SYSMON4E block 
    wire i2c_scl_f_sysmon_o, i2c_scl_f_sysmon_i, i2c_scl_f_sysmon_t;
    IOBUF I2C_SCLK_inst (
        .O(i2c_scl_f_sysmon_i), // Buffer output
        .IO(i2c_scl_f_sysmon), // Buffer inout port (connect directly to top-level port)
        .I(1'b0), // Buffer input
        .T(i2c_scl_f_sysmon_t) // 3-state enable input, high=input, low=output
    );
    wire i2c_sda_f_sysmon_o, i2c_sda_f_sysmon_i, i2c_sda_f_sysmon_t;
    IOBUF I2C_SDA_inst (
        .O(i2c_sda_f_sysmon_i), // Buffer output
        .IO(i2c_sda_f_sysmon), // Buffer inout port (connect directly to top-level port)
        .I(1'b0), // Buffer input
        .T(i2c_sda_f_sysmon_t) // 3-state enable input, high=input, low=output
    );


   // SYSMONE4: AMD Analog-to-Digital Converter and System Monitor
   //           Virtex UltraScale+
   // Xilinx HDL Language Template, version 2023.2

   SYSMONE4 #(
      // INIT_40 - INIT_44: SYSMON configuration registers
      .INIT_40(16'h0000),
      .INIT_41(16'h0000),
      .INIT_42(16'h0000),
      .INIT_43(16'h4680), // enable I2C, really only bit 7 matters
      .INIT_44(16'h0000),
      .INIT_45(16'h0000),              // Analog Bus Register.
      // INIT_46 - INIT_4F: Sequence Registers
      .INIT_46(16'h0000),
      .INIT_47(16'h0000),
      .INIT_48(16'h0000),
      .INIT_49(16'h0000),
      .INIT_4A(16'h0000),
      .INIT_4B(16'h0000),
      .INIT_4C(16'h0000),
      .INIT_4D(16'h0000),
      .INIT_4E(16'h0000),
      .INIT_4F(16'h0000),
      // INIT_50 - INIT_5F: Alarm Limit Registers
      .INIT_50(16'h0000),
      .INIT_51(16'h0000),
      .INIT_52(16'h0000),
      .INIT_53(16'h0000),
      .INIT_54(16'h0000),
      .INIT_55(16'h0000),
      .INIT_56(16'h0000),
      .INIT_57(16'h0000),
      .INIT_58(16'h0000),
      .INIT_59(16'h0000),
      .INIT_5A(16'h0000),
      .INIT_5B(16'h0000),
      .INIT_5C(16'h0000),
      .INIT_5D(16'h0000),
      .INIT_5E(16'h0000),
      .INIT_5F(16'h0000),
      // INIT_60 - INIT_6F: User Supply Alarms
      .INIT_60(16'h0000),
      .INIT_61(16'h0000),
      .INIT_62(16'h0000),
      .INIT_63(16'h0000),
      .INIT_64(16'h0000),
      .INIT_65(16'h0000),
      .INIT_66(16'h0000),
      .INIT_67(16'h0000),
      .INIT_68(16'h0000),
      .INIT_69(16'h0000),
      .INIT_6A(16'h0000),
      .INIT_6B(16'h0000),
      .INIT_6C(16'h0000),
      .INIT_6D(16'h0000),
      .INIT_6E(16'h0000),
      .INIT_6F(16'h0000),
      // Primitive attributes: Primitive Attributes
      .COMMON_N_SOURCE(16'hffff),      // Sets the auxiliary analog input that is used for the Common-N input.
      // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion on
      // specific pins
      .IS_CONVSTCLK_INVERTED(1'b0),    // Optional inversion for CONVSTCLK, 0-1
      .IS_DCLK_INVERTED(1'b0),         // Optional inversion for DCLK, 0-1
      // Simulation attributes: Set for proper simulation behavior
      .SIM_DEVICE("ULTRASCALE_PLUS"),  // Sets the correct target device for simulation functionality.
      .SIM_MONITOR_FILE("design.txt"), // Analog simulation data file name
      // User Voltage Monitor: SYSMON User voltage monitor
      .SYSMON_VUSER0_BANK(0),          // Specify IO Bank for User0
      .SYSMON_VUSER0_MONITOR("NONE"),  // Specify Voltage for User0
      .SYSMON_VUSER1_BANK(0),          // Specify IO Bank for User1
      .SYSMON_VUSER1_MONITOR("NONE"),  // Specify Voltage for User1
      .SYSMON_VUSER2_BANK(0),          // Specify IO Bank for User2
      .SYSMON_VUSER2_MONITOR("NONE"),  // Specify Voltage for User2
      .SYSMON_VUSER3_MONITOR("NONE")   // Specify Voltage for User3
   )
   SYSMONE4_inst (
      // ALARMS outputs: ALM, OT
      .ALM(),                   // 16-bit output: Output alarm for temp, Vccint, Vccaux and Vccbram
      .OT(),                     // 1-bit output: Over-Temperature alarm
      // Direct Data Out outputs: ADC_DATA
      .ADC_DATA(),         // 16-bit output: Direct Data Out
      // Dynamic Reconfiguration Port (DRP) outputs: Dynamic Reconfiguration Ports
      .DO(),                     // 16-bit output: DRP output data bus
      .DRDY(),                 // 1-bit output: DRP data ready
      // I2C Interface outputs: Ports used with the I2C DRP interface
      .I2C_SCLK_TS(i2c_scl_f_sysmon_t),   // 1-bit output: I2C_SCLK output port
      .I2C_SDA_TS(i2c_sda_f_sysmon_t),     // 1-bit output: I2C_SDA_TS output port
      .SMBALERT_TS(),   // 1-bit output: Output control signal for SMBALERT.
      // STATUS outputs: SYSMON status ports
      .BUSY(),                 // 1-bit output: System Monitor busy output
      .CHANNEL(),           // 6-bit output: Channel selection outputs
      .EOC(),                   // 1-bit output: End of Conversion
      .EOS(),                   // 1-bit output: End of Sequence
      .JTAGBUSY(),         // 1-bit output: JTAG DRP transaction in progress output
      .JTAGLOCKED(),     // 1-bit output: JTAG requested DRP port lock
      .JTAGMODIFIED(), // 1-bit output: JTAG Write to the DRP has occurred
      .MUXADDR(),           // 5-bit output: External MUX channel decode
      // Auxiliary Analog-Input Pairs inputs: VAUXP[15:0], VAUXN[15:0]
      .VAUXN(),               // 16-bit input: N-side auxiliary analog input
      .VAUXP(),               // 16-bit input: P-side auxiliary analog input
      // CONTROL and CLOCK inputs: Reset, conversion start and clock inputs
      .CONVST(),             // 1-bit input: Convert start input
      .CONVSTCLK(),       // 1-bit input: Convert start input
      .RESET(reset),               // 1-bit input: Active-High reset
      // Dedicated Analog Input Pair inputs: VP/VN
      .VN(),                     // 1-bit input: N-side analog input
      .VP(),                     // 1-bit input: P-side analog input
      // Dynamic Reconfiguration Port (DRP) inputs: Dynamic Reconfiguration Ports
      .DADDR(),               // 8-bit input: DRP address bus
      .DCLK(),                 // 1-bit input: DRP clock
      .DEN(),                   // 1-bit input: DRP enable signal
      .DI(),                     // 16-bit input: DRP input data bus
      .DWE(),                   // 1-bit input: DRP write enable
      // I2C Interface inputs: Ports used with the I2C DRP interface
      .I2C_SCLK(i2c_scl_f_sysmon_i), // 1-bit input: I2C_SCLK input port
      .I2C_SDA(i2c_sda_f_sysmon_i)   // 1-bit input: I2C_SDA input port
   );

   // End of SYSMONE4_inst instantiation
                    
    // counter
    //reg [31:0] counter;

    //always @(posedge clk_200 or posedge reset) begin
    //    if (reset) begin
    //        counter <= 32'b0;
    //    end else begin
    //        counter <= counter + 1;
    //    end
    //end

    // Assign a significant bit of the counter to led_f*_red
    //assign led_f1_red = counter[29];
    //assign led_f1_blue = counter[28];
    //assign led_f1_green = reset;

    //assign led_f2_red = counter[29];
    //assign led_f2_blue = counter[28];
    //assign led_f2_green = reset;

    assign led_f1_red = led_out200;
    assign led_f1_green = led_out100;
    assign led_f1_blue = 1'b1;
    assign led_f2_red = led_out100;
    assign led_f2_green = led_out200;
    assign led_f2_blue = 1'b1;



endmodule
