
interface rgu_driver_bfm (
  input  logic       clk,
  input  logic [7:0] cs,
  output logic       miso,
  input  logic       mosi
);

`include "uvm_macros.svh"
import uvm_pkg::*;
import rgu_agent_pkg::*;

//------------------------------------------
// Data Members
//------------------------------------------

//------------------------------------------
// Methods
//------------------------------------------

task wait_cs_isknown();
  miso = 1;
  while(cs === 8'hxx) begin
    #1;
  end
endtask : wait_cs_isknown

task drive(rgu_seq_item req);
  int no_bits;
  
  while(cs == 8'hff) begin
    @(cs);
  end
  `uvm_info("rgu_DRV_RUN:", $sformatf("Starting transmission: %0h RX_NEG State %b, no of bits %0d", req.rgu_data, req.RX_NEG, req.no_bits), UVM_LOW)
  no_bits = req.no_bits;
  if(no_bits == 0) begin
    no_bits = 128;
  end
  miso <= req.rgu_data[0];
  for(int i = 1; i < no_bits-1; i++) begin
    if(req.RX_NEG == 1) begin
      @(posedge clk);
    end
    else begin
      @(negedge clk);
    end
    miso <= req.rgu_data[i];
    if(cs == 8'hff) begin
      break;
    end
  end
endtask : drive
  
endinterface: rgu_driver_bfm
