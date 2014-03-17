class AddReadWriteToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :read_right, :boolean, default: true
  	add_column :users, :write_right, :boolean, default: true
  end

  def self.down
  	remove_column :users, :read_right
  	remove_column :users, :write_right
  end
end
