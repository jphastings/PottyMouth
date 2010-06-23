require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[ENV['ENVIRONMENT'] || 'development'])

class Repo < ActiveRecord::Base
  has_many :swears
end

class Swear < ActiveRecord::Base
  belongs_to :repo
end