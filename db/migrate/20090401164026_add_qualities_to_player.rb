class AddQualitiesToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :speed, :integer, :default => 0, :null => false
    add_column :players, :resistance, :integer, :default => 0, :null => false
    add_column :players, :dribbling, :integer, :default => 0, :null => false
    add_column :players, :kick, :integer, :default => 0, :null => false
    add_column :players, :pass, :integer, :default => 0, :null => false
    add_column :players, :recovery, :integer, :default => 0, :null => false
    add_column :players, :goalkeeper, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :players, :goalkeeper
    remove_column :players, :recovery
    remove_column :players, :pass
    remove_column :players, :kick
    remove_column :players, :dribbling
    remove_column :players, :resistance
    remove_column :players, :speed
  end
end
