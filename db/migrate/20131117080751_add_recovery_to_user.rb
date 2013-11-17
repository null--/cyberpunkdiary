class AddRecoveryToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :recov_qst, :string
    add_column :users, :recov_ans, :string
  end

  def self.down
    remove_column :users, :recov_ans
    remove_column :users, :recov_qst
  end
end
