/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_IPV4 = 0x0800;
const bit<16> TYPE_ARP  = 0x0806;
const bit<16> TYPE_CUP  = 0x0101;
const bit<32> maxPorts  = 3;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<32> switchId_t;
typedef bit<32> creditValue_t;

header ethernet_t {

    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header cup_t {
    bit<32>     creditValue;
}

header arp_t {
    bit<16>   hwType;
    bit<16>   protocalType;
    bit<8>    hwAddrLenght;
    bit<8>    protocolAddrLenght;
    bit<16>   opCode;
    macAddr_t srcMacAddr;
    ip4Addr_t srcIpAddr;
    macAddr_t dstMacAddr;
    ip4Addr_t dstIpAddr;
}


header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}



struct metadata {
    bit<9>  ingress_port;
    bit<9>  egress_spec;
    bit<9>  egress_port;
    bit<32> instance_type;
    bit<32> packet_length;
    bit<32> enq_timestamp;
    bit<19> enq_qdepth;
    bit<32> deq_timedelta;
    bit<19> deq_qdepth;
    bit<48> ingress_global_timestamp;
    bit<48> egress_global_timestamp;
    bit<16> mcast_grp;
    bit<16> egress_rid;
    bit<1>  checksum_error;
    error   parser_error;
    bit<3>  priority;
}

struct headers {
    ethernet_t  ethernet;
    arp_t       arp;
    ipv4_t      ipv4;
    cup_t       cup;
}

register<bit<32>>(65535)     leftOverCreditCard;
register<bit<19>>(maxPorts)     egressDequeueDepth;
register<bit<19>>(maxPorts)     egressEnqueueDepth;

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/


parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state drop {

        transition accept;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_ARP:   parse_arp;
            TYPE_IPV4:  parse_ipv4;
            TYPE_CUP:   parse_cup;
            default:    drop;
        }
    }


    state parse_arp {
        packet.extract(hdr.arp);
        transition accept;
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }

    state parse_cup {
        packet.extract(hdr.ipv4);
        packet.extract(hdr.cup);
        transition accept;
    }

}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    register<bit<32>>(10) debug;

    action drop() {
        mark_to_drop(standard_metadata);
    }

    action ipv4_forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
    }

    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    action mac_forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
    }

    table mac_lpm {
        key = {
            hdr.arp.dstIpAddr: lpm;
        }
        actions = {
            mac_forward;
            drop;
            NoAction;
        }
        default_action = drop();
    }

     action reduceLeftOver() {
        creditValue_t balence = 0;
        bit<16> subnet = hdr.ipv4.dstAddr[31:16];
        leftOverCreditCard.read(balence, (bit<32>) subnet);
        balence = balence - 1;

        leftOverCreditCard.write((bit<32>) subnet, balence);
    }


    action sendMirrorCup(bit<32> sendTo) {
        clone(CloneType.I2E, sendTo);
    }

    apply {

        bool isNotDropped = true;
         switch (hdr.ethernet.etherType) {
            TYPE_ARP    : {mac_lpm.apply();}
            TYPE_IPV4   : {ipv4_lpm.apply();}
            default: {  if (hdr.ipv4.isValid()) {
                            if (hdr.ipv4.dstAddr == 0x0d0d0003) {
                                creditValue_t value =0;
                                debug.read(value, 0);
                                value = value +1;
                                debug.write(0,value);
                            }
                        }
                        drop(); isNotDropped = false;}
        }

        if(isNotDropped) {
            bit<16> subnet = hdr.ipv4.dstAddr[31:16];
            creditValue_t leftOver = 0;
            leftOverCreditCard.read(leftOver, (bit<32>)subnet);
            reduceLeftOver();
            if (leftOver <= 30) {
                 bit<19> queue = 0;
                egressEnqueueDepth.read(queue, 1);
                if(queue > 500) {
                    sendMirrorCup((bit<32>) standard_metadata.ingress_port + 1);
                    leftOverCreditCard.write((bit<32>) subnet, 30);
                } else {
                    sendMirrorCup((bit<32>) standard_metadata.ingress_port + 1);
                    leftOverCreditCard.write((bit<32>) subnet, 40);
                }

            }
        }

    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {

    action drop() {
        mark_to_drop(standard_metadata);
    }

    action updateQueueDepth() {
        bit<9> port = standard_metadata.egress_port;
        egressDequeueDepth.write((bit<32>) port, standard_metadata.deq_qdepth);
        egressEnqueueDepth.write((bit<32>) port, standard_metadata.enq_qdepth);
    }

     action sendCredits(creditValue_t creditBalance) {
        hdr.ipv4.ihl = 6;
        hdr.ipv4.totalLen = hdr.ipv4.totalLen + 4;
        hdr.cup.setValid();
        hdr.cup.creditValue = creditBalance;

        hdr.ethernet.etherType = TYPE_CUP;
    }
    register<bit<32>>(1) debug;
    apply {
        debug.write(0, (bit<32>) standard_metadata.instance_type);

        updateQueueDepth();

        if (standard_metadata.instance_type == 1) {
            creditValue_t balence = 0;
            bit<16> subnet = hdr.ipv4.dstAddr[31:16];
            leftOverCreditCard.read(balence, (bit<32>) subnet);

            sendCredits(balence);
            truncate((bit<32>) 38);
        }
    }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {
        update_checksum(
        hdr.ipv4.isValid() && hdr.cup.isValid(),
            { hdr.ipv4.version,
              hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr,
              hdr.cup.creditValue,
            },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
        update_checksum(
        hdr.ipv4.isValid() && !hdr.cup.isValid(),
            { hdr.ipv4.version,
              hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr,
            },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {



    apply {
            packet.emit(hdr.ethernet);
            packet.emit(hdr.arp);
            packet.emit(hdr.ipv4);
            packet.emit(hdr.cup);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;


