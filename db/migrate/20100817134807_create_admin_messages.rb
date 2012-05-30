class CreateAdminMessages < ActiveRecord::Migration
  def self.up
    create_table :admin_messages do |t|
      t.string :text_msg_es, :null => false
      t.string :text_msg_en, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_messages
  end
end
