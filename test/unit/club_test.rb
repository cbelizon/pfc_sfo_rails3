require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: clubs
#
#  id               :integer         not null, primary key
#  name             :string(30)      not null
#  stadium_name     :string(40)      not null
#  stadium_capacity :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  cash             :decimal(16, 2)  default(0.0)
#  ticket_price     :decimal(4, 2)   default(0.0)
#  tactic           :string(255)     default("4-4-2"), not null
#

