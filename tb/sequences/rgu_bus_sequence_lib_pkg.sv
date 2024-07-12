
package rgu_bus_sequence_lib_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import rgu_env_pkg::*;
import rgu_reg_pkg::*;

// Base class that used by all the other sequences in the
// package:
//
// Gets the handle to the register model - rgu_regmodel
//
// Contains the data and status fields used by most register
// access methods
//

class rgu_bus_base_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(rgu_bus_base_seq)

  // rgu Register block
  rgu_reg_block rgu_rb;

  // rgu env configuration object (containing a register model handle)
  rgu_env_config m_cfg;

  // Properties used by the various register access methods:
  rand uvm_reg_data_t data;  // For passing data
  uvm_status_e status;       // Returning access status

  function new(string name = "rgu_bus_base_seq");
    super.new(name);
  endfunction

  // Common functionality:
  // Getting a handle to the register model
  task body;
    if(m_cfg == null) begin
      `uvm_fatal(get_full_name(), "rgu_env_config is null")
    end
    rgu_rb = m_cfg.rgu_rb;
  endtask: body

endclass: rgu_bus_base_seq


class rgu_reset_one_seq extends rgu_bus_base_seq;
  `uvm_object_utils(rgu_reset_one_seq);

  function new(string name = "rgu_reset_one_seq");
    super.new(name);
  endfunction

  task body;
    super.body;
    `uvm_info(get_type_name(),"Resetting one register",UVM_MEDIUM);
    rgu_rb.RGU_TIMER0.reset();
    rgu_rb.RGU_TIMER0.write(status,1);
    `uvm_info(get_type_name(),$sformatf("...Value %0d",rgu_rb.RGU_TIMER0.TIM0_VAL.value),UVM_MEDIUM)
    rgu_rb.RGU_TIMER0.read(status,data);
    `uvm_info(get_type_name(),$sformatf("read: %0d",data),UVM_MEDIUM);
    `uvm_info(get_type_name(),$sformatf("...Value %0d",rgu_rb.RGU_TIMER0.TIM0_VAL.value),UVM_MEDIUM)
    `uvm_info(get_type_name(),"Resetting one register done",UVM_MEDIUM);
  endtask
endclass

/*
//
// Data load sequence:
//
// load all rxtx locations with
// random data in a random order
//
class data_load_seq extends rgu_bus_base_seq;

  `uvm_object_utils(data_load_seq)

  function new(string name = "data_load_seq");
    super.new(name);
  endfunction

  uvm_reg data_regs[]; // Array of registers


  task body;
    super.body;
    // Set up the data register handle array
    data_regs = '{rgu_rb.rxtx0, rgu_rb.rxtx1, rgu_rb.rxtx2, rgu_rb.rxtx3};
    // Randomize order
    data_regs.shuffle();
    foreach(data_regs[i]) begin
      // Randomize register content and then update
      if(!data_regs[i].randomize()) begin
        `uvm_error("body", $sformatf("Randomization error for data_regs[%0d]", i))
      end
      data_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
    end

  endtask: body

endclass: data_load_seq

//
// Data unload sequence - reads back the data rx registers
// all of them in a random order
//
class data_unload_seq extends rgu_bus_base_seq;

  `uvm_object_utils(data_unload_seq)

  uvm_reg data_regs[];

  function new(string name = "data_unload_seq");
    super.new(name);
  endfunction

  task body;
    super.body;
    // Set up the data register handle array
    data_regs = '{rgu_rb.rxtx0, rgu_rb.rxtx1, rgu_rb.rxtx2, rgu_rb.rxtx3};
    // Randomize access order
    data_regs.shuffle();
    // Use mirror in order to check that the value read back is as expected
    foreach(data_regs[i]) begin
      data_regs[i].mirror(status, UVM_CHECK, .parent(this));
    end
  endtask: body

endclass: data_unload_seq

//
// Div load sequence - loads one of the target
//                     divisor values
//
class div_load_seq extends rgu_bus_base_seq;

  `uvm_object_utils(div_load_seq)

  function new(string name = "div_load_seq");
    super.new(name);
  endfunction

  // Interesting divisor values:
  constraint div_values {data[15:0] inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};}

  task body;
    super.body;
    // Randomize the local data value
    if(!this.randomize()) begin
      `uvm_error("body", "Randomization error for this")
    end
    // Write to the divider register
    rgu_rb.divider.write(status, data, .parent(this));
  endtask: body

endclass: div_load_seq

//
// Ctrl set sequence - loads one control params
//                     but does not set the go bit
//
class ctrl_set_seq extends rgu_bus_base_seq;

  `uvm_object_utils(ctrl_set_seq)

  function new(string name = "ctrl_set_seq");
    super.new(name);
  endfunction

  // Controls whether interrupts are enabled or not
  bit int_enable = 0;

  task body;
    super.body;
    // Constrain to interesting data length values
    if(!rgu_rb.ctrl.randomize() with {char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};}) begin
      `uvm_error("body", "Control register randomization failed")
    end
    // Set up interrupt enable
    rgu_rb.ctrl.ie.set(int_enable);
    // Don't set the go_bsy bit
    rgu_rb.ctrl.go_bsy.set(0);
    // Write the new value to the control register
    rgu_rb.ctrl.update(status, .path(UVM_FRONTDOOR), .parent(this));
    // Get a copy of the register value for the rgu agent
    data = rgu_rb.ctrl.get();
  endtask: body

