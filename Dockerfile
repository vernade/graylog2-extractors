FROM phusion/baseimage

RUN apt-get update && \
    apt-get install --yes --quiet \
            autoconf \
            bison \
            build-essential \
            curl \
            git \
            libncurses5-dev \
            libreadline6-dev \
            libssl-dev \
            libyaml-dev \
            tmux \
            wget \
            zlib1g-dev \
            && \
    apt-get clean

RUN cd $(mktemp -d -t ruby_build) && \
    git clone https://github.com/sstephenson/ruby-build.git && \
    cd ruby-build && \
    ./install.sh && \
    cd .. && \
    rm -rf $(pwd)

RUN ruby-build 2.1.3 /usr/local

RUN gem install bundler

RUN mkdir -p /web_app
WORKDIR /web_app

RUN apt-get update && \
    apt-get install --yes --quiet \
            libsqlite3-dev && \
    apt-get clean

ADD Gemfile /web_app/Gemfile
ADD Gemfile.lock /web_app/Gemfile.lock
RUN bundle install

ADD docker /

ADD . /web_app


