class CreateLineUps < ActiveRecord::Migration
  def self.up
    create_table :line_ups do |t|
      t.integer :club_id, :null => false
      t.integer :match_general_id, :null => false
      t.integer :player_id, :null => false
      t.integer :position, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :line_ups
  end
end
