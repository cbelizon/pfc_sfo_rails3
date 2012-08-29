# == Schema Information
#
# Table name: match_generals
#
#  id           :integer          not null, primary key
#  local_id     :integer          not null
#  guest_id     :integer          not null
#  local_goals  :integer
#  guest_goals  :integer
#  round_id     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  spectators   :integer          default(0)
#  ticket_price :decimal(4, 2)    default(0.0)
#

class MatchGeneral < ActiveRecord::Base
  PT_WIN = 3
  PT_DEAL = 1
  MINUTES = 90
  PARTS_TIME = 45
  HALF_TIME = 15
  TIME_MATCH = 0 #60 * 90

  belongs_to :round
  belongs_to :local, :class_name => 'Club'
  belongs_to :guest, :class_name => 'Club'
  has_many :details, :class_name => 'MatchDetail'
  has_many :line_ups
  validates_numericality_of :spectators, :greater_than_or_equal_to => 0
  validates_numericality_of :ticket_price, :greater_than_or_equal_to => 0
  attr_accessible :local, :guest


  def to_param
      "#{id}-#{local.downcase.gsub(/[^[:alnum:]]/,'-')}-vs-#{guest.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end

  #Create the commentaries and line-ups of the match
  def simulate
    self.ticket_price = self.local.ticket_price
    create_line_ups(self.local.starters, self.local.suppliers, self.guest.starters,
    self.guest.suppliers)
    available_minutes = create_minutes
    self.details = Simulator.simulate_match(self.local, self.guest, MatchDetail::ACTIONS_PLAY, available_minutes)
    self.spectators = Simulator.simulate_spectators(self.local, self.guest)
    self.local_goals = self.details.goals.
      find(:all, :conditions => {:club_id => self.local}).length
    self.guest_goals = self.details.goals.
      find(:all, :conditions => {:club_id => self.guest}).length

  end

  #returns the local goals in live
  def local_goals_live
    comments = self.details.goals.find(:all, :conditions =>
            {:club_id => self.local})
    count = 0

    comments.each do |c|
      if c.minute <= self.minute
        count += 1
      end
    end

    return count;

  end

  #returns the guest goals in live
  def guest_goals_live
    comments = self.details.goals.find(:all, :conditions =>
            {:club_id => self.guest})
    count = 0

    comments.each do |c|
      if c.minute <= self.minute
        count += 1
      end
    end

    return count;
  end

  #Returns the benefits for the tickets
  def benefits
    self.ticket_price * self.spectators
  end

  #returns true if club is the winner of match
  def is_winner?(club)
    if self.finished?
      if self.local_goals > self.guest_goals
        if local == club
          return true
        end
      end

      if self.guest_goals > self.local_goals
        if guest == club
          return true
        end
      end
    end
    return false
  end

  #returns true if club is the looser of match
  def is_looser?(club)
    if self.finished?
      if self.local_goals > self.guest_goals
        if club == guest
          return true
        end
      end

      if self.guest_goals > self.local_goals
        if club == local
          return true
        end
      end
    end

    return false
  end

  #returns true if the match is a deal
  def deal?
    if self.finished?
      return self.local_goals == self.guest_goals
    end
    return false
  end

  #returns the goals favor if club play the match else return 0
  def goals_favor(club)
    if finished?

      if club == local
        return local_goals
      end

      if club == guest
        return guest_goals
      end
    end

    0
  end

  #returns the goals against if club play the match else return 0
  def goals_against(club)
    if finished?
      if club == local
        return guest_goals
      end

      if club == guest
        return local_goals
      end
    end

    0
  end

  #returns true if the match has been played
  def finished?
    self.round.finished?
  end

  #returns true if match is in play
  def in_play?
    self.round.in_play?
  end

  #returns true if match is not played
  def not_started?
    self.round.not_started?
  end

  #returns the minute of play
  def minute
    if self.in_play?
      return self.round.minute
    else
      if self.finished?
        return MINUTES
      else
        return 0
      end
    end
  end

  private

  #Create the line-ups of the match
  def create_line_ups(players, *more_players)
    players.each{|player| LineUp.create(:club_id => player.club_id,
        :player_id => player.id,
        :position => player.position,
        :match_general_id => self.id
      )}

    more_players.each {
      |more_player| more_player.each{|player|
        LineUp.create(:club_id => player.club_id,
          :player_id => player.id,
          :position => player.position,
          :match_general_id => self.id
        )
      }
    }
  end

  private
  def create_minutes
    minutes = []
    1.upto(MINUTES) do |i|
      minutes << i
    end

    return minutes
  end
end

