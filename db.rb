require 'rubygems'
require 'active_record'

dbconfig = YAML::load(File.open('config/database.yml'))

ActiveRecord::Base.establish_connection dbconfig[ENV['ENVIRONMENT'] || 'production']

class Swear < ActiveRecord::Base
end