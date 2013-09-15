class AddUseridArticleidToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :article_id, :reference
    add_column :votes, :user_id, :reference
  end

  def self.down
    remove_column :votes, :user_id
    remove_column :votes, :article_id
  end
end
