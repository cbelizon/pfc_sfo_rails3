class Round < ActiveRecord::Base
  DIV_TO_MIN = 60
  belongs_to :season
  has_many :match_generals
  has_many :club_finances_rounds
  validates_presence_of :number
  validates_numericality_of :number
  attr_accessible :number, :state_simulation, :match_generals

  #return true if the round is in play
  def in_play?
    unless self.start_time.nil?
      if self.start_time <= Time.now and Time.now <= self.start_time + MatchGeneral::TIME_MATCH
        return true
      else
        return false
      end
    end
    return false
  end

  #return the minute of the actual round
  def minute
    (Time.now - self.start_time) / DIV_TO_MIN if self.in_play?
  end

  #return true if the round has been finished
  def finished?
    return self.start_time + MatchGeneral::TIME_MATCH < Time.now  unless
    self.start_time.nil?
    return false
  end

  #return true if the round is not started
  def not_started?
    return self.start_time > Time.now unless self.start_time.nil?
    return true
  end

  #return true if the round is simulated
  def simulated?
    self.state_simulation
  end

  #returns the state of the simulation of round
  def state_simulation_str
    if self.state_simulation
      return "round.state.simulated"
    else
      return "round.state.not_simulated"
    end
  end

  #returns the state of the round simulated
  def state_round_str
    if self.not_started?
      return "round.state.not_started"
    end

    if self.in_play?
      return "round.state.in_play"
    end

    if self.finished?
      return "round.state.finished"
    end
  end

  #return the match that play the club
  def get_match(club)
    self.match_generals.each do |m|
      if m.local == club || m.guest(club)
        return m
      end
    end
  end

  #play all match of the round
  def simulate_matchs!
    self.match_generals.each do |match|
      match.simulate
      match.save!
    end

    self.state_simulation = true
    self.save!
  end

  #set the start time at now
  def play!
    self.start_time = Time.now
    self.save!
  end

  def previous
    if !self.first?
      Round.find(:first, :conditions => {:season_id => self.season, :number => self.number - 1})
    else
      self
    end
  end

  def next
    if !self.last?
      Round.find(:first, :conditions => {:season_id => self.season, :number => self.number + 1})
    else
      self
    end
  end

  def first?
    self == self.season.first_round
  end

  def last?
    self == self.season.last_round
  end
end


# == Schema Information
#
# Table name: rounds
#
#  id               :integer         not null, primary key
#  season_id        :integer         not null
#  number           :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#  state_simulation :boolean         default(FALSE)
#  start_time       :datetime
#

