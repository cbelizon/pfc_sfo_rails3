require 'test_helper'

class TrainingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: trainings
#
#  id          :integer         not null, primary key
#  player_id   :integer         not null
#  ability     :string(255)     not null
#  improvement :integer
#  round_count :integer
#  created_at  :datetime
#  updated_at  :datetime
#

