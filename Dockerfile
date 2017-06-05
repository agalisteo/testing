# Dockerfile for nosolosoftware/testing:16.04

FROM ubuntu:16.04
MAINTAINER Alberto Galisteo Prieto "agalisteo@nosolosoftware.es"

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV CONFIGURE_OPTS --disable-install-doc
ENV WKHTML2PDF_PATH /usr/local/bin/wkhtmltopdf.sh
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_DEFAULT_VERSION 2.4.1

# Set the locale
#RUN locale-gen es_ES.UTF-8
#ENV LANG es_ES.UTF-8
#ENV LANGUAGE es_ES:es
#ENV LC_ALL es_ES.UTF-8

# Install system dependencies
RUN apt-get -y update \
    && apt-get install -y \
    git-core \
    curl \
    wget \
    zlib1g-dev \
    build-essential \
    tzdata \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    python-software-properties \
    libffi-dev \
    libgmp3-dev \
    libicu-dev \
    libqt4-dev \
    libqtwebkit-dev \
    libgtk2.0-0 \
    libgtkmm-2.4-dev \
    libnotify-dev \
    # db
    mongodb-server \
    redis-server \
    # rmagick
    imagemagick \
    libmagickwand-dev \
    # wkthml
    wkhtmltopdf \
    # firefox deps
    libasound2-dev \
    libdbus-glib-1-2 \
    xvfb \
    # ftp
    ncftp

RUN cd /usr/local/src \
    && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

# Firefox compatible with selenium webdriver
RUN wget -P /opt https://ftp.mozilla.org/pub/firefox/releases/46.0.1/linux-x86_64/en-GB/firefox-46.0.1.tar.bz2 \
    && tar xvjf /opt/firefox-46.0.1.tar.bz2 -C /opt \
    && ln -s /opt/firefox/firefox  /usr/bin/

# Install rbenv, ruby versions and gems
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \ 
    && git clone --depth 1 https://github.com/rbenv/ruby-build ${RBENV_ROOT}/plugins/ruby-build \
    && ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh 

COPY ruby-install.sh /

RUN /ruby-install.sh

RUN rbenv global $RUBY_DEFAULT_VERSION

# phantomjs 2.1.1
RUN wget -q -P /usr/local/src/ "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2" \
    && tar -xjf /usr/local/src/phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/src \
    && cp /usr/local/src/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

# legacy phantomjs 1.9.8
RUN wget -q -P /usr/local/src/ "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2" \
    && tar -xjf /usr/local/src/phantomjs-1.9.8-linux-x86_64.tar.bz2 -C /usr/local/src \
    && cp /usr/local/src/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs-legacy

# script for wkhtmltopdf
COPY wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf.sh

# mongodb config
RUN mkdir -p /data/db

# clean and clear
RUN apt-get clean && rm -rf /usr/local/src/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
