FROM ubuntu:18.04

RUN apt-get update 
RUN apt-get install -y curl gnupg2 build-essential sudo
RUN ["apt-get", "-y", "install", "vim"]

RUN useradd -rm -d /home/hosting -s /bin/bash -g root -G sudo -u 1001 hosting
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hosting
WORKDIR /home/hosting/projekt

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

RUN echo ""
RUN curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile"
RUN /bin/bash -l -c "echo 'source ~/.rvm/scripts/rvm' >> ~/.bashrc"
RUN /bin/bash -l -c "source ~/.bashrc"
RUN /bin/bash -l -c "rvm install "ruby-3.0.2""
RUN /bin/bash -l -c "rvm use 3.0.2"

EXPOSE 3000
