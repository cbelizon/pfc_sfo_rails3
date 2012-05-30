class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :name, :limit => 30, :null => false
      t.string :stadium_name, :limit => 40, :null => false
      t.integer :stadium_capacity, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
