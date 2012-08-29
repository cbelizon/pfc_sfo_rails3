# == Schema Information
#
# Table name: rounds
#
#  id               :integer          not null, primary key
#  season_id        :integer          not null
#  number           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  state_simulation :boolean          default(FALSE)
#  start_time       :datetime
#

require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

