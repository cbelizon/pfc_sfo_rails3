class AddPriceTicketToMatchGeneral < ActiveRecord::Migration
  def self.up
    add_column :match_generals, :ticket_price, :decimal, :precision => 4,
      :scale => 2, :default => 0
  end

  def self.down
    remove_column :match_generals, :ticket_price
  end
end
