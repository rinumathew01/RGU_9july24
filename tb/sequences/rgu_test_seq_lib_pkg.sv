
package rgu_test_seq_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import rgu_agent_pkg::*;
import rgu_env_pkg::*;
import rgu_bus_sequence_lib_pkg::*;

// Base class to get sub-sequencer handles
//
// Note that this virtual sequence uses resources to get
// the handles to the target sequencers
//
// This means that we do not need a virtual sequencer
//
class rgu_vseq_base extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(rgu_vseq_base)

  function new(string name = "rgu_vseq_base");
    super.new(name);
  endfunction

  // Virtual sequencer handles
  rgu_sequencer rgu;

  // Handle for env config to get to interrupt line
  rgu_env_config m_cfg;

  // This set up is required for child sequences to run
  task body;
    if(rgu==null) begin
      `uvm_fatal("SEQ_ERROR", "Sequencer handle is null")
    end

    if(m_cfg==null) begin
      `uvm_fatal("CFG_ERROR", "Configuration handle is null")
    end

  endtask: body

  function void rgu_seq_set_cfg(rgu_bus_base_seq seq_);
    seq_.m_cfg = m_cfg;
  endfunction

endclass: rgu_vseq_base


//
// Register test:
//
// Checks the reset values
// Does a randomized read/write bit test using the front door
// Repeats the read/write bit test using the back door (not necessary, but as an illustration)
//
class register_test_vseq extends rgu_vseq_base;

  `uvm_object_utils(register_test_vseq)

  function new(string name = "register_test_vseq");
    super.new(name);
  endfunction

  task body;
    uvm_reg_hw_reset_seq reg_seq = uvm_reg_hw_reset_seq::type_id::create("reg_seq");
    reg_seq.model = m_cfg.rgu_rb;
    

    super.body;
    `uvm_info(get_type_name(),"REG_SEQUENCE STARTED SANDEEP",UVM_MEDIUM);
    reg_seq.start(m_sequencer);
    `uvm_info(get_type_name(),"REG_SEQUENCE ENDED SANDEEP",UVM_MEDIUM);
  endtask: body

endclass: register_test_vseq

class register_test_one_reg_vseq extends rgu_vseq_base;

  `uvm_object_utils(register_test_one_reg_vseq)

  function new(string name = "register_test_one_reg_vseq");
    super.new(name);
  endfunction

  task body;
    rgu_reset_one_seq reg_seq = rgu_reset_one_seq::type_id::create("reg_seq");
    // reg_seq.model = m_cfg.rgu_rb;
    rgu_seq_set_cfg(reg_seq);

    super.body;
    `uvm_info(get_type_name(),"REG_SEQUENCE STARTED SANDEEP",UVM_MEDIUM);
    reg_seq.start(m_sequencer);
    `uvm_info(get_type_name(),"REG_SEQUENCE ENDED SANDEEP",UVM_MEDIUM);
  endtask: body

endclass: register_test_one_reg_vseq



/*
//
// This virtual sequence does rgu transfers with randomized config
// and tests the interrupt handling
//
class config_interrupt_test extends rgu_vseq_base;

  `uvm_object_utils(config_interrupt_test)

  logic[31:0] control;

  function new(string name = "config_interrupt_test");
    super.new(name);
  endfunction

  task body;
    // Sequences to be used
    ctrl_go_seq go = ctrl_go_seq::type_id::create("go");
    rgu_config_rand_order_seq rgu_config = rgu_config_rand_order_seq::type_id::create("rgu_config");
    tfer_over_by_poll_seq wait_unload = tfer_over_by_poll_seq::type_id::create("wait_unload");
    rgu_rand_seq rgu_transfer = rgu_rand_seq::type_id::create("rgu_transfer");

    rgu_seq_set_cfg(go);
    rgu_seq_set_cfg(rgu_config);
    rgu_seq_set_cfg(wait_unload);

    super.body;

    control = 0;

    repeat(10) begin
      rgu_config.interrupt_enable = 1;
      rgu_config.start(m_sequencer);
      control = rgu_config.data;
      go.start(m_sequencer);
      fork
        begin
          m_cfg.wait_for_interrupt;
          wait_unload.start(m_sequencer);
          if(!m_cfg.is_interrupt_cleared()) begin
            `uvm_error("INT_ERROR", "Interrupt not cleared by register read/write");
          end
        end
        begin
          rgu_transfer.BITS = control[6:0];
          rgu_transfer.rx_edge = control[9];
          rgu_transfer.start(rgu);
        end
      join
    end
  endtask

endclass: config_interrupt_test

//
// This virtual sequence does rgu transfers with randomized config
// and polls the go_bsy bit in the control register to determine
// when the transfer has completed
//
class config_polling_test extends rgu_vseq_base;

  `uvm_object_utils(config_polling_test)

  logic[31:0] control;

  function new(string name = "config_polling_test");
    super.new(name);
  endfunction

  task body;
    // Sequences to be used
    ctrl_go_seq go = ctrl_go_seq::type_id::create("go");
    rgu_config_rand_order_seq rgu_config = rgu_config_rand_order_seq::type_id::create("rgu_config");
    tfer_over_by_poll_seq wait_unload = tfer_over_by_poll_seq::type_id::create("wait_unload");
    rgu_rand_seq rgu_transfer = rgu_rand_seq::type_id::create("rgu_transfer");

    rgu_seq_set_cfg(go);
    rgu_seq_set_cfg(rgu_config);
    rgu_seq_set_cfg(wait_unload);

    super.body;

    control = 0;

    repeat(10) begin
      rgu_config.interrupt_enable = 1;
      rgu_config.start(m_sequencer);
      control = rgu_config.data;
      go.start(m_sequencer);
      fork
        begin
          wait_unload.start(m_sequencer);
        end
        begin
          rgu_transfer.BITS = control[6:0];
          rgu_transfer.rx_edge = control[9];
          rgu_transfer.start(rgu);
        end
      join
    end
  endtask

endclass: config_polling_test
*/
endpackage:rgu_test_seq_lib_pkg
