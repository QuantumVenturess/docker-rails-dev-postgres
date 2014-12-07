#!/bin/bash
export UP_DATABASE_NAME=rails
export UP_RAILS_ENV=production

# postgres
docker run -d -v /var/lib/postgresql --name database postgres
# Build app image
docker build -t dangerous/rails-dev-postgres .
# bundle install
docker run -v $PWD:/opt/app dangerous/rails-dev-postgres bundle install
# rake assets:precompile
docker run -v $PWD:/opt/app dangerous/rails-dev-postgres bundle exec rake assets:precompile assets:clean RAILS_ENV=$UP_RAILS_ENV --trace

# rake db:create
docker run -e DATABASE_NAME=$UP_DATABASE_NAME -e DB_HOST=localhost -e DB_PORT=5432 -v $PWD:/opt/app --link database:db dangerous/rails-dev-postgres bundle exec rake db:create RAILS_ENV=$UP_RAILS_ENV
# rake db:migrate
docker run -e DATABASE_NAME=$UP_DATABASE_NAME -e DB_HOST=localhost -e DB_PORT=5432 -v $PWD:/opt/app --link database:db dangerous/rails-dev-postgres bundle exec rake db:migrate RAILS_ENV=$UP_RAILS_ENV
# Run app
docker run -d -e DATABASE_NAME=$UP_DATABASE_NAME -e DB_HOST=localhost -e DB_PORT=5432 -e RAILS_ENV=$UP_RAILS_ENV -e SECRET_KEY_BASE=175f91804d528c8abb9d6a45066dd50c9cc22ed9344825745500c453108c0fce4eac8f899cedb467eb5dc7f2bab91540a3cc852b55a2d64e0a51e7ca3774bfe8 -v $PWD:/opt/app --link database:db --name unicorn dangerous/rails-dev-postgres
# Nginx
docker run -d -p 80:80 --link unicorn:app --name nginx --volumes-from unicorn dangerous/nginx
