set :application, 'samson'
set :repo_url, 'git@github.com:aihehuo/samson.git'

set :rvm_ruby_version, '2.3.1' # Or whatever env you want it to run in.
set :rvm_bin_path, "/usr/local/rvm/bin/"
# set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
set :rvm_type, :system
set :user, "root"
set :deploy_via, :remote_cache
set :ssh_options, {:forward_agent => true}
set :use_sudo, false
set :scm, "git"
set :repository, "git@github.com:aihehuo/samson.git"

set :stages, %w(production)
set :default_stage, "production"
set :conditionally_migrate, true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .env}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/download}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# after "deploy", "deploy:migrate"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      after 'deploy:restart', 'puma:restart' # before_fork hook implemented (zero downtime deployments)
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      after "deploy", "deploy:cleanup" # keep only the last 5 releases
    end
  end

end


