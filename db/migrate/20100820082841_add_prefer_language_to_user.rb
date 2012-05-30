class AddPreferLanguageToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :prefer_lang, :string, :default => :en
  end

  def self.down
    remove_column :users, :prefer_lang
  end
end
