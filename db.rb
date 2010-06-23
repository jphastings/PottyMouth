require 'rubygems'
require 'active_record'

dbconfig = YAML::load(File.open('config/database.yml'))

ActiveRecord::Base.establish_connection dbconfig[ENV['ENVIRONMENT'] || 'production']

class Repo < ActiveRecord::Base
  has_many :swears
end

class Swear < ActiveRecord::Base
  belongs_to :repo
end