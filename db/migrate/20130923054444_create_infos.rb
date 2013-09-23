class CreateInfos < ActiveRecord::Migration
  def self.up
    create_table :infos do |t|
      t.string :title
      t.string :about
      t.string :bug_report
      t.integer :total_hits

      t.timestamps
    end
  end

  def self.down
    drop_table :infos
  end
end
