// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Description: Connects SV AXI interface to structs used by Ariane
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

module axi_slave_connect_rev (
    input  ariane_axi::req_t    axi_req_i,
    output ariane_axi::resp_t   axi_resp_o,
    AXI_BUS.Master slave
);

    assign slave.aw_id         = axi_req_i.aw_id;
    assign slave.aw_addr       = axi_req_i.aw_addr;
    assign slave.aw_len        = axi_req_i.aw_len;
    assign slave.aw_size       = axi_req_i.aw_size;
    assign slave.aw_burst      = axi_req_i.aw_burst;
    assign slave.aw_lock       = axi_req_i.aw_lock;
    assign slave.aw_cache      = axi_req_i.aw_cache;
    assign slave.aw_prot       = axi_req_i.aw_prot;
    assign slave.aw_qos        = axi_req_i.aw_qos;
    assign slave.aw_region     = axi_req_i.aw_region;
    assign slave.aw_user       = '0;
    assign slave.aw_valid      = axi_req_i.aw_valid;
    assign axi_resp_o.aw_ready = slave.aw_ready;

    assign slave.w_data        = axi_req_i.w_data;
    assign slave.w_strb        = axi_req_i.w_strb;
    assign slave.w_last        = axi_req_i.w_last;
    assign slave.w_user        = '0;
    assign slave.w_valid       = axi_req_i.w_valid;
    assign axi_resp_o.w_ready  = slave.w_ready;

    assign axi_resp_o.b_id     = slave.b_id;
    assign axi_resp_o.b_resp   = slave.b_resp;
    assign axi_resp_o.b_valid  = slave.b_valid;
    assign slave.b_ready       = axi_req_i.b_ready;

    assign slave.ar_id         = axi_req_i.ar_id;
    assign slave.ar_addr       = axi_req_i.ar_addr;
    assign slave.ar_len        = axi_req_i.ar_len;
    assign slave.ar_size       = axi_req_i.ar_size;
    assign slave.ar_burst      = axi_req_i.ar_burst;
    assign slave.ar_lock       = axi_req_i.ar_lock;
    assign slave.ar_cache      = axi_req_i.ar_cache;
    assign slave.ar_prot       = axi_req_i.ar_prot;
    assign slave.ar_qos        = axi_req_i.ar_qos;
    assign slave.ar_region     = axi_req_i.ar_region;
    assign slave.ar_user       = '0;
    assign slave.ar_valid      = axi_req_i.ar_valid;
    assign axi_resp_o.ar_ready = slave.ar_ready;

    assign axi_resp_o.r_id     = slave.r_id;
    assign axi_resp_o.r_data   = slave.r_data;
    assign axi_resp_o.r_resp   = slave.r_resp;
    assign axi_resp_o.r_last   = slave.r_last;
    assign axi_resp_o.r_valid  = slave.r_valid;
    assign slave.r_ready       = axi_req_i.r_ready;

endmodule
