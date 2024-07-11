
interface rgu_monitor_bfm (
  input logic       clk,
  input logic [7:0] cs,
  input logic       miso,
  input logic       mosi
);

import rgu_agent_pkg::*;

//------------------------------------------
// Data Members
//------------------------------------------
rgu_monitor proxy;
  rgu_seq_item item;
  integer unsigned n;
  integer unsigned p;
//------------------------------------------
// Methods
//------------------------------------------

task run();
  rgu_seq_item cloned_item;

  item = rgu_seq_item::type_id::create("item");

  while(cs === 8'hxx) begin
    #1;
  end

  forever begin

    while(cs === 8'hff) begin
      @(cs);
    end

    n = 0;
    p = 0;
    item.nedge_mosi = 0;
    item.pedge_mosi = 0;
    item.nedge_miso = 0;
    item.pedge_miso = 0;
    item.cs = cs;

    fork
      begin
        while(cs != 8'hff) begin
          @(clk);
          if(clk == 1) begin
            item.nedge_mosi[p] = mosi;
            item.nedge_miso[p] = miso;
            p++;
          end
          else begin
            item.pedge_mosi[n] = mosi;
            item.pedge_miso[n] = miso;
            n++;
          end
        end
      end
      begin
        @(clk);
        @(cs);
      end
    join_any
    disable fork;

    // Clone and publish the cloned item to the subscribers
    $cast(cloned_item, item.clone());
    proxy.notify_transaction(cloned_item);
  end
endtask: run
  
endinterface: rgu_monitor_bfm
