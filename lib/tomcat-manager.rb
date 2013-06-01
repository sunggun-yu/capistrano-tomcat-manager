Capistrano::Configuration.instance.load do
  namespace :tomcat_manager do
    desc "Capistrano Recipe for Tomcat Manager"
    desc "Stop Tomcat."
    task :stop, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_for_app(srv, "stop")
      end
    end

    desc "Start Tomcat."
    task :start, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_for_app(srv, "start")
      end
    end

    desc "Reload An Existing Application"
    task :reload, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_for_app(srv, "reload")
      end
    end

    desc "Undeploy an Existing Application"
    task :undeploy, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_for_app(srv, "undeloy")
      end
    end

    desc "Deploy A New Application Remotely"
    task :deploy, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      tomcat_manager_path = get_tomcat_manager_path()
      servers.each do |srv|
        _command = "curl --user #{manager_user}:#{manager_pw} --upload-file #{war_file} http://#{srv}:#{port}/#{tomcat_manager_path}/deploy?path=/#{context_name}&update=true"
        result = %x[#{_command}]
        puts "deploy : #{s} : #{result}"
      end
    end

    desc "Session Statistics"
    task :sessions, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_for_app(srv, "sessions")
      end
    end

    desc "List Currently Deployed Applications"
    task :list, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_simple(srv, "list")
      end
    end

    desc "List OS and JVM Properties"
    task :serverinfo, :roles => :hosts do
      servers = find_servers_for_task(current_task)
      servers.each do |srv|
        call_tomcat_manager_simple(srv, "serverinfo")
      end
    end
  end

  def call_tomcat_manager(host_name, manager_function, path)
    if path.length > 0
      _path = "?path=/#{path}"
    end
    tomcat_manager_path = get_tomcat_manager_path()
    _command = "curl --user #{manager_user}:#{manager_pw} http://#{host_name}:#{port}/#{tomcat_manager_path}/#{manager_function}#{_path}"
    result = %x[#{_command}]
    puts "#{manager_function} : #{host_name} : #{result}"
  end

  def call_tomcat_manager_for_app(host_name, manager_function)
    call_tomcat_manager(host_name, manager_function, "#{context_name}")
  end

  def call_tomcat_manager_simple(host_name, manager_function)
    call_tomcat_manager(host_name, manager_function, "")
  end

  def get_tomcat_manager_path
    if tomcat_version == 7
      return "manager/text"
    else
      return "manager"
    end
  end
end