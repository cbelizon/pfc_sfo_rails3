class League < ActiveRecord::Base
  has_many :seasons, :dependent => :destroy
  validates_numericality_of :category
  validates_presence_of :category
  validates_uniqueness_of :category
  NUM_CLUBS = 4
  NUM_PROMOTIONS = 2
  CLOSED = 0
  OPEN = 1
  attr_accessible :category

  #Returns the current category of the league
  def self.current_category
    max = League.maximum('category')

    if max.nil?
      max = 0
    end

    max
  end

  #Returns true if all seasons are finshed
  def self.finished_seasons?
    finished = true

    seasons = self.current_seasons
    seasons.each do |season|
      finished = false if !season.finished?
    end

    finished
  end

  #Return the next category for a new league
  def self.next_category
    League.current_category + 1
  end

  #Return the last seasons of all leagues
  def self.current_seasons
    Season.current_seasons
  end

  def self.in_play?
    if !League.current_seasons.first.nil?
      return League.current_seasons.first.in_play_round?
    else
      return false
    end
  end


  #Only for admins, create new leagues with the users without assigned club
  def self.create_with_users_with_no_club
    users = User.no_club
    num_leagues = users.length / NUM_CLUBS
    leagues = []
    season_date = Season.current_date
    num_leagues.times do
      league = League.new(:category => League.next_category)
      clubs = []
      NUM_CLUBS.times do
        clubs << Club.create_random
      end
      season = Season.new(:league => league, :date => season_date,
      :clubs => clubs)
      season.save!
      season.clubs.each { |c| c.update_attribute(:user, users.shift) }
      leagues << league
    end
    leagues
  end

  #Make possible gestion actions for the users
  def self.open_teams
    League.all.each {|l| l.update_attribute(:state_teams, OPEN) }
  end

  #returns true if the team is open
  def self.open_teams?
    state = true
    League.all.each {|l| state = false if l.state_teams == CLOSED }
    state
  end

  #returns true if teams are closed
  def self.closed_teams?
    state = true
    League.all.each {|l| state = false if l.state_teams == OPEN }
    state
  end

  #close the teams
  def self.close_teams
    League.all.each {|l| l.update_attribute(:state_teams, CLOSED)}
  end

  #Returns true if the rounds are simulated
  def self.simulated_rounds?
    simulated = true
    League.current_seasons.each{|s| simulated = false if !s.simulated_round?}
    return simulated
  end

  #Returns true if the rounds are finished
  def self.finished_rounds?
    finished = true
    League.current_seasons.each{|s| finished = false if !s.round_finished?}
    return finished
  end

  #Returns true if the rounds are not started
  def self.not_started_rounds?
    not_started = true
    League.current_seasons.each{|s| not_started = false if !s.round_not_started?}
    return not_started
  end

  #Returns true if the seasons are not started
  def self.not_started_seasons?
    not_started = true
    League.current_seasons.each{|s| not_started = false if !s.not_started?}
    return not_started
  end

  #Returns true if the rounds of the seasons are in play
  def self.in_play_rounds?
    in_play = true
    League.current_seasons.each{|s| in_play = false if !s.in_play_round? }
    return in_play
  end

  def self.num_rounds
    League.current_seasons.first.num_rounds
  end

  def self.current_round
    Round.find(League.current_seasons.first.actual_round).number
  end
end


# == Schema Information
#
# Table name: leagues
#
#  id          :integer         not null, primary key
#  category    :integer         default(1), not null
#  created_at  :datetime
#  updated_at  :datetime
#  state_teams :integer         default(0)
#
