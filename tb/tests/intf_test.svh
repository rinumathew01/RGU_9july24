
class intf_test extends rgu_test_base;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(intf_test)

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "intf_test", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  // extern function void report_phase(uvm_phase phase);

endclass: intf_test

function intf_test::new(string name = "intf_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void intf_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase

task intf_test::run_phase(uvm_phase phase);

  intf_vseq t_seq =  intf_vseq::type_id::create("t_seq");
  set_seqs(t_seq);
  phase.raise_objection(this, "Test Sequence Started");
  t_seq.start(null);
  #100;
  phase.drop_objection(this, "Test Sequence Finished");
endtask: run_phase
