
package rgu_agent_pkg;
`define get_config(cfg_type, cfg_handle, cfg_name) \
if (``cfg_handle`` == null) \
   if (!uvm_config_db #(``cfg_type``)::get(this, "", ``cfg_name``, ``cfg_handle``) ) \
     `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", ``cfg_name``) ) 

import uvm_pkg::*;
`include "uvm_macros.svh"

//import rgu_register_pkg::*;

`include "rgu_seq_item.svh"
`include "rgu_agent_config.svh"
`include "rgu_driver.svh"
`include "rgu_monitor.svh"
typedef uvm_sequencer#(rgu_seq_item) rgu_sequencer;
`include "rgu_agent.svh"

// Utility Sequences
`include "rgu_seq.svh"

endpackage: rgu_agent_pkg
