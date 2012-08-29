# == Schema Information
#
# Table name: admin_messages
#
#  id          :integer          not null, primary key
#  text_msg_es :string(255)      not null
#  text_msg_en :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class AdminMessagesTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end



