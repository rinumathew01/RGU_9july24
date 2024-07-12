
class rgu_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(rgu_agent)

//------------------------------------------
// Data Members
//------------------------------------------
rgu_agent_config m_cfg;
  
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(rgu_seq_item) ap;
rgu_monitor   m_monitor;
rgu_sequencer m_sequencer;
rgu_driver    m_driver;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "rgu_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: rgu_agent


function rgu_agent::new(string name = "rgu_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void rgu_agent::build_phase(uvm_phase phase);
  `get_config(rgu_agent_config, m_cfg, "rgu_agent_config")
  // Monitor is always present
  m_monitor = rgu_monitor::type_id::create("m_monitor", this);
  m_monitor.m_cfg = m_cfg;
  // Only build the driver and sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver = rgu_driver::type_id::create("m_driver", this);
    m_driver.m_cfg = m_cfg;
    m_sequencer = rgu_sequencer::type_id::create("m_sequencer", this);
  end
endfunction: build_phase

function void rgu_agent::connect_phase(uvm_phase phase);
  ap = m_monitor.ap;
  // Only connect the driver and the sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction: connect_phase
