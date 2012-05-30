class AddSpectatorsToMatchGeneral < ActiveRecord::Migration
  def self.up
    add_column :match_generals, :spectators, :integer, :default => 0
  end

  def self.down
    remove_column :match_generals, :spectators
  end
end
