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


COPY ./enb.conf /app/enb.conf
COPY ./rr.conf /app/rr.conf
COPY ./rb.conf /app/rb.conf
COPY ./sib.conf /app/sib.conf

CMD ["/app/srsRAN_4G/build/srsenb/src/srsenb", \
    "--rf.device_name=zmq", \
    "--rf.device_args='fail_on_disconnect=true,tx_port=tcp://192.168.128.6:2000,rx_port=tcp://192.168.128.5:2001,id=enb,base_srate=23.04e6'", \
    "--enb_files.sib_config", "/app/sib.conf", \
    "--enb_files.rr_config", "/app/rr.conf", \
    "--enb_files.rb_config", "/app/rb.conf", \
    "/app/enb.conf"]