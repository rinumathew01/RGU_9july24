interface apb_monitor_bfm (
  input PCLK,
  input PRESETn,

  input logic [31:0] PADDR,
  input logic [31:0] PRDATA,
  input logic [31:0] PWDATA,
  input logic [15:0] PSEL,    // Only connect the ones that are needed
  input logic        PENABLE,
  input logic        PWRITE,
  input logic        PREADY
);

  import apb_agent_pkg::*;

//------------------------------------------
// Data Members
//------------------------------------------
int apb_index = 0; // Which PSEL line is this monitor connected to
apb_monitor proxy;
  
//------------------------------------------
// Component Members
//------------------------------------------

//------------------------------------------
// Methods
//------------------------------------------

// BFM Methods:
  
task run();
  apb_seq_item item;
  apb_seq_item cloned_item;
  
  item = apb_seq_item::type_id::create("item");

  forever begin
    // Detect the protocol event on the TBAI virtual interface
    @(posedge PCLK);
    if(PREADY && PSEL[apb_index])
      // Assign the relevant values to the analysis item fields
      begin
        item.addr = PADDR;
        item.we = PWRITE;
        if(PWRITE)
          begin
            item.data = PWDATA;
          end
        else
          begin
            item.data = PRDATA;
          end
        // Clone and publish the cloned item to the subscribers
        $cast(cloned_item, item.clone());
        proxy.notify_transaction(cloned_item);
      end
  end
endtask: run

endinterface: apb_monitor_bfm
