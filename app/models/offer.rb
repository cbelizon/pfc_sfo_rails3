class Offer < ActiveRecord::Base
  PENDING = 0
  ACCEPTED = 1
  REJECTED = 2
  TRANSFERED = 3
  CANCEL = 4
  validate :buyer_must_have_cash
  validate :buyer_must_be_under_max_players
  validate :seller_must_be_over_min_players
  validates_presence_of :state
  validates_presence_of :pay
  validates_numericality_of :pay
  validates_uniqueness_of  :state, :scope => [:player_id, :buyer_id],
    :if => :pending?, :message => I18n.translate("offer.error_previous_offer")
  belongs_to :seller, :class_name => 'Club', :foreign_key => :club_id
  belongs_to :buyer, :class_name => 'Club'
  belongs_to :player
  scope :pending, :order => 'updated_at DESC ',
    :conditions => {:state => PENDING}
  scope :accepted, :order => 'updated_at DESC',
    :conditions => {:state => ACCEPTED}
  scope :rejected, :order => 'updated_at DESC',
    :conditions => {:state => REJECTED}
  scope :transfered, :order => 'updated_at DESC',
    :conditions => {:state => TRANSFERED}
  attr_accessible :seller, :buyer, :player

  #Add error not enough cash
  def buyer_must_have_cash
    if self.buyer.cash < self.player.clause
      self.errors.add_to_base('The buyer have not enough cash')
    end
  end

  #Add error max player overpassed
  def buyer_must_be_under_max_players
    if self.buyer.maximum_players?
      self.errors.add_to_base('The buyer has the maximum players in the team')
    end
  end

  #Add error minimum players needed
  def seller_must_be_over_min_players
    if self.seller.minimum_players?
      self.errors.add_to_base('You have the minimum players in the team')
    end
  end

  #Set to ACEPTED the offer and set to REJECTED others offers for the player
  def accept
    if self.valid?
      Offer.find_all_by_player_id(self.player_id).
        each {|offer| offer.update_attribute(:state, REJECTED)}
      self.update_attribute(:state, ACCEPTED)
      self.update_attribute(:pay, self.player.clause)
    end
  end

  #Set to REJECTED the offer
  def reject
    self.update_attribute(:state, REJECTED)
  end

  #Set to TRANSFERED the offer
  def transfered
    self.update_attribute(:state, TRANSFERED)
  end

  def cancel
    self.update_attribute(:state, CANCEL)
  end

  #Return true if the state of the offer is PENDING
  def pending?
    self.state == PENDING
  end

  #Return true if the state of the offer is CANCEL
  def cancel?
    self.state == CANCEL
  end

  #Return true if the state of the offer is REJECTED
  def rejected?
    self.state == REJECTED
  end

  #Return true if the state of the offer is ACCEPTED
  def accepted?
    self.state == ACCEPTED
  end

  #Return true if the state of the offer is TRANSFERED
  def transfered?
    self.state == TRANSFERED
  end
end


# == Schema Information
#
# Table name: offers
#
#  id         :integer         not null, primary key
#  club_id    :integer         not null
#  player_id  :integer         not null
#  buyer_id   :integer         not null
#  state      :integer         default(0)
#  created_at :datetime
#  updated_at :datetime
#  pay        :decimal(16, 2)  default(0.0)
#

