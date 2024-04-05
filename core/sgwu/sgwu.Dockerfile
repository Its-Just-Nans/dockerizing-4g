FROM ubuntu

WORKDIR /app

RUN apt update && apt upgrade -y

# tuto here
# https://open5gs.org/open5gs/docs/tutorial/01-your-first-lte/

# mongodb

# RUN apt install -y gnupg curl
# RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
# RUN echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# RUN apt update && apt install -y mongodb-org

# open5gs
# we need the add-apt-repository command
# RUN apt install -y software-properties-common python3 python-is-python3 python3-launchpadlib systemd
# RUN add-apt-repository ppa:open5gs/latest
# RUN apt update && apt install -y open5gs


RUN apt install -y python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson
RUN git clone https://github.com/open5gs/open5gs
WORKDIR /app/open5gs
RUN meson build --prefix=`pwd`/install
RUN ninja -C build
WORKDIR /app/open5gs/build
RUN ninja install


WORKDIR /app/open5gs/
RUN apt install -y fd-find

COPY ./sgwu.yaml /app/open5gs/install/etc/open5gs/sgwu.yaml

CMD ["/app/open5gs/install/bin/open5gs-sgwud"]
