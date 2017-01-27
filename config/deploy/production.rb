set :deploy_to, "/mnt/app/#{fetch(:application)}_production"
set :branch, "production"
set :rails_env, "production"

set :unicorn_env, "production"
set :unicorn_rack_env, "production"
set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"


server '120.77.11.131', user: 'root', roles: %w{web app db}, primary: true
