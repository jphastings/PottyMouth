desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  require 'active_record'
  require 'yaml'
  
  dbconfig = YAML::load(File.open('config/database.yml'))

  ActiveRecord::Base.establish_connection dbconfig[ENV['ENVIRONMENT'] || 'production']
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  
end

desc "Perform Cron tasks"
task :cron => :environment do
  
end