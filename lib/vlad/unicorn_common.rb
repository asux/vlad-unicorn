require 'vlad'

module Vlad
  module Unicorn
    VERSION = '2.1.1' #:nodoc:

    # Runs +cmd+ using sudo if the +:unicorn_use_sudo+ variable is set.
    def self.maybe_sudo(cmd)
      if unicorn_use_sudo
        sudo cmd
      else
        run cmd
      end
    end

    def self.signal(signals = ['0'])
      cmd = [%(test -s "#{unicorn_pid}")]
      signals.each do |sig|
        cmd << %(kill -#{sig} `cat "#{unicorn_pid}"`)
      end
      cmd.join(" && ")
    end

    # Use *:unicorn_reload_signals* variable for set custom signals.
    def self.start(opts = '')
      cmd = signal(unicorn_reload_signals)
      cmd << %( || (cd #{current_path} && #{unicorn_command} -D -E #{unicorn_env} -c #{unicorn_config} #{opts}))
      maybe_sudo %(sh -c '#{cmd}')
    end

    def self.stop
      cmd = signal('QUIT')
      cmd << %( || echo "stale pid file #{unicorn_pid}")
      maybe_sudo %(sh -c '#{cmd}')
    end
  end
end

namespace :vlad do
  set :unicorn_command,          "unicorn"
  set(:unicorn_config)           { "#{current_path}/config/unicorn.rb" }
  set :unicorn_use_sudo,         false
  set(:unicorn_pid)              { "#{shared_path}/pids/unicorn.pid" }
  set(:unicorn_env)              { rails_env || "development" }
  set :unicorn_reload_signals,   ['HUP']

  desc "Stop the app servers"
  remote_task :stop_app, :roles => :app do
    Vlad::Unicorn.stop
  end
end
