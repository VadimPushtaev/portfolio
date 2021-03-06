lock '~> 3.11.0' # config valid for current version and patch releases of Capistrano

set :application, 'portfolio'
set :repo_url, 'git@github.com:sashotoster/portfolio.git'
set :user, 'webmaster'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :keep_releases, 3
set :ssh_options, forward_agent: true
set :format_options, log_file: 'log/capistrano.log'
set :npm_target_path, -> { release_path.join('client') }
set :bundle_jobs, 2 # Equals to amount of cores
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# append :linked_files, "config/database.yml"
append :linked_dirs, '.bundle', 'log', 'tmp', 'client/node_modules'

# Is bundle:install executed?
after 'deploy:published', 'deploy:compile'
after 'deploy:published', 'deploy:restart'
after 'deploy:finishing', 'bundler:clean'

namespace :deploy do
  desc 'Build React frontend client'
  task :compile do
    on roles(:all) do
      execute "cd #{release_path}/client; npm run-script build"
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:all) do
      execute 'sudo systemctl stop nginx'
      # Puma stop
      # Puma start
      execute 'sudo systemctl start nginx'
    end
  end

end

