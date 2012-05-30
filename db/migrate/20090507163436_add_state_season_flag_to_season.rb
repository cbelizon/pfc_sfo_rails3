class AddStateSeasonFlagToSeason < ActiveRecord::Migration
  def self.up
    add_column :seasons, :season_state, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :seasons, :season_state
  end
end
