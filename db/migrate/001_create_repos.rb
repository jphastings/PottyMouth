class CreateRepos < ActiveRecord::Migration
  def self.up
    create_table :repos do |table|
      table.string :name
      table.string :user
      table.string :repo_hash
      table.timestamps
    end
  end
  
  def self.down
    drop_table :repos
  end
end