# Bachelor Thesis Introducing a Credit-Based Flow Control Mechanism for the Internet Service Provider Networks using P4
It was written by the Max Planck Institute with Prof. Dr. Anja Feldmann as 1. advisor, Dr. Yiting Xia as 2. advisor and Seifeddine Fathalli as supervisor. 
This repo contains all the code, which is used for the Bachelor Thesis. 



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
end.sh
```

If you make changes due the program you can compile all 3. software of each switch with
```sh
complile.sh creditBasedPackedCycle.p4 creditBasedPackedCycle.bmv2
```
or for simple port forwarding 
```sh
complile.sh basic.p4 basic.bmv2
```
If you want compile only one software use
```sh
complile_one.sh sw0 basic.p4 basic.bmv2
```

To run a test an monitor it run
```sh
runBenchmark.sh ___nameOfSoftware___ ___lableName___ ___timeInSeconds___ ___concurrentConnection___
runBenchmark.sh creditBasedPackedCycle test 60 '-P 1'
runBenchmark.sh creditBasedPackedCycle test 60 '-P 1 -u' 
```
