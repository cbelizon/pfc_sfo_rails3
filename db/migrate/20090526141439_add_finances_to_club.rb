class AddFinancesToClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :cash, :decimal, :precision => 16, :scale => 2,
      :default => 0
    add_column :clubs, :ticket_price, :decimal, :precision => 4, :scale => 2,
      :default => 0
  end

  def self.down
    remove_column :clubs, :cash
    remove_column :clubs, :ticket_price
  end
end
