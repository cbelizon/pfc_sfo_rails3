class AddPositionToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :position, :integer
  end

  def self.down
    remove_column :players, :position
  end
end
