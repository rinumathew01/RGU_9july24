
class rgu_env extends uvm_env;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(rgu_env)
  //------------------------------------------
  // Data Members
  //------------------------------------------
  apb_agent m_apb_agent;
  rgu_agent m_rgu_agent;
  rgu_env_config m_cfg;
  rgu_scoreboard m_scoreboard;

  // Register layer adapter
  reg2apb_adapter m_reg2apb;
  // Register predictor
  uvm_reg_predictor#(apb_seq_item) m_apb2reg_predictor;

  //------------------------------------------
  // Constraints
  //------------------------------------------

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "rgu_env", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass:rgu_env

function rgu_env::new(string name = "rgu_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void rgu_env::build_phase(uvm_phase phase);
  if (!uvm_config_db #(rgu_env_config)::get(this, "", "rgu_env_config", m_cfg))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration rgu_env_config from uvm_config_db. Have you set() it?")

  uvm_config_db #(apb_agent_config)::set(this, "m_apb_agent*",
                                         "apb_agent_config",
                                         m_cfg.m_apb_agent_cfg);
  m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);

  // Build the register model predictor
  m_apb2reg_predictor = uvm_reg_predictor#(apb_seq_item)::type_id::create("m_apb2reg_predictor", this);
  m_reg2apb = reg2apb_adapter::type_id::create("m_reg2apb");

  uvm_config_db #(rgu_agent_config)::set(this, "m_rgu_agent*",
                                         "rgu_agent_config",
                                         m_cfg.m_rgu_agent_cfg);
  m_rgu_agent = rgu_agent::type_id::create("m_rgu_agent", this);

  if(m_cfg.has_rgu_scoreboard) begin
    m_scoreboard = rgu_scoreboard::type_id::create("m_scoreboard", this);
  end
endfunction:build_phase

function void rgu_env::connect_phase(uvm_phase phase);

  // Only set up register sequencer layering if the rgu_rb is the top block
  // If it isn't, then the top level environment will set up the correct sequencer
  // and predictor
  if(m_cfg.rgu_rb.get_parent() == null) begin
    if(m_cfg.m_apb_agent_cfg.active == UVM_ACTIVE) begin
      m_cfg.rgu_rb.default_map.set_sequencer(m_apb_agent.m_sequencer, m_reg2apb);
    end

    //
    // Register prediction part:
    //
    // Replacing implicit register model prediction with explicit prediction
    // based on APB bus activity observed by the APB agent monitor
    // Set the predictor map:
    m_apb2reg_predictor.map = m_cfg.rgu_rb.default_map;
    // Set the predictor adapter:
    m_apb2reg_predictor.adapter = m_reg2apb;
    // Disable the register models auto-prediction
    m_cfg.rgu_rb.default_map.set_auto_predict(0);
    // Connect the predictor to the bus agent monitor analysis port
    m_apb_agent.ap.connect(m_apb2reg_predictor.bus_in);
  end

  if(m_cfg.has_rgu_scoreboard) begin
    m_rgu_agent.ap.connect(m_scoreboard.rgu_ap.analysis_export);
    m_scoreboard.rgu_rb = m_cfg.rgu_rb;
  end

endfunction: connect_phase
