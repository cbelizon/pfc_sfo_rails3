class Season < ActiveRecord::Base
  belongs_to :league
  has_many :rounds, :dependent => :destroy
  has_and_belongs_to_many :clubs
  validates_presence_of :date, :season_state
  validates_numericality_of :date, :season_state
  before_save :set_finished
  scope :recent, lambda {|count| {:limit => count, :order => 'date DESC'}}
  attr_accessible :rounds, :date, :league, :clubs
  #Constants
  NOT_STARTED = 0
  IN_PROGRESS = 1
  FINISHED = 2

  #Orders the season by the category and date
  def <=>(other)
    self.category <=> other.category or
    other.date <=> self.date
  end

  #Returns a classification in a class classification.
  def classification
    new_classification = Classification.new(self.clubs)
    self.rounds.each do |round|
      if round.finished?
        round.match_generals.each {|m| new_classification.add_match(m)}
      end
    end

    new_classification
  end

  #returns the club to promotion
  def clubs_to_promotion(count)
    self.classification.first_clubs(count)
  end

  #returns the clubs to be relegated
  def clubs_to_be_relegated(count)
    self.classification.last_clubs(count)
  end

  #Returns the clubs that stay on the same season
  def permanency_clubs(promotion, relegated)
    self.classification.permanency_clubs(promotion, relegated)
  end

  #returns the category of season
  def category
    self.league.category
  end

  #returns the max_date season
  def self.current_date
    max = Season.maximum('date')
    if max.nil?
      max = DateTime.now.year - 1
    end

    return max
  end

  #Returns the next date for the season
  def self.next_date
    self.current_date + 1
  end

  #Returns all current seasons
  def self.current_seasons
    where(:date => Season.maximum('date'))
  end

  #returns true if round actual is not nil
  def round_actual?
    !self.round_actual.nil?
  end

  #returns the first round of season
  def first_round
    self.rounds.find(:first,
    :conditions => "number = #{1}" )
  end

  #Set the next round of season as actual round and update the management
  #system
  def next_round!
    self.round_actual.match_generals.each do |match|
      local = match.local
      guest = match.guest
      #update trainings
      local.train_players
      guest.train_players
      #create a new finances for this round
      local_finances = ClubFinancesRound.create!({
        :club => local,
        :round => self.round_actual,
        :cash => local.cash,
        :pays_players => local.pays_players_week,
        :pays_maintenance => local.pays_maintenance,
        :pays_transfers => local.pays_transfers,
        :benefits_ticket => match.benefits,
        :benefits_transfers => local.benefits_transfers
      })
      guest_finances = ClubFinancesRound.create!({
        :club => guest,
        :round => self.round_actual,
        :cash => guest.cash,
        :pays_players => guest.pays_players_week,
        :pays_maintenance => guest.pays_maintenance,
        :pays_transfers => guest.pays_transfers,
        :benefits_transfers => guest.benefits_transfers
      })
      #updates the cashs
      local.cash += local_finances.balance
      guest.cash += guest_finances.balance
      #update offers
      local.offers_as_seller.accepted.each do |offer|
        offer.seller.sell(offer.player)
        offer.buyer.buy(offer.player)
        offer.transfered
      end
      guest.offers_as_seller.accepted.each do |offer|
        offer.seller.sell(offer.player)
        offer.buyer.buy(offer.player)
        offer.transfered
      end
      local.save!
      guest.save!
    end
    if !self.round_actual.nil?
      #set to next round
      self.round_actual = self.get_next_round unless self.last_round?
    end
    Player.all.each do |player|
        player.new_clause!
        player.new_pay!
        player.save!
    end
    self.save!
  end

  #returns the next round
  def get_next_round
    if !self.last_round? and !self.actual_round.nil?
      self.rounds.find(:first, :conditions =>
      "number = #{self.round_actual.number + 1}")
    end
  end

  #returns the previous_round
  def get_previous_round
    if self.round_actual != self.first_round and !self.actual_round.nil?
      self.rounds.find(:first, :conditions =>
      "number = #{self.round_actual.number - 1}")
    end
  end

  #returns the actual round of the season
  def round_actual
    Round.find(self.actual_round) if !self.actual_round.nil?
  end

  #to assign an other actual season
  def round_actual=(other)
    self.actual_round = other.id
  end

  #return true if the season is in progress
  def in_progress?
    self.season_state == IN_PROGRESS
  end

  #return true if the season is finished
  def finished?
    self.season_state == FINISHED
  end

  #returns true if the current round is finished
  def round_finished?
    self.round_actual.finished?
  end

  #returns true if the current season is not started
  def round_not_started?
    self.round_actual.not_started?
  end

  #return true if the season is not started
  def not_started?
    self.season_state == NOT_STARTED
  end

  #create the rounds calendar for the season and update clause and pay for players
  def start!
    self.rounds = make_rounds(self.clubs)
    self.season_state = IN_PROGRESS
    self.round_actual = self.first_round
    self.save!
  end

  #return an String whit the state of the season
  def stage
    return "season.state.not_started" if self.not_started?
    return "season.state.in_progress" if self.in_progress?
    return "season.state.finished" if self.finished?
  end

  #return the last_round
  def last_round
    self.rounds.find(:first,
    :conditions => "number = #{self.rounds.count}" )
  end

  #Returns the number of rounds of the season
  def num_rounds
    self.rounds.count
  end

  #Returns the last round of this season
  def last_round?
    self.round_actual == self.last_round if !self.round_actual.nil?
  end

  #Returns the first round of this season
  def first_round?
    self.round_actual == self.first_round if !self.round_actual.nil?
  end

  #Returns the seasons for next date with promotions and relegations
  def self.promotion_and_relegate(seasons, num_clubs)
    date = Season.current_date + 1
    new_seasons = []

    if seasons.length > 1
      new_clubs = []
      league = seasons[0].league
      first_season = Season.new({:date => date, :league => league})
      seasons[0].permanency_clubs(0,num_clubs).each{|x| new_clubs << x}
      seasons[1].clubs_to_promotion(num_clubs).each{|x| new_clubs << x}
      new_clubs.each {|c| first_season.clubs << c}
      new_seasons << first_season
      if seasons.length - 2  != 0
        for i in (1..seasons.length - 2)
          new_clubs = []
          league = seasons[i].league
          new_season = Season.new({:date => date, :league => league})
          seasons[i - 1].clubs_to_be_relegated(num_clubs).each{|x| new_clubs << x}
          seasons[i].permanency_clubs(num_clubs,num_clubs).each{|x| new_clubs << x}
          seasons[i + 1].clubs_to_promotion(num_clubs).each{|x| new_clubs << x}
          new_clubs.each {|c| new_season.clubs << c}
          new_seasons << new_season
        end
      end
      new_clubs = []
      league = seasons[seasons.length - 1].league
      last_season = Season.new({:date => date, :league => league})
      seasons[seasons.length - 2].clubs_to_be_relegated(num_clubs).each{|x| new_clubs << x}
      seasons[seasons.length - 1].permanency_clubs(num_clubs,0).each{|x| new_clubs << x}
      new_clubs.each {|c| last_season.clubs << c}
      new_seasons << last_season
      return new_seasons
    else
      season = Season.new({
        :date => date,
        :league => League.first,
      :clubs => seasons.first.clubs})
      new_seasons << season
      return new_seasons
    end
  end

  #Returns true if the actual round is simulated
  def simulated_round?
    self.round_actual.simulated?
  end

  #Simulate the current round
  def simulate_round_actual!
    self.round_actual.simulate_matchs!
    self.save!
  end

  #Start the current round
  def start_round_actual!
    self.round_actual.play!
    self.save!
  end

  #Returns true if all seasons are finished
  def self.finished?(seasons)
    finished = true
    seasons.each {|s| finished = false if s.in_progress? or s.not_started?}
    return finished
  end

  def in_play_round?
    self.round_actual.in_play? if !self.round_actual.nil?
  end

  private
  #Returns an array with all rounds of the clubs passed
  def make_rounds(clubs)
    #If odd insert dummy club
    if clubs.length % 2 == 1
      clubs << :dummy
    end

    rounds_home = []
    rounds_away = []
    num_rounds = clubs.length - 1
    num_matches = clubs.length / 2 - 1
    num_clubs = clubs.length

    for i in (1..num_rounds)
      matches_home = []
      matches_away = []
      for j in (0..num_matches)
        matches_home << MatchGeneral.new({
          :local => clubs[j],
          :guest => clubs[num_clubs - j - 1]
        }) #Home match
        matches_away << MatchGeneral.new({
          :local => clubs[num_clubs - j - 1],
          :guest => clubs[j]
        })
      end
      rounds_home << Round.new({
        :number => i,
        :match_generals => matches_home,
        :state_simulation => false
      })
      rounds_away << Round.new({
        :number => num_rounds +  i,
        :match_generals => matches_away,
        :state_simulation => false
      })
      #rotating the teams

      last = clubs.pop
      clubs.insert(1, last)
    end

    rounds_away.each { |x| rounds_home << x}
    return rounds_home
  end

  #Set the state for the season to finished
  def set_finished
    if !self.last_round.nil? and self.last_round.finished?
      self.season_state = FINISHED
    end
  end
end


# == Schema Information
#
# Table name: seasons
#
#  id           :integer         not null, primary key
#  league_id    :integer         not null
#  date         :integer         not null
#  actual_round :integer
#  created_at   :datetime
#  updated_at   :datetime
#  season_state :integer         default(0), not null
#
