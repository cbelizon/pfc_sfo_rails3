class AlterTicketPrice < ActiveRecord::Migration
  def up
  	change_column :match_generals, :ticket_price, :decimal, :precision => 12,
      :scale => 2
  end

  def down
    add_column :match_generals, :ticket_price, :decimal, :precision => 4,
      :scale => 2, :default => 0
  end
end
