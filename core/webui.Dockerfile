FROM ubuntu

WORKDIR /app

RUN apt update && apt upgrade -y

# open5gs webui

## nodejs

# I know we already have curl
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install node
RUN . "$NVM_DIR/nvm.sh" && nvm use node
RUN . "$NVM_DIR/nvm.sh" && nvm alias default node
RUN VERSION=$(ls -1 /root/.nvm/versions/node/) && ln -s /root/.nvm/versions/node/$VERSION/bin/node /bin/node
RUN VERSION=$(ls -1 /root/.nvm/versions/node/) && ln -s /root/.nvm/versions/node/$VERSION/bin/npm /bin/npm
RUN which node
RUN node --version
RUN npm --version

RUN curl -sLf "https://github.com/open5gs/open5gs/archive/v2.7.0.tar.gz" | tar zxf -

WORKDIR /app/open5gs-2.7.0/webui

RUN npm clean-install && npm run build

CMD ["npm", "run", "start"]
