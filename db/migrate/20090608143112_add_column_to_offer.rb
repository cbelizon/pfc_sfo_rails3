class AddColumnToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :pay, :decimal, :precision => 16, :scale => 2,
      :default => 0
  end

  def self.down
    remove_column :offers, :pay
  end
end
