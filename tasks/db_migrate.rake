namespace :db do
  task :default => :migrate
	 
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

   desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
   task :rollback => :environment do
     step = ENV['STEP'] ? ENV['STEP'].to_i : 1
     ActiveRecord::Migrator.rollback 'db/migrate', step
   end 

  task :environment do
    ActiveRecord::Base.establish_connection(YAML::load_file('config/database.yml'))
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
  end


end