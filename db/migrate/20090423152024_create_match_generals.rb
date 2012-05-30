class CreateMatchGenerals < ActiveRecord::Migration
  def self.up
    create_table :match_generals do |t|
      t.integer :local_id, :null => false
      t.integer :guest_id, :null => false
      t.integer :local_goals
      t.integer :guest_goals
      t.integer :round_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :match_generals
  end
end
