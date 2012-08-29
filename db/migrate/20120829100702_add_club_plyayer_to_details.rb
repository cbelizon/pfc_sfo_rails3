class AddClubPlyayerToDetails < ActiveRecord::Migration
  def change
  	add_column :match_details, :club_string, :string
  	add_column :match_details, :player_string, :string
  end
end
