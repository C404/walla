#
# Deploy configuration for Gayme
#

require 'capistrano-thin'
require 'capistrano/ext/multistage'

set :application,   'walla'
set :scm,           :git
set :repository,    'git@github.com/3XX0/Walla.git'
set :deploy_via,    :remote_cache # Not that usefull here, since the repo is on the same host
set :use_sudo,      false

set :format,        :pretty
set :log_level,     :debug

set :shared_children, shared_children + %w{public/uploads public/preview public/sitemaps}
set :keep_releases, 5

# RVM automatic deployment
set :rvm_ruby_string, 'ruby-2.0.0-p247'
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'   # install RVM

# Database migration
after 'deploy:update_code', 'deploy:migrate'

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end
after  "deploy:update_code",        "db:symlink"
before "deploy:assets:precompile",  "db:symlink"

# Daemons stuff
set :daemons, [:twitter_bot]

# Sidekiqs stuff
set :sidekiqs, {
  default: {
    queues: [:default],
    concurrency: 5
  }
}

require 'rvm/capistrano'
require 'bundler/capistrano'
