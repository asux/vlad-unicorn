require 'vlad'

module Vlad
  module Unicorn
    VERSION = '2.0.0' #:nodoc:

    # Runs +cmd+ using sudo if the +:merb_use_sudo+ variable is set.
    def self.maybe_sudo(cmd)
      if unicorn_use_sudo
        sudo cmd
      else
        run cmd
      end
    end
  end
end

namespace :vlad do

  set :unicorn_command,     "unicorn"
  set :unicorn_environment, "production"
  set(:unicorn_config)      { "#{current_path}/config/unicorn.rb" }
  set :unicorn_use_sudo,    false
  set :unicorn_prefix,      nil
  set(:unicorn_pid)         { "#{shared_path}/pids/unicorn.pid" }

  def unicorn(opts = '')
    cmd = "#{unicorn_command} -D --config-file #{unicorn_config}"
    cmd << " --env #{unicorn_environment}"
    cmd << " --path #{unicorn_prefix}" if unicorn_prefix
    cmd << " #{opts}"
    cmd
  end

  desc "Stop the app servers"
  remote_task :stop_app, :roles => :app do
    Vlad::Unicorn.maybe_sudo %Q(sh -c 'if [ -f '\''#{unicorn_pid}'\'' ]; then kill `cat #{unicorn_pid}`; fi')
  end

end
