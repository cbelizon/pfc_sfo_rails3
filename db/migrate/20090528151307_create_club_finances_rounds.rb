class CreateClubFinancesRounds < ActiveRecord::Migration
  def self.up
    create_table :club_finances_rounds do |t|
      t.integer :club_id, :null => false
      t.integer :round_id, :null => false
      t.decimal :cash, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :pays_players, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :pays_maintenance, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :pays_transfers, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :benefits_ticket, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :benefits_trademark, :precision => 16, :scale => 2,
        :default => 0
      t.decimal :benefits_transfers, :precision => 18, :scale => 2,
        :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :club_finances_rounds
  end
end
