# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'dickbutt.link'
set :repo_url, 'git@github.com:gjacobrobertson/dickbutt.link.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/dickbutt.link'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Default value for default_env is {}
set :default_env, { rack_env: fetch(:stage).to_s }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Rbenv settings
set :rbenv_ruby, '2.1.2'

namespace :deploy do
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        if test "[ -f #{current_path.join('tmp/pids/thin.pid')} ]"
          invoke 'deploy:stop'
        end
        invoke 'deploy:start'
      end
    end
  end

  task :compile_assets do
    on roles(:app) do
      within release_path do
        execute :rake, "assetpack:build"
      end
    end
  end

  after :updated, :compile_assets
  after :publishing, :restart
end
