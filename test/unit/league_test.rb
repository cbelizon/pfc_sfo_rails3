require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: leagues
#
#  id          :integer         not null, primary key
#  category    :integer         default(1), not null
#  created_at  :datetime
#  updated_at  :datetime
#  state_teams :integer         default(0)
#

