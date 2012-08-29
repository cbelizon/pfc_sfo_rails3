# == Schema Information
#
# Table name: club_finances_rounds
#
#  id                 :integer          not null, primary key
#  club_id            :integer          not null
#  round_id           :integer          not null
#  cash               :decimal(16, 2)   default(0.0)
#  pays_players       :decimal(16, 2)   default(0.0)
#  pays_maintenance   :decimal(16, 2)   default(0.0)
#  pays_transfers     :decimal(16, 2)   default(0.0)
#  benefits_ticket    :decimal(16, 2)   default(0.0)
#  benefits_trademark :decimal(16, 2)   default(0.0)
#  benefits_transfers :decimal(18, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class ClubFinancesRoundTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

