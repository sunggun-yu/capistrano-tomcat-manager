#Capistrano Recipe for Tomcat Manager
This is the Capistrano Recipe for Tomcat Manager. and it support Tomcat 6 and 7.
##Supported Manager Commands.
<pre>
cap tomcat_manager:deploy     # Deploy A New Application Remotely
cap tomcat_manager:list       # List Currently Deployed Applications
cap tomcat_manager:reload     # Reload An Existing Application
cap tomcat_manager:serverinfo # List OS and JVM Properties
cap tomcat_manager:sessions   # Session Statistics
cap tomcat_manager:start      # Start Tomcat.
cap tomcat_manager:stop       # Stop Tomcat.
cap tomcat_manager:undeploy   # Undeploy an Existing Application
</pre>

##Settings.
Please add this settings in your Capfile.
<pre>
role :hosts, "host1", "host2"
set :port, "8080"
set :context_name, "app"
set :manager_user, "admin"
set :manager_pw, "password"
set :war_file, "/your/war/file.war"
set :tomcat_version, 7
</pre>