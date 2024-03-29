RETS() {
pcap_name=$(echo "${1}" | cut -d'.' -f 1);
tshark -r $1 -Y 'tcp' | wc -l > ${pcap_name}_retransmission.rets
tshark -r $1 -Y 'tcp && tcp.analysis.retransmission' | wc -l>> ${pcap_name}_retransmission.rets
}

PLOT_RETS() {
   python3  getRetransmission.py;

}

for PCAP in *.pcap; do
   #echo $PCAP
   RETS "${PCAP}";
done
PLOT_RETS;