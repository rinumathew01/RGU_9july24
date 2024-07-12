
class rgu_scoreboard extends uvm_component;

  `uvm_component_utils(rgu_scoreboard)

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  uvm_tlm_analysis_fifo #(rgu_seq_item) rgu_ap; // Both mosi & miso come in together
  rgu_reg_block rgu_rb;

  function void build_phase(uvm_phase phase);
    rgu_ap = new("rgu_ap", this);
  endfunction: build_phase
  
/*


  // Register Model Handle - assigned by the env code from the contents
  // of its configuration object

  // Data buffers:
  logic[31:0] mosi[3:0];
  logic[31:0] miso[3:0];
  logic[127:0] mosi_regs = 0;
  // Bit count:
  logic[7:0] bit_cnt;
  //
  // Statistics:
  //
  int no_transfers;
  int no_tx_errors;
  int no_rx_errors;
  int no_cs_errors;



  // What this scoreboard does:
  //
  // It relies on the fact that the register model is kept updated by the
  // predictor in the test bench and that there are no accesses to the
  // rxtx registers during the rgu data transfer
  //
  //
  // When it receives a rgu transaction it compares the current version of
  // the rxtx register models - i.e. the tx data - against the rgu MOSI data observed
  // It then processes the rx data, according to the configured format, and reads the
  // rgu DUT rx data register to make sure it matches before
  // updating the rxtx register models with the expected values for the
  // rgu MISO data. An sequence is expected to read back from these registers using
  // the mirror() method in order to detect any data errors.
  //

  task run_phase(uvm_phase phase);
    no_transfers = 0;
    no_tx_errors = 0;
    no_rx_errors = 0;
    no_cs_errors = 0;

    track_rgu;

  endtask: run_phase

  task track_rgu;
    rgu_seq_item item;

    logic[127:0] tx_data;
    logic[127:0] mosi_data;
    logic[127:0] miso_data;
    logic[127:0] rev_miso;
    logic[127:0] bit_mask;
    logic[31:0] rx_data;
    uvm_reg_data_t rgu_read_data;
    uvm_status_e status;

    bit error;

    forever begin
      error = 0;
      rgu.get(item);
      no_transfers++;
      bit_cnt = rgu_rb.ctrl.char_len.get_mirrored_value();
      // Corner case for bit count equal to zero:
      if(bit_cnt == 8'b0) begin
        bit_cnt = 128;
      end
      // Deal with the mosi data (TX)
      tx_data[31:0] = rgu_rb.rxtx0.get_mirrored_value();
      tx_data[63:32] = rgu_rb.rxtx1.get_mirrored_value();
      tx_data[95:64] = rgu_rb.rxtx2.get_mirrored_value();
      tx_data[127:96] = rgu_rb.rxtx3.get_mirrored_value();

      // Fix the data comparison mask for the number of bits
      bit_mask = 0;
      for(int i = 0; i < bit_cnt; i++) begin
        bit_mask[i] = 1;
      end

      if(rgu_rb.ctrl.tx_neg.get_mirrored_value() == 1) begin
        mosi_data = item.nedge_mosi; // To be compared against write data
      end
      else begin
        mosi_data = item.pedge_mosi;
      end
      if(rgu_rb.ctrl.lsb.get() == 1) begin
        for(int i = 0; i < bit_cnt; i++) begin
          if(tx_data[i] != mosi_data[i]) begin
            error = 1;
          end
        end
        if(error == 1) begin
          `uvm_error("rgu_SB_MOSI_LSB:", $sformatf("Expected mosi value %0h actual %0h", tx_data, mosi_data))
        end
      end
      else begin
        for(int i = 0; i < bit_cnt; i++) begin
          if(tx_data[i] != mosi_data[(bit_cnt-1) - i]) begin
            error = 1;
          end
        end
        if(error == 1) begin // Need to reverse the mosi_data bits
          rev_miso = 0;
          for(int i = 0; i < bit_cnt; i++) begin
            rev_miso[(bit_cnt-1) - i] = mosi_data[i];
          end
          `uvm_error("rgu_SB_MOSI_MSB:", $sformatf("Expected mosi value %0h actual %0h", tx_data, rev_miso))
        end
      end
      if(error == 1) begin
        no_tx_errors++;
      end

      // Reset the error bit
      error = 0;
      // Check the miso data (RX)
      if(rgu_rb.ctrl.rx_neg.get_mirrored_value() == 1) begin
        miso_data = item.pedge_miso;
      end
      else begin
        miso_data = item.nedge_miso;
      end
      if(rgu_rb.ctrl.lsb.get_mirrored_value() == 0) begin
        // reverse the bits lsb -> msb, and so on
        rev_miso = 0;
        for(int i = 0; i < bit_cnt; i++) begin
          rev_miso[(bit_cnt-1) - i] = miso_data[i];
        end
        miso_data = rev_miso;
      end

      // The following sets up the rx data so that it is
      // bit masked according to the no of bits
      rx_data = rgu_rb.rxtx0.get_mirrored_value();
      // Read the received data
      rgu_rb.rxtx0.read(status, rgu_read_data);
      for(int i = 0; ((i < 32) && (i < bit_cnt)); i++) begin
        rx_data[i] = miso_data[i];
        if(rgu_read_data[i] != miso_data[i]) begin
          error = 1;
          `uvm_error("rgu_SB_RXD:", $sformatf("Bit%0d Expected RX data value %0h actual %0h", i, rgu_read_data[31:0], miso_data))
        end
      end
      // Get the register model to check that the data it next reads back from this
      // register is as predicted
      // This is somewhat redundant given the earlier read check, but it does check the
      // read back path
      assert(rgu_rb.rxtx0.predict(rx_data));

      rx_data = rgu_rb.rxtx1.get_mirrored_value();
      rgu_rb.rxtx1.read(status, rgu_read_data);
      for(int i = 32; ((i < 64) && (i < bit_cnt)); i++) begin
        rx_data[i-32] = miso_data[i];
        if(rgu_read_data[i-32] != miso_data[i]) begin
          error = 1;
          `uvm_error("rgu_SB_RXD:", $sformatf("Bit%0d Expected RX data value %0h actual %0h", i, rgu_read_data[31:0], miso_data))
        end
      end
      assert(rgu_rb.rxtx1.predict(rx_data));

      rx_data = rgu_rb.rxtx2.get_mirrored_value();
      rgu_rb.rxtx2.read(status, rgu_read_data);
      for(int i = 64; ((i < 96) && (i < bit_cnt)); i++) begin
        rx_data[i-64] = miso_data[i];
        if(rgu_read_data[i-64] != miso_data[i]) begin
          error = 1;
          `uvm_error("rgu_SB_RXD:", $sformatf("Bit%0d Expected RX data value %0h actual %0h", i, rgu_read_data[31:0], miso_data))
        end
      end

      assert(rgu_rb.rxtx2.predict(rx_data));

      rx_data = rgu_rb.rxtx3.get_mirrored_value();
      rgu_rb.rxtx3.read(status, rgu_read_data);
      for(int i = 96; ((i < 128) && (i < bit_cnt)); i++) begin
        rx_data[i-96] = miso_data[i];
        if(rgu_read_data[i-96] != miso_data[i]) begin
          error = 1;
          `uvm_error("rgu_SB_RXD:", $sformatf("Bit %0d Expected RX data value %0h actual %0h", i, rgu_read_data[31:0], miso_data))
        end
      end
      assert(rgu_rb.rxtx3.predict(rx_data));

      if(error == 1) begin
        no_rx_errors++;
      end

      // Check the chip select lines
      //rgu_rb.ss.cs.read(status, rgu_read_data);
      //if(rgu_rb.ss.cs.get_mirrored_value() != {56'h0, ~item.cs}) begin
      //  `uvm_error("rgu_SB_CS:", $sformatf("Expected cs value %b actual %b", rgu_rb.ss.cs.get_mirrored_value(), ~item.cs))
      //  no_cs_errors++;
      //end
    end

  endtask: track_rgu

  function void report_phase(uvm_phase phase);

    if(no_transfers == 0) begin
      `uvm_info("rgu_SB_REPORT:", "No rgu transfers took place", UVM_LOW)
    end
    if((no_cs_errors == 0) && (no_tx_errors == 0) && (no_rx_errors == 0) && (no_transfers > 0)) begin
      `uvm_info("rgu_SB_REPORT:", $sformatf("Test Passed - %0d transfers occured with no errors", no_transfers), UVM_LOW)
      `uvm_info("** UVM TEST PASSED **", $sformatf("Test Passed - %0d transfers occured with no errors", no_transfers), UVM_LOW)
    end
    if(no_tx_errors > 0) begin
      `uvm_error("rgu_SB_REPORT:", $sformatf("Test Failed - %0d TX errors occured during %0d transfers", no_tx_errors, no_transfers))
    end
    if(no_rx_errors > 0) begin
      `uvm_error("rgu_SB_REPORT:", $sformatf("Test Failed - %0d RX errors occured during %0d transfers", no_rx_errors, no_transfers))
    end
    if(no_cs_errors > 0) begin
      `uvm_error("rgu_SB_REPORT:", $sformatf("Test Failed - %0d CS errors occured during %0d transfers", no_cs_errors, no_transfers))
    end

  endfunction: report_phase
*/
endclass: rgu_scoreboard
