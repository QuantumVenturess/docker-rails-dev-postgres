FROM ruby

ENV ROOT_DIR /opt/app

RUN mkdir -p $ROOT_DIR
WORKDIR $ROOT_DIR

# ADD Gemfile $ROOT_DIR/Gemfile
# ADD Gemfile.lock $ROOT_DIR/Gemfile.lock
# RUN bundle install --system
RUN mkdir -p $ROOT_DIR/vendor/bundle
RUN bundle config --global path $ROOT_DIR/vendor/bundle

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ADD . $ROOT_DIR

# ADD start-server.sh /usr/bin/start-server.sh
# RUN chmod +x /usr/bin/start-server.sh

EXPOSE 8080

# CMD /usr/bin/start-server.sh
CMD $ROOT_DIR/start-server.sh
