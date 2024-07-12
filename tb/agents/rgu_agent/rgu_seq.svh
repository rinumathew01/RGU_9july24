
class rgu_seq extends uvm_sequence #(rgu_seq_item);

// UVM Factory Registration Macro
//
`uvm_object_utils(rgu_seq)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------


//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "rgu_seq");
extern task body;

endclass:rgu_seq

function rgu_seq::new(string name = "rgu_seq");
  super.new(name);
endfunction

task rgu_seq::body;
  rgu_seq_item req;

  begin
    req = rgu_seq_item::type_id::create("req");
    start_item(req);
    if(!req.randomize()) begin
      `uvm_error("body", "req randomization failure")
    end
    finish_item(req);
  end

endtask:body

class rgu_rand_seq extends uvm_sequence #(rgu_seq_item);

  `uvm_object_utils(rgu_rand_seq)

  function new(string name = "rgu_rand_seq");
    super.new(name);
  endfunction

  rand int unsigned BITS;
  rand logic rx_edge;

  task body;
    rgu_seq_item req = rgu_seq_item::type_id::create("req");

    start_item(req);
    if (!req.randomize() with {req.no_bits == BITS; req.RX_NEG == rx_edge;}) begin
      `uvm_error("body", "req randomization failure")
    end
    finish_item(req);

  endtask:body

endclass: rgu_rand_seq
