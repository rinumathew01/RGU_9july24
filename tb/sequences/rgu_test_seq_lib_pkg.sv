
package rgu_test_seq_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import rgu_agent_pkg::*;
import rgu_env_pkg::*;
import rgu_bus_sequence_lib_pkg::*;
import rgu_reg_pkg::*;

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












class intf_vseq extends rgu_vseq_base;

  `uvm_object_utils(intf_vseq)

  function new(string name = "intf_vseq");
    super.new(name);
  endfunction

  task body;
    intf_seq reg_seq = intf_seq::type_id::create("reg_seq");
    // reg_seq.model = m_cfg.rgu_rb;
    rgu_seq_set_cfg(reg_seq);

    super.body;
    `uvm_info(get_type_name(),"Virtual Sequence Started",UVM_MEDIUM);
    reg_seq.start(m_sequencer);
    `uvm_info(get_type_name(),"Virtual Sequence Ended",UVM_MEDIUM);
  endtask: body

endclass: intf_vseq





class reset_vseq extends rgu_vseq_base;

  `uvm_object_utils(reset_vseq)

  rgu_reg_block rgu_rb;

  function new(string name = "reset_vseq");
    super.new(name);
  endfunction

  task body;
    // uvm_reg_hw_reset_seq reg_seq = uvm_reg_hw_reset_seq::type_id::create("reg_seq");
    // reg_seq.model = m_cfg.rgu_rb;

    super.body;
    // `uvm_info(get_type_name(),"uvm_reg_hw_reset_seq Started",UVM_MEDIUM);
    // reg_seq.start(m_sequencer);
    // `uvm_info(get_type_name(),"uvm_reg_hw_reset_seq Ended",UVM_MEDIUM);

    print_all_values();
  endtask


  function void print_all_values();
    uvm_reg_map maps[$];
    uvm_reg regs[$];
    uvm_reg_field fields[$];

    `uvm_info(get_type_name(),"Printing all the register field values in the reg block",UVM_MEDIUM);

    rgu_rb = m_cfg.rgu_rb;

    rgu_rb.get_maps(maps);
    foreach(maps[i]) begin

      regs.delete();
      maps[i].get_registers(regs);

      foreach(regs[j]) begin

        regs[j].reset();

        fields.delete();
        regs[j].get_fields(fields);
        $display("%s:",regs[j].get_name);

        foreach(fields[k]) begin
          $display("%s: %0h",fields[k].get_name,fields[k].get());
        end
        $display();
      end
      $display();
    end
  endfunction

endclass: reset_vseq




class reg_rw_vseq extends rgu_vseq_base;

  `uvm_object_utils(reg_rw_vseq)

  function new(string name = "reg_rw_vseq");
    super.new(name);
  endfunction

  task body;
    reg_rw_seq reg_seq = reg_rw_seq::type_id::create("reg_seq");
    // reg_seq.model = m_cfg.rgu_rb;
    rgu_seq_set_cfg(reg_seq);

    super.body;
    `uvm_info(get_type_name(),"Virtual Sequence Started",UVM_MEDIUM);
    reg_seq.start(m_sequencer);
    `uvm_info(get_type_name(),"Virtual Sequence Ended",UVM_MEDIUM);
  endtask: body

endclass: reg_rw_vseq

endpackage:rgu_test_seq_lib_pkg
