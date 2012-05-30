require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: players
#
#  id         :integer         not null, primary key
#  name       :string(20)      not null
#  surname    :string(30)      not null
#  quality    :integer         not null
#  club_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  pay        :decimal(8, 2)
#  clause     :decimal(8, 2)
#  speed      :integer         default(0), not null
#  resistance :integer         default(0), not null
#  dribbling  :integer         default(0), not null
#  kick       :integer         default(0), not null
#  pass       :integer         default(0), not null
#  recovery   :integer         default(0), not null
#  goalkeeper :integer         default(0), not null
#  position   :integer
#

