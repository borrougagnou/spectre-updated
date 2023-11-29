#!/bin/bash

echo "==BEGIN=="
echo "### DEBUG ONLY, PREFER CONTAINER SOLUTION ###"

function base_install()
{
  sudo apt install wget curl git unzip rsync

  # INSTALLATION PYGMENTS:
  sudo apt install python3 python3-distutils
  wget https://bootstrap.pypa.io/get-pip.py
  sudo python3 get-pip.py
  sudo python3 -m pip install -g Pygments

  # INSTALLATION NVM --> NODEJS/NPM
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install lts/iron #node v20.10.0 | npm v10.2.3
  nvm use lts/iron
  nvm alias default lts/iron

  # INSTALLATION GO
  wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz

  
  echo "#####"
  echo "add this 2 lines into bashrc/zshrc/... :"
  echo ""
  echo "export PATH=$PATH:/usr/local/go/bin"
  echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"'
  echo ""
  echo "#####"

}


function dependancy_install()
{
  npm install
  go get
  go install

  if [ ! -d logs ]; then
    mkdir logs
  fi
  if [ ! -d data ]; then
    mkdir data
  fi
  if [ ! -f data/expiry.gob ]; then
    touch data/expiry.gob
  fi
  if [ ! -f data/session.key ]; then
    touch data/session.key
  fi

}

### (UN)COMMENT FOR INSTALL BASE:
base_install

### (UN)COMMENT FOR INSTALL DEPENDANCY:
dependancy_install

go build

echo "# GHOSTBIN LAUNCHED"
./ghostbin -addr="0.0.0.0:8619" -log_dir="logs" -root="data"

echo "===END==="
