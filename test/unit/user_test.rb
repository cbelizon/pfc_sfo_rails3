# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  login             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  login_count       :integer
#  last_request_at   :datetime
#  last_login_at     :datetime
#  current_login_at  :datetime
#  last_login_ip     :string(255)
#  current_login_ip  :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  admin             :boolean
#  email             :string(255)      default(""), not null
#  prefer_lang       :string(255)      default("en")
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


