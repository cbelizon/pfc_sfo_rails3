# == Schema Information
#
# Table name: match_details
#
#  id               :integer          not null, primary key
#  player_id        :integer          not null
#  club_id          :integer          not null
#  match_general_id :integer          not null
#  action           :string(255)      not null
#  minute           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  club_string      :string(255)
#  player_string    :string(255)
#

class MatchDetail < ActiveRecord::Base

  ACTION_HALF_TIME = 'action.half_time'
  ACTION_GOAL = 'action.goal'
  ACTION_ERROR = 'action.error'
  ACTION_TO_CLEAR = 'action.to_clear'
  ACTION_OUT = 'action.out'
  ACTION_PASS = 'action.pass'
  ACTION_KICK = 'action.kick'
  ACTION_DRIBBLING = 'action.dribbling'
  ACTION_SPECTACULAR_PASS = 'action.spectacular_pass'
  ACTION_SPECTACULAR_DRIBBLING = 'action.spectacular_dribbling'
  ACTION_SHOOT = 'action.shoot'
  ACTION_WOOD = 'action.wood'
  ACTION_DANGEROUS = 'action.dangerous'
  ACTION_WRONG_PASS = 'action.wrong_pass'

  ACTIONS_PLAY = [
    ACTION_ERROR,
    ACTION_TO_CLEAR,
    ACTION_TO_CLEAR,
    ACTION_OUT,
    ACTION_PASS,
    ACTION_DRIBBLING,
    ACTION_KICK,
    ACTION_SPECTACULAR_PASS,
    ACTION_SPECTACULAR_DRIBBLING,
    ACTION_SHOOT,
    ACTION_WOOD,
    ACTION_DANGEROUS,
    ACTION_WRONG_PASS,
    ACTION_GOAL
  ]
  before_validation :save_attributes
  belongs_to :player
  belongs_to :club
  belongs_to :match, :class_name => 'MatchGeneral',
    :foreign_key => :match_general_id
  validates_presence_of :action
  validates_presence_of :minute
  validates_numericality_of :minute
  scope :goals, :conditions => {:action => ACTION_GOAL}
  scope :first_time, :conditions => {:minute =>
      (0..MatchGeneral::PARTS_TIME)}, :order => "minute asc"
  scope :second_time, :conditions => {:minute =>
      (MatchGeneral::PARTS_TIME..MatchGeneral::MINUTES)}, :order => "minute asc"
  attr_accessible :club, :player, :action, :minute, :player_string, :club_string

  def <=>(other)
    self.minute <=> other.minute
  end

  def season
    self.match.round.season.date
  end

  def round
    self.match.round
  end

  private
  def save_attributes
    self.club_string = self.club.name
    self.player_string = self.player.complete_name
  end
end

