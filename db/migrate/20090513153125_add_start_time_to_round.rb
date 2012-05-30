class AddStartTimeToRound < ActiveRecord::Migration
  def self.up
    add_column :rounds, :start_time, :datetime, :null => true
  end

  def self.down
    remove_column :rounds, :start_time
  end
end
