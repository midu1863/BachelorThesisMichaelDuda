FROM ubuntu:22.04
RUN apt update 
RUN apt-get update
RUN apt install -y git
RUN mkdir build_p4

## get repos
WORKDIR build_p4
RUN git clone --recursive https://github.com/p4lang/p4c.git
RUN git clone https://github.com/protocolbuffers/protobuf.git
RUN git clone https://github.com/p4lang/behavioral-model.git

## install dependencies
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y cmake g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev libboost-graph-dev llvm pkg-config python3 python3-scapy python3-ply tcpdump doxygen graphviz

## install texlive
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get install -y texlive-full


RUN apt install -y software-properties-common wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get update
#RUN apt install -y cmake
## get newer version of gcc to avoid #include<experimential/filesystem> ERROR because codebase use #include<filesystem>
RUN add-apt-repository ppa:ubuntu-toolchain-r/test  
RUN apt-get update 
RUN apt-get install -y gcc-9 g++-9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 800 --slave /usr/bin/g++ g++ /usr/bin/g++-9
RUN update-alternatives --config gcc


## build protobuf
WORKDIR /build_p4/protobuf
RUN git checkout v3.2.0
RUN git submodule update --init --recursive
RUN apt install -y curl 
RUN ./autogen.sh
RUN ./configure
RUN make 
RUN make check 
RUN make install 
RUN ldconfig


##build p4 compiler


WORKDIR /build_p4/p4c
RUN mkdir build 
WORKDIR /build_p4/p4c/build
RUN cmake ..
RUN make -j4
RUN make install


## compile switch
WORKDIR /build_p4/behavioral-model
RUN apt install -y sudo 
RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
RUN apt-get update
RUN apt-get install libssl1.1
RUN ./install_deps.sh
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN ldconfig

RUN pip install --upgrade pip
RUN pip install --root-user-action=ignore ipaddr
RUN pip install --root-user-action=ignore ply