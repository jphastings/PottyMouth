require 'rubygems'
require 'active_record'

dbconfig = YAML::load(File.open('config/database.yml'))

ActiveRecord::Base.establish_connection dbconfig[ENV['ENVIRONMENT'] || 'production']
#ActiveRecord::Base.logger = Logger.new(STDOUT)
#ActiveRecord::Base.colorize_logging = false

class Swear < ActiveRecord::Base
end