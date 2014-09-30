FROM abevoelker/ruby:latest
MAINTAINER millisami(millisami@gmail.com)

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install -j3


# ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up APT when done.
ADD config/unicorn.rb /tmp/
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
