RETS() {
pcap_name=$(echo "${1}" | cut -d'.' -f 1);
tshark -r $1 -Y 'tcp && tcp.analysis.retransmission' | awk 'NR==1{ts=$2}{print $2-ts}' > ${pcap_name}_retransmission.rets
}

PLOT_RETS() {
   python3  getRetransmissionBoxplot.py;

}

for PCAP in *.pcap; do
   #echo $PCAP
   RETS "${PCAP}";
done
PLOT_RETS;