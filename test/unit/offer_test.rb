# == Schema Information
#
# Table name: offers
#
#  id         :integer          not null, primary key
#  club_id    :integer          not null
#  player_id  :integer          not null
#  buyer_id   :integer          not null
#  state      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pay        :decimal(16, 2)   default(0.0)
#

require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

