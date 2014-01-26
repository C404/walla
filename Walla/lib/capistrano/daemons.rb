Capistrano::Configuration.instance.load do
  _cset(:daemons_default_hook)  { false }
  _cset(:daemons)               { [] }

  if fetch(:daemons_default_hook)
    fetch(:daemons).each do |daemon|
      after 'deploy:restart', "daemon:#{daemon}:restart"
    end
  end

  def run_rake(task)
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake #{task}"
  end

  namespace :daemon do
    fetch(:daemons).each do |daemon|
      namespace daemon do
        desc "Status of daemon #{daemon}"
        task :status do
          run_rake "daemon:#{daemon}:status"
        end

        desc "Start daemon #{daemon}"
        task :start do
          run_rake "daemon:#{daemon}:start"
        end

        desc "Stop daemon #{daemon}"
        task :stop do
          run_rake "daemon:#{daemon}:stop"
        end

        desc "Restart daemon #{daemon}"
        task :restart do
          run_rake "daemon:#{daemon}:restart"
        end
      end
    end

  end
  namespace :daemons do
    desc "Status of daemons"
    task :status do
      run_rake 'daemons:status'
    end
    desc "Start all daemons"
    task :start do
      run_rake 'daemons:start'
    end
    desc "Stop all daemons"
    task :stop do
      run_rake 'daemons:stop'
    end
    desc "Stop then Start all daemons"
    task :restart do
      run_rake 'daemons:stop'
      run_rake 'daemons:start'
    end
  end
end
