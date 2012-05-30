class AddTacticToClubs < ActiveRecord::Migration
  def self.up
    add_column :clubs, :tactic, :string, :null => false, :default => "4-4-2"
  end

  def self.down
    remove_column :clubs, :tactic
  end
end
