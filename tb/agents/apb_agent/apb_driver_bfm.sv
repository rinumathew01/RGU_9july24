interface apb_driver_bfm (
  input         PCLK,
  input         PRESETn,

  output logic [31:0] PADDR,
  input  logic [31:0] PRDATA,
  output logic [31:0] PWDATA,
  output logic [15:0] PSEL, // Only connect the ones that are needed
  output logic        PENABLE,
  output logic        PWRITE,
  input  logic        PREADY
);

`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_agent_pkg::*;

//------------------------------------------
// Data Members
//------------------------------------------
apb_agent_config m_cfg;
//------------------------------------------
// Methods
//------------------------------------------

function void clear_sigs();
  PSEL <= 0;
  PENABLE <= 0;
  PADDR <= 0;
endfunction : clear_sigs
  
task drive (apb_seq_item req);
  int psel_index;
  
  `uvm_info("apb_driver_bfm","Driver started doing something",UVM_MEDIUM);
  repeat(req.delay)
    @(posedge PCLK);
  psel_index = sel_lookup(req.addr);
  `uvm_info("apb_driver_bfm",$sformatf("psel index is %0d",psel_index),UVM_MEDIUM);
  if(psel_index >= 0) begin
    PSEL[psel_index] <= 1;
    PADDR <= req.addr;
    PWDATA <= req.data;
    PWRITE <= req.we;
    @(posedge PCLK);
    PENABLE <= 1;
    @(posedge PCLK);
    while (!PREADY)
      @(posedge PCLK);
    if(PWRITE == 0)
      begin
        req.data = PRDATA;
      end
  end
  else begin
    `uvm_error("RUN", $sformatf("Access to addr %0h out of APB address range", req.addr))
    req.error = 1;
  end

  `uvm_info("apb_driver_bfm","Driver ended doing something",UVM_MEDIUM);
endtask : drive

// Looks up the address and returns PSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int sel_lookup(logic[31:0] address);
  // `uvm_info("apb_driver_bfm",$sformatf("address=%0d, "),UVM_DEBUG);
  for(int i = 0; i < m_cfg.no_select_lines; i++) begin
    if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
      return i;
    end
  end
  return -1; // Error: Address not found
endfunction: sel_lookup
  
endinterface: apb_driver_bfm

