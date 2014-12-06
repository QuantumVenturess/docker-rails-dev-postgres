### Artifacts
- Dockerfile
- Procfile
- start-server.sh
- config/unicorn.rb
- db/database.yml

### Setup
Add gems
```
$ echo 'gem "foreman"' >> Gemfile
$ echo 'gem "pg"' >> Gemfile
$ echo 'gem "unicorn"' >> Gemfile
```

Create /tmp/pids (Only do this step if unicorn.rb file states pid)
```
$ mkdir tmp/pids
```

Docker build and run
```
# Build image
$ docker build -t rails_dev_postgres .
# Run bundle install
$ docker run -v $PWD:/opt/app rails_dev_postgres bundle install
# Database setup
$ docker run -d -v /var/lib/postgresql --name db postgres
# You have to use --name [container_name] if you use DB_NAME in database.yml
$ docker run -v $PWD:/opt/app --link db:db --name rails rails_dev_postgres bundle exec rake db:create
$ docker rm rails
$ docker run -v $PWD:/opt/app --link db:db --name rails rails_dev_postgres bundle exec rake db:migrate
$ docker rm rails
# Create container and run app
$ docker run -p 3000:8080 -v $PWD:/opt/app --link db:db --name rails rails_dev_postgres
```
