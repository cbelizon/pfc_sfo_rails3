class AddFinancesToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :pay, :decimal, :precision => 8, :scale => 2
    add_column :players, :clause, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :players, :clause
    remove_column :players, :pay
  end
end
