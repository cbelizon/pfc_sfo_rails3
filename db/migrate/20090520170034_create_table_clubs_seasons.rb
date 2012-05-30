class CreateTableClubsSeasons < ActiveRecord::Migration
  def self.up
    create_table :clubs_seasons, :id => false do |t|
      t.integer :club_id
      t.integer :season_id
    end
  end

  def self.down
    drop_table :clubs_seasons
  end
end
