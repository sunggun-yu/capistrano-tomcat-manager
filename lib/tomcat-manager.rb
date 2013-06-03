Capistrano::Configuration.instance.load do
  desc "Capistrano Recipe for Tomcat Manager"
  namespace :tomcat_manager do
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
        _command = get_tomcat_manager_url_for_deploy(srv)
        run_command(_command, "deploy", srv)
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

  desc "Get Tomcat manager url"
  def get_tomcat_manager_url(host_name, manager_function, path)
    if path.length > 0
      _path = "?path=/#{path}"
    end
    tomcat_manager_path = get_tomcat_manager_path()
    return "curl --user #{manager_user}:#{manager_pw} http://#{host_name}:#{port}/#{tomcat_manager_path}/#{manager_function}#{_path}"
  end

  desc "Get Tomcat manager url for Deploy"
  def get_tomcat_manager_url_for_deploy(host_name)
    tomcat_manager_path = get_tomcat_manager_path()
    return "curl --user #{manager_user}:#{manager_pw} --upload-file #{war_file} http://#{srv}:#{port}/#{tomcat_manager_path}/deploy?path=/#{context_name}&update=true"
  end

  desc "Call Tomcat manager url which is including path parameter"
  def call_tomcat_manager_for_app(host_name, manager_function)
    _command = get_tomcat_manager_url(host_name, manager_function, "#{context_name}")
    run_command(_command, manager_function, host_name)
  end

  desc "Call Tomcat manager url which is not including path parameter"
  def call_tomcat_manager_simple(host_name, manager_function)
    _command = get_tomcat_manager_url(host_name, manager_function, "")
    run_command(_command, manager_function, host_name)
  end
  
  desc "Command Runner"
  def run_command(command, manager_function, hostname) 
    result = %x[#{command}]
    puts "#{manager_function} : #{hostname} : #{result}"
  end

  desc "Get Tocmat manager context from the given version"
  def get_tomcat_manager_path
    if tomcat_version == 7
      return "manager/text"
    else
      return "manager"
    end
  end
end