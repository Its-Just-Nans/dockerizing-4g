FROM debian

# look mom I build the srsRAN_4G
WORKDIR /app

RUN apt update && apt install -y git build-essential cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev

# libzmq

RUN apt install -y libzmq3-dev libtool
RUN git clone https://github.com/zeromq/libzmq.git
RUN cd /app/libzmq && ./autogen.sh && ./configure
RUN cd /app/libzmq && make
RUN cd /app/libzmq && make install
RUN cd /app/libzmq && ldconfig

# czmq

RUN git clone https://github.com/zeromq/czmq.git
RUN cd /app/czmq && ./autogen.sh && ./configure
RUN cd /app/czmq && make
RUN cd /app/czmq && make install
RUN cd /app/czmq && ldconfig

# srsRAN_4G

RUN cd /app && git clone https://github.com/srsRAN/srsRAN_4G.git && cd srsRAN_4G && mkdir build
RUN cd /app/srsRAN_4G/build && cmake ../
RUN cd /app/srsRAN_4G/build && make
RUN cd /app/srsRAN_4G/build && make install
RUN cd /app/srsRAN_4G/build && srsran_install_configs.sh user

COPY ./ue.conf /app/ue.conf


RUN apt install -y iproute2 iputils-ping curl

COPY ./ue.sh /app/ue.sh

CMD ["/app/ue.sh"]