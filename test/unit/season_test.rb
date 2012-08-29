# == Schema Information
#
# Table name: seasons
#
#  id           :integer          not null, primary key
#  league_id    :integer          not null
#  date         :integer          not null
#  actual_round :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  season_state :integer          default(0), not null
#

require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

