# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/vendor"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/vendor"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/log"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/csv_data"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/csv_data"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/uploads"]

  command %[touch "#{fetch(:deploy_to)}/shared/config/database.yml"]
  command  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  command %[touch "#{fetch(:deploy_to)}/shared/.env"]
  command "echo -e 'RAILS_ENV=#{fetch(:stage)}\nRACK_ENV=#{fetch(:stage)}' > #{fetch(:deploy_to)}/shared/.env"

  command %[touch "#{fetch(:deploy_to)}/shared/.foreman"]
  command "echo -e 'formation: worker=1, worker_backup=1, scheduler=1' > #{fetch(:deploy_to)}/shared/.foreman"

  command %[touch "#{fetch(:deploy_to)}/shared/.foreman"]
  case fetch(:stage)
  when 'production'
    command "echo -e 'formation: worker=1, worker_system=1, scheduler=1' > #{fetch(:deploy_to)}/shared/.foreman"
  when 'staging'
    command "echo -e 'formation: worker=1, worker_system=1, scheduler=1' > #{fetch(:deploy_to)}/shared/.foreman"
  end
end
