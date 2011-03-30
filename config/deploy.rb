# Must be set for the password prompt from git to work
default_run_options[:pty] = true

# The name of our application:
set :application, "cloud-k.dev"

# What user will connect to the remote server?
set :user, "nuvemk"

# Where is the repository ?
set :repository, "git@github.com:oikram/cloud-k.dev.git" # My clone url

# What is the domain on "production" side?
role :web, "dev.cloud-k.pt"

# Where should the files be deployed ?
set :deploy_to, "/home/nuvemk/webapps/dev/"

# Do we need sudo?
set :use_sudo, false

# What version control do we want to use?
set :scm, :git

# What password should I put here? Perhaps nothing since I'm using public keys?
#set :scm_passphrase, "alcap0ne"  

#If you’re using your own private keys for git you might want to tell Capistrano to use agent forwarding with this command. Agent forwarding can make key management much simpler as it uses your local keys instead of keys installed on the server
ssh_options[:forward_agent] = true

set :branch, 'master'

# Deploy via :remote_cache that will allow capistrano to deploy ONLY the last commits, instead of transfer the all project.
set :deploy_via, :remote_cache

# Create a task (named create_symlinks) that removes /public/.htaccess from our development environement, that has: SetEnv APPLICATION_ENV development and, change it by another .htaccess file prepared for production.
task :create_symlinks, :roles => :web do
run "rm #{current_release}/public/.htaccess"
run "ln -s #{current_release}/production/.htaccess
#{current_release}/public/.htaccess"
end

# Call our task at the end:
after "deploy:finalize_update", :create_symlinks
