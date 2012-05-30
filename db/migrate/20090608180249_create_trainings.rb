class CreateTrainings < ActiveRecord::Migration
  def self.up
    create_table :trainings do |t|
      t.integer :player_id, :null => false
      t.string :ability, :null => false
      t.integer :improvement
      t.integer :round_count

      t.timestamps
    end
  end

  def self.down
    drop_table :trainings
  end
end
