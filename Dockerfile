FROM nvidia/cuda:10.0-devel-ubuntu18.04

MAINTAINER Elvin

WORKDIR /

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository -y ppa:ethereum/ethereum -y \
    && apt-get update \
    && apt-get install -y git \
     cmake \
     ocl-icd-libopencl1 \
     libdbus-1-dev \
     opencl-headers \
     mesa-common-dev \
     libmicrohttpd-dev \
     build-essential

RUN git clone https://github.com/ethereum-mining/ethminer/ \
    && cd ethminer \
    && git submodule update --init --recursive \
    && mkdir build \
    && cd build \
    && cmake -DETHASHCL=OFF -DETHASHCUDA=ON .. \
    && cmake --build . \
    && make install \
    && mkdir /data



ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

ENTRYPOINT ["/ethminer/build/ethminer/ethminer", "--farm-recheck", "200", "-U"]
