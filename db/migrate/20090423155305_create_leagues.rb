class CreateLeagues < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.integer :category, :null => false, :default => 1
      t.integer

      t.timestamps
    end
  end

  def self.down
    drop_table :leagues
  end
end
