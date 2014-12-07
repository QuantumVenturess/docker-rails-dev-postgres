#!/bin/bash
export UP_DATABASE_NAME=rails
export UP_RAILS_ENV=production

docker build -t dangerous/rails-dev-postgres .
docker run -v $PWD:/opt/app dangerous/rails-dev-postgres bundle install
docker run -d -v /var/lib/postgresql --name database postgres
docker run -e DATABASE_NAME=$UP_DATABASE_NAME -v $PWD:/opt/app --link database:db dangerous/rails-dev-postgres bundle exec rake db:create RAILS_ENV=$UP_RAILS_ENV
docker run -e DATABASE_NAME=$UP_DATABASE_NAME -v $PWD:/opt/app --link database:db dangerous/rails-dev-postgres bundle exec rake db:migrate RAILS_ENV=$UP_RAILS_ENV
docker run -e DATABASE_NAME=$UP_DATABASE_NAME -v $PWD:/opt/app --link database:db dangerous/rails-dev-postgres bundle exec rake assets:precompile assets:clean RAILS_ENV=$UP_RAILS_ENV --trace
# Run app
docker run -d -e DATABASE_NAME=$UP_DATABASE_NAME -e RAILS_ENV=$UP_RAILS_ENV -e SECRET_KEY_BASE=175f91804d528c8abb9d6a45066dd50c9cc22ed9344825745500c453108c0fce4eac8f899cedb467eb5dc7f2bab91540a3cc852b55a2d64e0a51e7ca3774bfe8 -v $PWD:/opt/app --link database:db --name unicorn dangerous/rails-dev-postgres
# Nginx
docker run -d -p 80:80 --link unicorn:app --name nginx --volumes-from unicorn dangerous/nginx
