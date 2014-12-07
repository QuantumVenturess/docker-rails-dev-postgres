### Artifacts
- Dockerfile
- Procfile
- start-server.sh
- config/unicorn.rb
- db/database.yml

### Setup
Add the gems to your `Gemfile`
```
gem "foreman"
gem "pg"
gem "unicorn"
```

Create /tmp/pids (Only do this step if unicorn.rb file states pid)
```
$ mkdir tmp/pids
```

Docker build and run
```
# Build app image
$ docker build -t [app_tag_name] .
# Run bundle install inside app container
$ docker run -v $PWD:/opt/app [app_tag_name] bundle install
# Run postgres database container
$ docker run -d -v /var/lib/postgresql --name [db_tag_name] postgres
# Create database inside postgres container using app container's database.yml
$ docker run -e DATABASE_NAME=[db_name] -v $PWD:/opt/app --link [db_tag_name]:db [app_tag_name] bundle exec rake db:create RAILS_ENV=[environment]
# Run migrations on postgres container from the app container
$ docker run -e DATABASE_NAME=[db_name] -v $PWD:/opt/app --link [db_tag_name]:db [app_tag_name] bundle exec rake db:migrate RAILS_ENV=[environment]
# Run app container
$ docker run -d -e DATABASE_NAME=[db_name] -e RAILS_ENV=[environment] -p 3000:8080 -v $PWD:/opt/app --link [db_tag_name]:db [app_tag_name]
$ boot2docker ip
```
Go to http://[boot2docker_ip_address]:3000

### Production
```
# Compile assets before running app container
$ docker run -e DATABASE_NAME=[db_name] -v $PWD:/opt/app --link [db_tag_name]:db [app_tag_name] bundle exec rake assets:precompile assets:clean RAILS_ENV=[environment] --trace
# Run app container with a secret key base
$ docker run -d -e DATABASE_NAME=[db_name] -e RAILS_ENV=[environment] -e SECRET_KEY_BASE=[rake secret] -v $PWD:/opt/app --link [db_tag_name]:db --name unicorn [app_tag_name]
# Nginx
$ docker run -d -p 80:80 --link [app_tag_name]:app --name nginx --volumes-from [app_tag_name] dangerous/nginx
$ boot2docker ip
```

### Docker hub
```
$ docker pull dangerous/docker-rails-dev-postgres
```
