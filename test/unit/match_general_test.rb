# == Schema Information
#
# Table name: match_generals
#
#  id           :integer          not null, primary key
#  local_id     :integer          not null
#  guest_id     :integer          not null
#  local_goals  :integer
#  guest_goals  :integer
#  round_id     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  spectators   :integer          default(0)
#  ticket_price :decimal(4, 2)    default(0.0)
#

require 'test_helper'

class MatchGeneralTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

