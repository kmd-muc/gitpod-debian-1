FROM debian:10

# so I can install package without updating sources.list again
RUN printf "deb http://deb.debian.org/debian buster main contrib non-free\ndeb http://security.debian.org/debian-security buster/updates main\ndeb http://deb.debian.org/debian buster-updates main"  > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -yq sudo

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME

### Gitpod user (2) ###
USER gitpod

### Install necessary packages
RUN sudo apt-get install -yq curl g++ gcc autoconf automake bison libc6-dev \
        libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool \
        libyaml-dev make pkg-config sqlite3 zlib1g-dev libgmp-dev \
        libreadline-dev libssl-dev gnupg2 procps libpq-dev vim git

### Install rvm
RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

### Install ruby 2.7.4 and set it as default
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-2.7.4 && rvm use ruby-2.7.4 --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc
RUN bash -lc "rvm get stable --auto-dotfiles"

ENV GEM_HOME=/workspace/.rvm

### Install Heroku CLI
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh


