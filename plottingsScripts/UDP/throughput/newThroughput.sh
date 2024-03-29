

THPUT() {
pcap_name=$(echo "${1}" | cut -d'.' -f 1);
tshark -r $1 -qz 'io,stat,0.1,SUM(frame.len)frame.len' -Y 'udp' > ${pcap_name}_total.ttput
}


PLOT_THPUT () {
   python3 newThroughput.py -tput;
   #rm *.ttput
}






for PCAP in *.pcap; do
   #echo $PCAP
   THPUT "${PCAP}";
done
PLOT_THPUT;