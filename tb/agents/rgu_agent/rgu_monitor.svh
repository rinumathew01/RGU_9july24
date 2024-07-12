
class rgu_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(rgu_monitor);

// Virtual Interface
// local virtual rgu_monitor_bfm m_bfm;

//------------------------------------------
// Data Members
//------------------------------------------
rgu_agent_config m_cfg;

//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(rgu_seq_item) ap;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "rgu_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

// Proxy Methods:
  
extern function void notify_transaction(rgu_seq_item item);

endclass: rgu_monitor

function rgu_monitor::new(string name = "rgu_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void rgu_monitor::build_phase(uvm_phase phase);
  // `get_config(rgu_agent_config, m_cfg, "rgu_agent_config")
  // m_bfm = m_cfg.mon_bfm;
  // m_bfm.proxy = this;
  
  ap = new("ap", this);
endfunction: build_phase

task rgu_monitor::run_phase(uvm_phase phase);
  // m_bfm.run();
endtask: run_phase

function void rgu_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase

function void rgu_monitor::notify_transaction(rgu_seq_item item);
  ap.write(item);
endfunction : notify_transaction
