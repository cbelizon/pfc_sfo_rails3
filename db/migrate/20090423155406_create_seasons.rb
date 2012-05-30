class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      t.integer :league_id, :null => false
      t.integer :date, :null => false
      t.integer :actual_round

      t.timestamps
    end
  end

  def self.down
    drop_table :seasons
  end
end
