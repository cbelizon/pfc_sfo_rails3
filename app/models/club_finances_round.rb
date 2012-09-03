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

class ClubFinancesRound < ActiveRecord::Base
  validates_presence_of :club_id
  validates_presence_of :round_id
  belongs_to :club
  belongs_to :round
  attr_accessible :club, :round, :cash, :pays_players, :pays_maintenance, :pays_transfers, :benefits_ticket, :benefits_transfers
  BENEFITS = ['benefits_ticket', 'benefits_transfers']
  PAYS = ['pays_maintenance', 'pays_transfers', 'pays_players']

  #Returns all benefits
  def all_benefits
    self.benefits_ticket + self.benefits_trademark + self.benefits_transfers
  end

  #Returns all pays
  def all_pays
    self.pays_maintenance + self.pays_players + self.pays_transfers
  end

  #Returns the balance between pays and benefits
  def balance
    self.all_benefits - self.all_pays
  end
end

