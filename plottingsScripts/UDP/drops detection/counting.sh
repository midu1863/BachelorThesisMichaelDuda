COUNT() {
pcap_name=$(echo "${1}" | cut -d'.' -f 1);
   tshark -r $1 -Y 'udp' | wc -l > ${pcap_name}_total_packet.tot
}

PLOT_COUNT () {
   python3 counting.py;
   #rm *.tot
}

for PCAP in *.pcap; do
   #echo $PCAP
   COUNT "${PCAP}";
done
PLOT_COUNT;