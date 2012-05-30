class AdminMessages < ActiveRecord::Base
	attr_accessible :text_msg_es, :text_msg_en

	def self.last_spanish
		AdminMessages.last.text_msg_es
	end

	def self.last_english
		AdminMessages.last.text_msg_en
	end
end





# == Schema Information
#
# Table name: admin_messages
#
#  id          :integer         not null, primary key
#  text_msg_es :string(255)     not null
#  text_msg_en :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#
