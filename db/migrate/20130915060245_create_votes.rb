class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :score, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
