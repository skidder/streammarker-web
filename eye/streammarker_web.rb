# Adding application
module GCONFIG
  # All options inherits down to the config leafs.
  # except `env`, which merging down

  ROOT_PATH    = "/opt/streammarker-web/"
  CURRENT_PATH = File.join(ROOT_PATH, "current")
  SHARED_PATH  = File.join(ROOT_PATH, "shared")
  LOG_PATH     = File.join(SHARED_PATH, "log")
  PIDS_PATH    = File.join(SHARED_PATH, "pids")

  def self.root_path(file=nil)
    File.join(*[ROOT_PATH, file].compact)
  end

  def self.current_path(file=nil)
    File.join(*[CURRENT_PATH, file].compact)
  end

  def self.shared_path(file=nil)
    File.join(*[SHARED_PATH, file].compact)
  end

  def self.log_path(file=nil)
    File.join(*[LOG_PATH, file].compact)
  end

  def self.pids_path(file=nil)
    File.join(*[PIDS_PATH, file].compact)
  end
end

Eye.application "streammarker_web" do
  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))
  stdall 'trash.log' # stdout,err logs for processes by default

  env 'APP_ENV' => 'production' # global env for each processes
  env 'RAILS_ENV' => 'production'
  env 'STREAMMARKER_WEB_LISTEN_PORT' => ':3000'
  env 'AWS_REGION' => 'us-east-1'

  trigger :flapping, times: 5, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  group 'server' do
    process(:redis) do
      working_dir GCONFIG.current_path
      uid "ec2-user"
      gid "ec2-user"
      daemonize true
      start_command "/usr/local/bin/redis-server"
      pid_file GCONFIG.pids_path("redis_server.pid")
      stdall GCONFIG.log_path("redis_server_output.log")
      stop_signals [:QUIT, 2.seconds, :TERM, 1.seconds, :KILL]

      check :socket, addr: 'tcp://127.0.0.1:6379',
                     every: 5.seconds, times: [2, 3], timeout: 1.second
    end

    process(:streammarker_web_server) do
      working_dir GCONFIG.current_path
      uid "ec2-user"
      gid "ec2-user"
      daemonize true
      start_command "bundle exec puma -C config/puma.rb"
      pid_file GCONFIG.pids_path("streammarker_web_server.pid")
      stdall GCONFIG.log_path("streammarker_web_server_output.log")
      stop_signals [:QUIT, 2.seconds, :TERM, 1.seconds, :KILL]

      check :http, url: 'http://127.0.0.1:3000/',
                   kind: 301,
                   every: 5.seconds, times: [2, 3], timeout: 1.second
    end
  end
end
