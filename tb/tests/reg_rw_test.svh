
class reg_rw_test extends rgu_test_base;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(reg_rw_test)

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "reg_rw_test", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  // extern function void report_phase(uvm_phase phase);

endclass: reg_rw_test

function reg_rw_test::new(string name = "reg_rw_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void reg_rw_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase

task reg_rw_test::run_phase(uvm_phase phase);

  reg_rw_vseq t_seq =  reg_rw_vseq::type_id::create("t_seq");
  set_seqs(t_seq);
  phase.raise_objection(this, "Test Sequence Started");
  t_seq.start(null);
  #100;
  phase.drop_objection(this, "Test Sequence Finished");
endtask: run_phase
