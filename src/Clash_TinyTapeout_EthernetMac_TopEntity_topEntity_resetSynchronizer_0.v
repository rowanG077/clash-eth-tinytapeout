/* AUTOMATICALLY GENERATED VERILOG-2001 SOURCE CODE.
** GENERATED BY CLASH 1.6.4. DO NOT MODIFY.
*/
`timescale 100fs/100fs
module Clash_TinyTapeout_EthernetMac_TopEntity_topEntity_resetSynchronizer_0
    ( // Inputs
      input  eta // clock
    , input  eta1 // reset

      // Outputs
    , output wire  result // reset
    );
  reg  c$app_arg;
  reg  c$app_arg_0;

  // delay begin
  always @(posedge eta) begin : c$app_arg_delay
    c$app_arg <= c$app_arg_0;
  end
  // delay end

  // delay begin
  always @(posedge eta) begin : c$app_arg_0_delay
    c$app_arg_0 <= (eta1);
  end
  // delay end

  assign result = c$app_arg;


endmodule
