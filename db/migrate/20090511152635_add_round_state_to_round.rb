class AddRoundStateToRound < ActiveRecord::Migration
  def self.up
    add_column :rounds, :state_simulation, :boolean, :default => false
  end

  def self.down
    remove_column :rounds, :state
  end
end
