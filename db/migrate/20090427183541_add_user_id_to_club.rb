class AddUserIdToClub < ActiveRecord::Migration
  def self.up
    add_column :clubs, :user_id, :integer
  end

  def self.down
    remove_column :clubs, :user_id
  end
end
