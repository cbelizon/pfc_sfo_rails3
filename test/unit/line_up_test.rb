# == Schema Information
#
# Table name: line_ups
#
#  id               :integer          not null, primary key
#  club_id          :integer          not null
#  match_general_id :integer          not null
#  player_id        :integer          not null
#  position         :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class LineUpTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

