require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: offers
#
#  id         :integer         not null, primary key
#  club_id    :integer         not null
#  player_id  :integer         not null
#  buyer_id   :integer         not null
#  state      :integer         default(0)
#  created_at :datetime
#  updated_at :datetime
#  pay        :decimal(16, 2)  default(0.0)
#

