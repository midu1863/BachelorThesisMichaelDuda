##creditBasedPackedCycle
#one
sh runBenchmark.sh creditBasedPackedCycle 1TCP-credit-60s 60
#sh runBenchmark.sh creditBasedPackedCycle 1TCP-credit-120s 120

sh runBenchmark.sh creditBasedPackedCycle 1UDP-credit-60s 60 '-P 1' '-u -b 50m'
#sh runBenchmark.sh creditBasedPackedCycle 1UDP-credit-120s 120 '-P 1' '-u -b 50m'

#two
sh runBenchmark.sh creditBasedPackedCycle 2TCP-credit-60s 60  '-P 2'
#sh runBenchmark.sh creditBasedPackedCycle 2TCP-credit-120s 120 '-P 2'

sh runBenchmark.sh creditBasedPackedCycle 2UDP-credit-60s 60 '-P 2' '-u -b 50m'
#sh runBenchmark.sh creditBasedPackedCycle 2UDP-credit-120s 120 '-P 2' '-u -b 50m'


#5
sh runBenchmark.sh creditBasedPackedCycle 5TCP-credit-60s 60  '-P 5'
#sh runBenchmark.sh creditBasedPackedCycle 5TCP-credit-120s 120 '-P 5'

sh runBenchmark.sh creditBasedPackedCycle 5UDP-credit-60s 60 '-P 5' '-u -b 50m'
#sh runBenchmark.sh creditBasedPackedCycle 5UDP-credit-120s 120 '-P 5' '-u -b 50m'

#10
sh runBenchmark.sh creditBasedPackedCycle 10TCP-credit-60s 60  '-P 10'
#sh runBenchmark.sh creditBasedPackedCycle 10TCP-credit-120s 120 '-P 10'

sh runBenchmark.sh creditBasedPackedCycle 10UDP-credit-60s 60 '-P 10' '-u -b 50m'
#sh runBenchmark.sh creditBasedPackedCycle 10UDP-credit-120s 120 '-P 10' -u

#100
sh runBenchmark.sh creditBasedPackedCycle 100TCP-credit-60s 60  '-P 100'
#sh runBenchmark.sh creditBasedPackedCycle 100TCP-credit-120s 120 '-P 100'

sh runBenchmark.sh creditBasedPackedCycle 100UDP-credit-60s 60 '-P 100' '-u -b 50m'
#sh runBenchmark.sh creditBasedPackedCycle 100UDP-credit-120s 120 '-P 100' '-u -b 50m'

##basic

#one
#sh runBenchmark.sh basic 1TCP-60s 60
#sh runBenchmark.sh basic 1TCP-120s 120

#sh runBenchmark.sh basic 1UDP-60s 60 '-P 1' '-u -b 50M'
#sh runBenchmark.sh basic 1UDP-120s 120 '-P 1' '-u -b 50M'
#two
#sh runBenchmark.sh basic 2TCP-60s 60  '-P 2'
#sh runBenchmark.sh basic 2TCP-120s 120 '-P 2'

#sh runBenchmark.sh basic 2UDP-60s 60 '-P 2' '-u -b 50M'
#sh runBenchmark.sh basic 2UDP-120s 120 '-P 2' '-u -b 50M'
#5
#sh runBenchmark.sh basic 5TCP-60s 60  '-P 5'
#sh runBenchmark.sh basic 5TCP-120s 120 '-P 5'

#sh runBenchmark.sh basic 5UDP-60s 60 '-P 5' '-u -b 50M'
#sh runBenchmark.sh basic 5UDP-120s 120 '-P 5' '-u -b 50M'

#10
#sh runBenchmark.sh basic 10TCP-60s 60  '-P 10'
#sh runBenchmark.sh basic 10TCP-120s 120 '-P 10'

#sh runBenchmark.sh basic 10UDP-60s 60 '-P 10' '-u -b 50M'
#sh runBenchmark.sh basic 10UDP-120s 120 '-P 10' '-u -b 50M'
#100
#sh runBenchmark.sh basic 100TCP-60s 60  '-P 100'
#sh runBenchmark.sh basic 100TCP-120s 120 '-P 100'

#sh runBenchmark.sh basic 100UDP-60s 60 '-P 100' '-u -b 50M'
#sh runBenchmark.sh basic 100UDP-120s 120 '-P 100' '-u -b 50M'
