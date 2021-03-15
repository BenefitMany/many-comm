# ##############################################################################################################
# # mina setup stage=production branch=master --verbose # create dir structure
# # mina deploy stage=production branch=master --verbose # deploy to production
# # mina deploy stage=staging branch=master --verbose # deploy to staging (assuming there is a staging branch)
# ##############################################################################################################

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/whenever'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)
Dir['./lib/mina/*.rb'].each { |mina_task| require mina_task }

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
#   shared_paths - Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
#                  They will be linked in the 'deploy:link_shared_paths' step.

set :stage,             ENV['stage']  || 'staging' # default to staging
set :branch,            ENV['branch'] || 'master'  # default to master branch
set :rails_env,         fetch(:stage)
set :user,              'www' # username used by ssh
set :repository,        'git@github.com:BenefitMany/many-comm.git'
set :deploy_to,         '/home/www/manycomm/www'
set :shared_dirs,       %w[tmp log public/csv_data public/uploads vendor batches daily_store]
set :shared_files,      %w[config/database.yml .foreman .env]
set :production_db,     'localhost'
set :production_domain, 'app.manycomm.io'
set :staging_domain,    'app-staging.manycomm.io'
set :application,       'ManyComm'

case fetch(:stage)
when 'production'
  set :domain, fetch(:production_domain)
when 'staging'
  set :domain, fetch(:staging_domain)
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  deploy do
    # invoke :environment
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'set_bundle_build_config'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    command 'yarn' # Install package.json dependencies
    command "NODE_ENV=#{fetch(:rails_env)} RAILS_ENV=#{fetch(:rails_env)} bundle exec rails webpacker:compile" # Run this here so we aren't committing compiled assests to git

    on :launch do
      command "touch #{fetch(:release_path)}/tmp/restart.txt"
      invoke :'whenever:update'
    end

    invoke :'deploy:cleanup'
  end
end

task :environment do
end
