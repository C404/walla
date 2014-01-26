server "walla.lta.io", :app, :web, :db, :primary => true

# Thin prod conf
set :thin_port,                 4242
set :thin_max_conns,            1024
set :thin_max_persistent_conns, 1024
set :thin_servers,              3

set :user, 'walla'
set :deploy_to, '/home/walla/app'
set :branch, 'master'
set :rails_env, 'production'
