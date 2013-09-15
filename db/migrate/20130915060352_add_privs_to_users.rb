class AddPrivsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :priv, :integer, :default => 0
  end

  def self.down
    remove_column :users, :priv
  end
end
