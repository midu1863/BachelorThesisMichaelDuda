sh start.sh $1 #creditBasedPackedCycle

sudo docker exec  sw0 tcpdump -i eth1 -w $2-sw0-eth1.pcap --immediate-mode -s 96 & docker exec  sw0 tcpdump -i eth2 -w $2-sw0-eth2.pcap --immediate-mode -s 96 & docker exec sw1 tcpdump -i eth1 -w $2-sw1-eth1.pcap --immediate-mode -s 96 & docker exec sw1 tcpdump -i eth2 -w $2-sw1-eth2.pcap --immediate-mode -s 96 & docker exec  sw2 tcpdump -i eth1 -w $2-sw2-eth1.pcap --immediate-mode -s 96 & docker exec sw2 tcpdump -i eth2 -w $2-sw2-eth2.pcap --immediate-mode -s 96 & docker exec host0 tcpdump -i eth1 -w /home/$2-host0-eth1.pcap --immediate-mode -s 96 & docker exec host0 tcpdump -i eth2 -w /home/$2-host0-eth2.pcap --immediate-mode -s 96 & docker exec sw2 sh ./queueTime.sh $2 & docker exec host1 iperf -s -B 13.13.0.3 $5 > $2-server.log & docker exec -it host0 iperf -c 13.13.0.3 -t $3 $4 $5 > $2-client.log

time=$(($3+10))
sleep $time
sudo docker exec -it sw0 sh getReject.sh > $2-rejectedPacket.log


sh end.sh


sleep 10