endclass: ctrl_set_seq

//
// Ctrl go sequence - sets the transfer in motion
//                    uses previously set control value
//
class ctrl_go_seq extends rgu_bus_base_seq;

  `uvm_object_utils(ctrl_go_seq)

  function new(string name = "ctrl_go_seq");
    super.new(name);
  endfunction

  task body;
    super.body;
    // Set the go_bsy bit and go!
    rgu_rb.ctrl.go_bsy.set(1);
    rgu_rb.ctrl.update(status, .path(UVM_FRONTDOOR), .parent(this));
  endtask: body

endclass: ctrl_go_seq

// Slave Select setup sequence
//
// Random values set for slave select
//
class slave_select_seq extends rgu_bus_base_seq;

  `uvm_object_utils(slave_select_seq)

  function new(string name = "slave_select_seq");
    super.new(name);
  endfunction

  task body;
    super.body;
    if(!rgu_rb.ss.randomize() with {cs.value != 8'h0;}) begin
      `uvm_error("body", "Randomization failure for ss")
    end
    rgu_rb.update(status, .path(UVM_FRONTDOOR), .parent(this));
  endtask: body

endclass: slave_select_seq

// Slave Unselect setup sequence
//
// Writes 0 to the slave select register
//
class slave_unselect_seq extends rgu_bus_base_seq;

  `uvm_object_utils(slave_unselect_seq)

  function new(string name = "slave_unselect_seq");
    super.new(name);
  endfunction

  task body;
    super.body;
    rgu_rb.ss.write(status, 32'h0, .parent(this));
  endtask: body

endclass: slave_unselect_seq

//
// Transfer complete by polling sequence
//
// Does successive reads from the control register
// to determine when the transfer has completed
//
class tfer_over_by_poll_seq extends rgu_bus_base_seq;

  `uvm_object_utils(tfer_over_by_poll_seq)

  function new(string name = "tfer_over_by_poll_seq");
    super.new(name);
  endfunction

  task body;
    data_unload_seq empty_buffer;
    slave_unselect_seq ss_deselect;

    super.body;

    // Poll the GO_BSY bit in the control register
    while(rgu_rb.ctrl.go_bsy.value[0] == 1) begin
      rgu_rb.ctrl.read(status, data, .parent(this));
    end
    ss_deselect = slave_unselect_seq::type_id::create("ss_deselect");
    ss_deselect.m_cfg = m_cfg;

    ss_deselect.start(m_sequencer);

    empty_buffer = data_unload_seq::type_id::create("empty_buffer");
    empty_buffer.m_cfg = m_cfg;

    empty_buffer.start(m_sequencer);
  endtask: body

endclass: tfer_over_by_poll_seq

//
// Sequence to configure the rgu randomly
//
class rgu_config_seq extends rgu_bus_base_seq;

  `uvm_object_utils(rgu_config_seq)

  function new(string name = "rgu_config_seq");
    super.new(name);
  endfunction

  bit interrupt_enable;

  task body;
    super.body;

    // Randomize the register model to get a new config
    // Constraining the generated value within ranges
    if(!rgu_rb.randomize() with {rgu_rb.ctrl.go_bsy.value == 0;
                                 rgu_rb.ctrl.ie.value == interrupt_enable;
                                 rgu_rb.ss.cs.value != 0;
                                 rgu_rb.ctrl.char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};
                                 rgu_rb.divider.ratio.value inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};
                                }) begin
      `uvm_error("body", "rgu_rb randomization failure")
    end
    // This will write the generated values to the HW registers
    rgu_rb.update(status, .path(UVM_FRONTDOOR), .parent(this));
    data = rgu_rb.ctrl.get();
  endtask: body

endclass: rgu_config_seq

//
// Sequence to configure the rgu randomly
// writing configuration values in a random order
//
class rgu_config_rand_order_seq extends rgu_bus_base_seq;

  `uvm_object_utils(rgu_config_rand_order_seq)

  function new(string name = "rgu_config_rand_order_seq");
    super.new(name);
  endfunction

  bit interrupt_enable;
  uvm_reg rgu_regs[$];

  task body;
    super.body;

    rgu_rb.get_registers(rgu_regs);
    // Randomize the register model to get a new config
    // Constraining the generated value within ranges
    if(!rgu_rb.randomize() with {rgu_rb.ctrl.go_bsy.value == 0;
                                 rgu_rb.ctrl.ie.value == interrupt_enable;
                                 rgu_rb.ss.cs.value != 0;
                                 rgu_rb.ctrl.char_len.value inside {0, 1, [31:33], [63:65], [95:97], 126, 127};
                                 rgu_rb.divider.ratio.value inside {16'h0, 16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80};
                                }) begin
      `uvm_error("body", "rgu_rb randomization failure")
    end
    // This will write the generated values to the HW registers
    // in a random order
    rgu_regs.shuffle();
    foreach(rgu_regs[i]) begin
      rgu_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
    end
    // Get the configured version of the control register
    data = rgu_rb.ctrl.get();
  endtask: body

endclass: rgu_config_rand_order_seq
*/
endpackage: rgu_bus_sequence_lib_pkg
