class rgu_env_config extends uvm_object;

  localparam string s_my_config_id = "rgu_env_config";
  localparam string s_no_config_id = "no config";
  localparam string s_my_config_type_error_id = "config type error";

  // UVM Factory Registration Macro
  //
  `uvm_object_utils(rgu_env_config)


  //------------------------------------------
  // Data Members
  //------------------------------------------
  // Whether env analysis components are used:
  bit has_functional_coverage = 0;
  bit has_rgu_functional_coverage = 1;
  bit has_reg_scoreboard = 0;
  bit has_rgu_scoreboard = 1;

  // Configurations for the sub_components
  apb_agent_config m_apb_agent_cfg;
  rgu_agent_config m_rgu_agent_cfg;

  // rgu Register block
  rgu_reg_block rgu_rb;

  //------------------------------------------
  // Methods
  //------------------------------------------
//   extern static function rgu_env_config get_config( uvm_component c);

  // Standard UVM Methods:
  extern function new(string name = "rgu_env_config");

endclass: rgu_env_config

function rgu_env_config::new(string name = "rgu_env_config");
  super.new(name);
endfunction

//
// Function: get_config
//
// This method gets the my_config associated with component c. We check for
// the two kinds of error which may occur with this kind of
// operation.
//
// function rgu_env_config rgu_env_config::get_config( uvm_component c );
//   rgu_env_config t;

//   if (!uvm_config_db #(rgu_env_config)::get(c, "", s_my_config_id, t) )
//     `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

//   return t;
// endfunction
