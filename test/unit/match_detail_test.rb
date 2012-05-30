require 'test_helper'

class MatchDetailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: match_details
#
#  id               :integer         not null, primary key
#  player_id        :integer         not null
#  club_id          :integer         not null
#  match_general_id :integer         not null
#  action           :string(255)     not null
#  minute           :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#

