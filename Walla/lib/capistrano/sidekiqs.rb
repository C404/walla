Capistrano::Configuration.instance.load do


  #_cset(:sidekiq_cmd)       { "#{fetch(:bundle_cmd, "bundle")} exec sidekiq" }
  #_cset(:sidekiqctl_cmd)    { "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl" }
  #_cset(:sidekiq_timeout)   { 10 }
  _cset(:sidekiq_default_hooks) { true }
  _cset(:sidekiq_role)          { :app }
  #_cset(:sidekiq_pid)       { "#{current_path}/tmp/pids/sidekiq.pid" }
  #_cset(:sidekiq_processes) { 1 }

  _cset(:sidekiqs_default) do
    {
      cmd:          "#{fetch(:bundle_cmd, "bundle")} exec sidekiq",
      ctl_cmd:      "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl",
      timeout:      10,
      queues:       [:default],
      nice:         0,
      pid:          "#{current_path}/tmp/pids/sidekiq-%{name}.pid",
      processes:    1,
      concurrency:  5
    }
  end

  if fetch(:sidekiq_default_hooks)
    before "deploy:update_code", "sidekiqs:quiet"
    after "deploy:stop",    "sidekiqs:stop"
    #after "deploy:start",   "sidekiqs:start"
    before "deploy:restart", "sidekiqs:restart"
  end

  namespace :sidekiqs do
    def for_each_process(&block)
      unique_index_offset = 0
      fetch(:sidekiqs).each do |name, config|
        config = {}.merge(fetch :sidekiqs_default).merge config
        config[:pid] = config[:pid] % { name: name }
        config[:processes].times do |idx|
          pid = (idx + unique_index_offset) == 0 ? "#{config[:pid]}" : "#{config[:pid]}-#{idx}"
          yield(pid, idx + unique_index_offset, name, config)
        end
        unique_index_offset += config[:processes]
      end
    end

    desc "Quiet sidekiq (stop accepting new work)"
    task :quiet, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
      for_each_process do |pid_file, idx, name, config|
        run "if [ -d #{current_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{current_path} && #{config[:ctl_cmd]} quiet #{pid_file} ; else echo 'Sidekiq [#{name}] is not running'; fi"
      end
    end

    desc "Stop sidekiq"
    task :stop, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
      for_each_process do |pid_file, idx, name, config|
        run "if [ -d #{current_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{current_path} && #{config[:ctl_cmd]} stop #{pid_file} #{config[:timeout]} ; else echo 'Sidekiq [#{name}] is not running'; fi"
      end
    end

    desc "Start sidekiq"
    task :start, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
      rails_env = fetch(:rails_env, "production")
      for_each_process do |pid_file, idx, name, config|
        queues = config[:queues].map { |q| "-q #{q}"}.join(' ')
        run "cd #{current_path} ; nohup nice -n #{config[:nice]} #{config[:cmd]} -e #{rails_env} -C #{current_path}/config/sidekiq-#{name}.yml -c #{config[:concurrency]} -i #{idx} -P #{pid_file} #{queues} >> #{current_path}/log/sidekiq-#{name}.log 2>&1 &", :pty => false
      end
    end

    desc "Restart sidekiq"
    task :restart, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
      stop
      start
    end

  end
end
