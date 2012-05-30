class AddStateTeamsToLeague < ActiveRecord::Migration
  def self.up
    add_column :leagues, :state_teams, :integer, :default => 0
  end

  def self.down
    remove_column :leagues, :state_teams
  end
end
