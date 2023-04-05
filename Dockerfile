FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl gnupg2 build-essential nano software-properties-common
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

RUN useradd -rm -d /home/hosting -s /bin/bash -g root -u 1001 hosting
#RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER hosting
WORKDIR /home/hosting/projekt



RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

RUN echo ""
RUN curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile"
RUN /bin/bash -l -c "echo 'source ~/.rvm/scripts/rvm' >> ~/.bashrc"
RUN /bin/bash -l -c "source ~/.bashrc"
RUN /bin/bash -l -c "rvm autolibs disable"
RUN /bin/bash -l -c "rvm pkg install openssl"
RUN /bin/bash -l -c "rvm install "ruby-3.2.0""
RUN /bin/bash -l -c "rvm use 3.2.0"
COPY Gemfile /home/hosting/projekt
COPY Gemfile.lock /home/hosting/projekt
RUN /bin/bash -l -c "gem install rails -v 7.0.4"


EXPOSE 3000
