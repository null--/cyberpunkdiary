class AddScoreToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :leet, :integer, :default => 0
    add_column :articles, :lame, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :lame
    remove_column :articles, :leet
  end
end
