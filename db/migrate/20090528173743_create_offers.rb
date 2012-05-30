class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.integer :club_id, :null => false
      t.integer :player_id, :null => false
      t.integer :buyer_id, :null => false
      t.integer :state, :null => false, :default => 0


      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
