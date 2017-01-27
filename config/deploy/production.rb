set :deploy_to, "/mnt/app/#{fetch(:application)}_production"
set :branch, "master"
set :rails_env, "production"

set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_pid, "#{deploy_to}/current/tmp/pids/puma.pid"

server '120.77.11.131', user: 'root', roles: %w{web app db}, primary: true
