FROM ruby

ENV RAILS_ENV production
ENV ROOT_DIR /opt/app

RUN mkdir -p $ROOT_DIR
WORKDIR $ROOT_DIR
# Mount volume for Nginx to serve static files from public folder
VOLUME $ROOT_DIR

# Gems
ADD $ROOT_DIR/Gemfile $ROOT_DIR/Gemfile
ADD $ROOT_DIR/Gemfile.lock $ROOT_DIR/Gemfile.lock
RUN bundle install --system

# Add all files
ADD $ROOT_DIR $ROOT_DIR

# Assets
RUN bundle exec rake assets:precompile assets:clean RAILS_ENV=$RAILS_ENV --trace

ADD $ROOT_DIR/start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8080

CMD /usr/bin/start-server.sh
