class CreateSwears < ActiveRecord::Migration
  def self.up
    create_table :swears do |table|
      table.integer :repo_id
      table.string  :swear
      table.integer :count, :default => 0, :null => false
    end
  end
  
  def self.down
    drop_table :swears
  end
end