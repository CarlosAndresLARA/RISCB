/* Copyright 2018 ETH Zurich and University of Bologna.
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the “License”); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * File:   ariane_axi_pkg.sv
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   17.8.2018
 *
 * Description: Contains Ariane's AXI ports, does not contain user ports
 */

package ariane_axi;

    // used in axi_adapter.sv
    typedef enum logic { SINGLE_REQ, CACHE_LINE_REQ } ad_req_t;

    localparam UserWidth = 1;
    localparam AddrWidth = 64;
    localparam DataWidth = 64;
    localparam StrbWidth = DataWidth / 8;

    typedef logic [ariane_soc::IdWidth-1:0]      id_t;
    typedef logic [ariane_soc::IdWidthSlave-1:0] id_slv_t;
    typedef logic [AddrWidth-1:0] addr_t;
    typedef logic [DataWidth-1:0] data_t;
    typedef logic [StrbWidth-1:0] strb_t;
    typedef logic [UserWidth-1:0] user_t;

  typedef logic [1:0] l_burst_t;
  typedef logic [1:0] l_resp_t;
  typedef logic [3:0] l_cache_t;
  typedef logic [2:0] l_prot_t;
  typedef logic [3:0] l_qos_t;
  typedef logic [3:0] l_region_t;
  typedef logic [7:0] l_len_t;
  typedef logic [2:0] l_size_t;
  typedef logic [5:0] l_atop_t; // atomic operations
  typedef logic [3:0] l_nsaid_t; // non-secure address identifier

    // AW Channel
    typedef struct packed {
        id_t            id;
        addr_t          addr;
        l_len_t         len;
        l_size_t        size;
        l_burst_t       burst;
        logic           lock;
        l_cache_t       cache;
        l_prot_t        prot;
        l_qos_t         qos;
        l_region_t      region;
        l_atop_t        atop;
       // user_t            user;
    } aw_chan_t;

    // AW Channel - Slave
    typedef struct packed {
        id_slv_t          id;
        addr_t            addr;
        l_len_t    len;
        l_size_t   size;
        l_burst_t  burst;
        logic             lock;
        l_cache_t  cache;
        l_prot_t   prot;
        l_qos_t    qos;
        l_region_t region;
        l_atop_t   atop;
        //user_t            user;
    } aw_chan_slv_t;

    // W Channel - AXI4 doesn't define a wid
    typedef struct packed {
        data_t data;
        strb_t strb;
        logic  last;
        //user_t user;
    } w_chan_t;

    // B Channel
    typedef struct packed {
        id_t            id;
        l_resp_t resp;
        //user_t          user;
    } b_chan_t;

    // B Channel - Slave
    typedef struct packed {
        id_slv_t        id;
        l_resp_t resp;
        //user_t          user;
    } b_chan_slv_t;

    // AR Channel
    typedef struct packed {
        id_t            id;
        addr_t          addr;
        l_len_t         len;
        l_size_t        size;
        l_burst_t       burst;
        logic           lock;
        l_cache_t       cache;
        l_prot_t        prot;
        l_qos_t         qos;
        l_region_t      region;
        //user_t            user;
    } ar_chan_t;

    // AR Channel - Slave
    typedef struct packed {
        id_slv_t          id;
        addr_t            addr;
        l_len_t    len;
        l_size_t   size;
        l_burst_t  burst;
        logic             lock;
        l_cache_t  cache;
        l_prot_t   prot;
        l_qos_t    qos;
        l_region_t region;
        //user_t            user;
    } ar_chan_slv_t;

    // R Channel
    typedef struct packed {
        id_t            id;
        data_t          data;
        l_resp_t        resp;
        logic           last;
        //user_t          user;
    } r_chan_t;

    // R Channel - Slave
    typedef struct packed {
        id_slv_t        id;
        data_t          data;
        l_resp_t resp;
        logic           last;
        //user_t          user;
    } r_chan_slv_t;

    // Request/Response structs
    typedef struct packed {
        //aw_chan_t aw;
        id_t            aw_id;
        addr_t          aw_addr;
        l_len_t         aw_len;
        l_size_t        aw_size;
        l_burst_t       aw_burst;
        logic           aw_lock;
        l_cache_t       aw_cache;
        l_prot_t        aw_prot;
        l_qos_t         aw_qos;
        l_region_t      aw_region;
        l_atop_t        aw_atop;
        logic           aw_valid;
        //w_chan_t  w;
        data_t          w_data;
        strb_t          w_strb;
        logic           w_last;
        logic           w_valid;
        logic           b_ready;
        //ar_chan_t ar;
        id_t            ar_id;
        addr_t          ar_addr;
        l_len_t         ar_len;
        l_size_t        ar_size;
        l_burst_t       ar_burst;
        logic           ar_lock;
        l_cache_t       ar_cache;
        l_prot_t        ar_prot;
        l_qos_t         ar_qos;
        l_region_t      ar_region;
        logic           ar_valid;
        logic           r_ready;
    } req_t;

    typedef struct packed {
        logic           aw_ready;
        logic           ar_ready;
        logic           w_ready;
        logic           b_valid;
        //b_chan_t  b;
        id_t            b_id;
        l_resp_t        b_resp;
        logic           r_valid;
        //r_chan_t  r;
        id_t            r_id;  
        data_t          r_data;
        l_resp_t        r_resp;
        logic           r_last;
    } resp_t;

    /*typedef struct packed {
        aw_chan_slv_t aw;
        logic         aw_valid;
        w_chan_t      w;
        logic         w_valid;
        logic         b_ready;
        ar_chan_slv_t ar;
        logic         ar_valid;
        logic         r_ready;
    } req_slv_t;

    typedef struct packed {
        logic         aw_ready;
        logic         ar_ready;
        logic         w_ready;
        logic         b_valid;
        b_chan_slv_t  b;
        logic         r_valid;
        r_chan_slv_t  r;
    } resp_slv_t;*/

endpackage
