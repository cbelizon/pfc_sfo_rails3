class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name, :limit => 20, :null => false
      t.string :surname, :limit => 30, :null => false
      t.integer :quality, :null => false
      #t.integer :age, :null => false
      t.integer :club_id, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
