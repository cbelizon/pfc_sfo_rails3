class RemoveForeignKeyFromClub < ActiveRecord::Migration
  def self.up
    remove_column :clubs, :season_id
  end

  def self.down
    add_column :clubs, :season_id, :integer
  end
end
