
class rgu_driver extends uvm_driver #(rgu_seq_item, rgu_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(rgu_driver)

// Virtual Interface
local virtual rgu_driver_bfm m_bfm;

//------------------------------------------
// Data Members
//------------------------------------------
rgu_agent_config m_cfg;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "rgu_driver", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass: rgu_driver

function rgu_driver::new(string name = "rgu_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void rgu_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `get_config(rgu_agent_config, m_cfg, "rgu_agent_config")
  m_bfm = m_cfg.drv_bfm;
endfunction : build_phase
  
// This driver is really an rgu slave responder
task rgu_driver::run_phase(uvm_phase phase);
  rgu_seq_item req;
  rgu_seq_item rsp;

  m_bfm.wait_cs_isknown();

  forever begin
    seq_item_port.get_next_item(req);
    m_bfm.drive(req);
    seq_item_port.item_done();
  end
endtask: run_phase
