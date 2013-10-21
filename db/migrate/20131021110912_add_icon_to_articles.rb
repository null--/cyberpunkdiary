class AddIconToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :icon, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :icon
  end
end
