# notes: 
# 1) Flickfeeder is not thread safe yet, which means we will only use one thread in production. This is setup with: 
# $ heroku config:set RAILS_MAX_THREADS=1 (which I did setup on heroku)
# 2) Keep in mind the different variables: 
# => max db connections (i.e. "20" for us using Hobby tier Heroku Postgres plan )
# => number of threads (i.e. "1" because we are not thread safe yet)
# => number of puma processes (i.e. 2)
# => threads share the db connection pool
# => each process has its own db connection pool (in that configuration, our app can start up up to 10 dynos at most)   
# 3) With free, hobby or standard-1x dyno, use between 2 and 4 puma worker processes. Watch for R14 errors with '$ heroku logs' which indicates too much RAM is used
# 4) Thread consumes more CPU && Puma Worker Processes consume more RAM
# 5) To test if flickfeeder works well under a threaded enviroment, increase thread number in corresponding config vars: 
# $ heroku config:set MIN_THREADS=2 RAILS_MAX_THREADS=2
# check for error throroughly and if works, increase number of threads until response latency is not improving on the client size
# 6) great articles: 
# - https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
# - https://devcenter.heroku.com/articles/concurrency-and-database-connections#threaded-servers
# - https://devcenter.heroku.com/articles/procfile

# if using windows or Jruby, delete 1st line as they don't support puma worker processes
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end