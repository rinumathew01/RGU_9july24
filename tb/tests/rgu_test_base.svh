class rgu_test_base extends uvm_test;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(rgu_test_base)
  extern function new(string name = "rgu_test_base", uvm_component parent = null);

  // The environment class
  rgu_env m_env;
  // Configuration objects
  rgu_env_config m_env_cfg;
  apb_agent_config m_apb_cfg;
  rgu_agent_config m_rgu_cfg;
  
  // Register map
  rgu_reg_block rgu_rb;

  //------------------------------------------
  // Methods
  //------------------------------------------
  extern virtual function void configure_apb_agent(apb_agent_config cfg);
  // Standard UVM Methods:
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void set_seqs(rgu_vseq_base seq);

endclass: rgu_test_base

function rgu_test_base::new(string name = "rgu_test_base", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void rgu_test_base::build_phase(uvm_phase phase);

  // env configuration
  m_env_cfg = rgu_env_config::type_id::create("m_env_cfg");
  // Register model
  // Enable all types of coverage available in the register model
  uvm_reg::include_coverage("*", UVM_CVR_ALL);
  // Create the register model:
  rgu_rb = rgu_reg_block::type_id::create("rgu_rb");
  // Build and configure the register model
  rgu_rb.build();
  // Assign a handle to the register model in the env config
  m_env_cfg.rgu_rb = rgu_rb;
  // APB configuration
  m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg");
  configure_apb_agent(m_apb_cfg);
  if (!uvm_config_db #(virtual apb_monitor_bfm)::get(this, "", "APB_mon_bfm", m_apb_cfg.mon_bfm))
    `uvm_fatal("VIF CONFIG", "Cannot get() BFM interface APB_mon_bfm from uvm_config_db. Have you set() it?")
  if (!uvm_config_db #(virtual apb_driver_bfm) ::get(this, "", "APB_drv_bfm", m_apb_cfg.drv_bfm))
    `uvm_fatal("VIF CONFIG", "Cannot get() BFM interface APB_drv_bfm from uvm_config_db. Have you set() it?")
  m_env_cfg.m_apb_agent_cfg = m_apb_cfg;
  // The rgu is not configured as such
  m_rgu_cfg = rgu_agent_config::type_id::create("m_rgu_cfg");
  // if (!uvm_config_db #(virtual rgu_monitor_bfm)::get(this, "", "rgu_mon_bfm", m_rgu_cfg.mon_bfm))
  //   `uvm_fatal("VIF CONFIG", "Cannot get() BFM interface rgu_mon_bfm from uvm_config_db. Have you set() it?")
  // if (!uvm_config_db #(virtual rgu_driver_bfm) ::get(this, "", "rgu_drv_bfm", m_rgu_cfg.drv_bfm))
  //   `uvm_fatal("VIF CONFIG", "Cannot get() BFM interface rgu_drv_bfm from uvm_config_db. Have you set() it?")
  m_rgu_cfg.has_functional_coverage = 0;
  m_env_cfg.m_rgu_agent_cfg = m_rgu_cfg;
  
  uvm_config_db #(rgu_env_config)::set(this, "*", "rgu_env_config", m_env_cfg);
  m_env = rgu_env::type_id::create("m_env", this);
endfunction: build_phase

//
// Convenience function to configure the apb agent
//
// This can be overloaded by extensions to this test base class
function void rgu_test_base::configure_apb_agent(apb_agent_config cfg);
  cfg.active = UVM_ACTIVE;
  cfg.has_functional_coverage = 0;
  cfg.has_scoreboard = 0;
  // rgu is on select line 0 for address range 0-18h
  cfg.no_select_lines = 1;
  cfg.start_address[0] = 32'h0;
  cfg.range[0] = 32'h70;
endfunction: configure_apb_agent

function void rgu_test_base::set_seqs(rgu_vseq_base seq);
  seq.m_cfg = m_env_cfg;

  // seq.apb = m_env.m_apb_agent.m_sequencer;
  seq.rgu = m_env.m_rgu_agent.m_sequencer;
endfunction

task rgu_test_base::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"Hey boss",UVM_MEDIUM);
  uvm_top.print_topology();
  rgu_rb.print();
endtask
