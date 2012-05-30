class AddSeasonIdToClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :season_id, :integer
  end

  def self.down
    remove_column :clubs, :season_id
  end
end
