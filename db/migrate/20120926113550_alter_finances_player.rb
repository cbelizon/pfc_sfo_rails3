class AlterFinancesPlayer < ActiveRecord::Migration
  def up
  	change_column :players, :pay, :decimal, :precision => 12, :scale => 2
  	change_column :players, :clause, :decimal, :precision => 12, :scale => 2
  end

  def down
  	change_column :players, :pay, :decimal, :precision => 8, :scale => 2
  	change_column :players, :clause, :decimal, :precision => 8, :scale => 2
  end
end
