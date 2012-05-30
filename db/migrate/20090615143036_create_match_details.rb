class CreateMatchDetails < ActiveRecord::Migration
  def self.up
    create_table :match_details do |t|
      t.integer :player_id, :null => false
      t.integer :club_id, :null => false
      t.integer :match_general_id, :null => false
      t.string :action, :null => false
      t.integer :minute, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :match_details
  end
end
