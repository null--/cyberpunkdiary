class AddHitsToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :hits, :integer, :default => 0
  end

  def self.down
    remove_column :articles, :hits
  end
end
