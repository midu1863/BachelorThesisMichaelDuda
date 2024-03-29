# Bachelor Thesis: Introducing a Credit-Based Flow Control Mechanism for the Internet Service Provider Networks using P4
It was written by the Max Planck Institute with Prof. Dr. Anja Feldmann as 1. advisor, Dr. Yiting Xia as 2. advisor and Seifeddine Fathalli as supervisor. 
This repo contains all the code, which is used for the Bachelor Thesis. 

Please consider, that the computation time can be differ. If you want to run it on your CPU reconfigure in ___sw2___ these line with your CPU resources: 
```P4
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
```

First build your images for docker. 
```sh
sudo docker build -t p4lang/p4c ./Dockerfiles/p4c/
sudo docker build -t host ./Dockerfiles/host/
```

Once your image is build you shold be able to run the test environment with 
```sh
./start.sh creditBasedPackedCycle
```
and for simple port forwarding use 
```sh
./start.sh basic
```

To stop the test environment just use
```sh
./end.sh
```

If you make changes due the program you can compile all 3. software of each switch with
```sh
complile.sh creditBasedPackedCycle.p4 creditBasedPackedCycle.bmv2
```
or for simple port forwarding 
```sh
./complile.sh basic.p4 basic.bmv2
```
If you want compile only one software use
```sh
./complile_one.sh sw0 basic.p4 basic.bmv2
```

To run a test and monitor it run
```sh
./runBenchmark.sh ___nameOfSoftware___ ___lableName___ ___timeInSeconds___ ___concurrentConnection___
./runBenchmark.sh creditBasedPackedCycle test 60 '-P 1'
## For UDP 
./runBenchmark.sh creditBasedPackedCycle test 60 '-P 1 -u -b 50m' 
```
The flage ___-P___ is for concurrent connection,  ___-u___ for UDP instead of TCP and ___-b 50m___ is for UDP to set the bandwidth of the UDP stream. 

To run a batch of test you can use allTest.sh. 
```sh
./allTest.sh
```
Before run it, please make sure, that you have all test written down. 

If you want more scripts and other stuff, which was created durring the thesis writting, then look to this repo: [simluateNetworkWithDockerAndP4Lang
](https://github.com/midu1863/simluateNetworkWithDockerAndP4Lang)
