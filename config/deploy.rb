# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'CServe'
set :repo_url, 'git@github.com:vinsol/CServe'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/apps/cserve'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  # after :publishing, :restart

  after :restart, :unicorn_restart do
    on roles(:web), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          Rake::Task[:'unicorn:hard_restart'].invoke
        end
      end
    end
  end
end

namespace :unicorn do
  task :hard_restart do
    Rake::Task[:'unicorn:stop'].invoke
    Rake::Task[:'unicorn:start'].invoke
  end

  desc 'start unicorn'
  task :start do
    on roles(:app), in: :parallel do
      within current_path do
        execute :bundle, :exec, "unicorn_rails -c config/unicorn.rb -D -E #{ fetch(:rails_env) }"
      end
    end
  end

  desc 'stop unicorn'
  task :stop do
    on roles(:app), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid`"
        end
      end
    end
  end

  desc 'restart unicorn'
  task :restart do
    on roles(:app), in: :parallel do
      within current_path do
        execute "kill -s USR2 `cat #{shared_path}/tmp/pids/unicorn.pid`"
      end
    end
  end
end

namespace :database do
  desc 'create database'
  task :create do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'migration'
  task :migrate do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:migrate'
        end
      end
    end
  end

  desc 'seed'
  task :seed do
    on roles(:db), in: :parallel do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
end
