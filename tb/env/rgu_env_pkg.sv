
package rgu_env_pkg;

  // Standard UVM import & include:
  import uvm_pkg::*;
`include "uvm_macros.svh"

  // Any further package imports:
  import apb_agent_pkg::*;
  import rgu_agent_pkg::*;
  import rgu_reg_pkg::*;

  // Includes:
`include "rgu_env_config.svh"
`include "rgu_scoreboard.svh"
`include "rgu_env.svh"

endpackage: rgu_env_pkg
