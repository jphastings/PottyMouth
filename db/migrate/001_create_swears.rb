class CreateSwears < ActiveRecord::Migration
  def self.up
    create_table :swears do |table|
      table.string  :repo
      table.string  :user
      table.string  :swear
      table.integer :count, :default => 0, :null => false
      
      table.timestamps
    end
  end
  
  def self.down
    drop_table :swears
  end
end