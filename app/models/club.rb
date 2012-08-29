# == Schema Information
#
# Table name: clubs
#
#  id               :integer          not null, primary key
#  name             :string(30)       not null
#  stadium_name     :string(40)       not null
#  stadium_capacity :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  cash             :decimal(16, 2)   default(0.0)
#  ticket_price     :decimal(4, 2)    default(0.0)
#  tactic           :string(255)      default("4-4-2"), not null
#

class Club < ActiveRecord::Base
  require 'faker'
  validates_presence_of :name, :stadium_name, :stadium_capacity, :tactic
  validates_inclusion_of :tactic, :in => TACTICS['available']
  validates_length_of :name, :in => 2..30
  validates_length_of :stadium_name, :in => 2..40
  validates_numericality_of :stadium_capacity, :cash
  validates_numericality_of :ticket_price, :greater_than_or_equal_to => 0
  validates_uniqueness_of :name
  has_and_belongs_to_many :seasons
  belongs_to :user
  has_many :players
  has_many :match_as_local, :class_name => 'MatchGeneral',
    :foreign_key => 'local_id'
  has_many :club_finances_rounds
  has_many :match_as_guest, :class_name => 'MatchGeneral',
    :foreign_key => 'guest_id'
  has_many :offers_as_seller, :class_name => 'Offer'
  has_many :offers_as_buyer, :class_name => 'Offer',
    :foreign_key => 'buyer_id'
  has_many :line_up
  has_many :match_details
  scope :no_user, :conditions => ['user_id = NULL']
  attr_accessible :name, :stadium_name, :stadium_capacity, :ticket_price, :cash, :players

  INIT_PLAYERS = 18
  MAX_PLAYERS = 25
  MIN_PLAYERS = 11
  INIT_STADIUM = 10000
  INIT_TICKET_PRICE = 10
  INIT_CASH = 20000

  def to_param
      "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end

  #Update the trainings for each player
  def train_players
    self.players.each(&:train)
  end

  #Returns the starters players
  def starters
    self.players.starter
  end

  #Returns the average quality of starters players
  def starters_average
    total = self.players.starter.inject(0) {|result, element| result + element.average_qualities}
    return total / MIN_PLAYERS
  end

  def starters_average_tactic
    total = self.players.starter.inject(0) {|result, element| result + element.average_qualities_tactic}
    return total / MIN_PLAYERS
  end

  #Returns the suppliers players
  def suppliers
    self.players.supplier
  end

  #Returns the no convocateds players
  def no_convocateds
    self.players.no_convocated
  end

  #Returns true if the team has the minimum players
  def minimum_players?
    self.players.count == MIN_PLAYERS
  end

  #Returns true if the team has the maximum players
  def maximum_players?
    self.players.count == MAX_PLAYERS
  end

  #Sell the player passed
  def sell(player)
    unless player.nil?
      player.free
      reordenate_team
    end
  end

  #Buy the player passed
  def buy(player)
    unless player.nil?
      player.update_attribute(:position, self.last_position)
      player.update_attribute(:club, self)
    end
  end

  #Returns the last_position aviable for the team
  def last_position
    self.players.maximum(:position)
  end

  #Returns true if club has a actual round
  def round_actual?
    self.current_season.round_actual?
  end

  #Returns the last match played for the club
  def last_match
    self.current_season.round_actual.get_match(self)
  end

  #Return the last finances for the club
  def last_finances
    self.club_finances_rounds.find(:first, :conditions => {
        :round_id => self.current_season.get_previous_round
      }) unless self.current_season.first_round?
  end

  #Returns the benefits of the tickets of last match
  def benefits_last_match_tickets
    self.last_match.benefits
  end

  #Returns the pays for maintenance of the stadium
  def pays_maintenance
    self.stadium_capacity
  end

  #Returns the anual pays of all players of the club
  def pays_players
    self.players.inject(0) {|sum, player| sum += player.pay}
  end

  #Returns the week pays of all players of the club
  def pays_players_week
    self.players.inject(0) {|sum, player| sum += player.pay_week}
  end

  #Returns the benefits of last transfers accepted
  def benefits_transfers
    self.offers_as_seller.accepted.inject(0) {|sum, offer| sum += offer.pay}
  end

  #Returns the pays of last transfers accepted
  def pays_transfers
    self.offers_as_buyer.accepted.inject(0){|sum,offer| sum += offer.pay}
  end

  #Order by points


  #make the substitution between players (update the position)
  def replace(player1, player2)
    p1 = self.players.find(player1)
    p2 = self.players.find(player2)
    p1.position, p2.position = p2.position, p1.position
    p1.save!
    p2.save!
  end

  #returns the matchs played in the season at the round passed
  def played_matchs_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      if match.finished?
        count += 1
      end
    end
    count
  end

  #returns the matchs wons in the season at the round passed
  def win_matchs_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

     matchs.each do |match|
      if match.is_winner?(self) and match.finished?
        count += 1
      end
    end
    count
  end

  #returns the matchs dealed in the season at the round passed
  def deal_matchs_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      if match.deal? and match.finished?
        count += 1
      end
    end
    count
  end

  #returns the matchs lost in the season at the round passed
  def lost_matchs_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      if match.is_looser?(self) and match.finished?
        count += 1
      end
    end

    count
  end

  #returns the points won in the season at the round passed
  def points_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      if match.is_winner?(self) and match.finished?
        count += MatchGeneral::PT_WIN
      end
      if match.deal? and match.finished?
        count += MatchGeneral::PT_DEAL
      end
    end

    count
  end

  #returns the goals at favor on the season at the round passed
  def goals_favor_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      count += match.goals_favor(self) if match.finished?
    end

    count
  end

  #returns the goals against on the season at the round passed
  def goals_against_season(round, season = nil)
    count = 0
    matchs = find_matchs(round, season)

    matchs.each do |match|
      count += match.goals_against(self) if match.finished?
    end

    count
  end

  #Returns the current season that are playing the club
  def current_season
    self.seasons.find(:first,
      :conditions => {:date => Season.maximum('date')})
  end

  #Returns a new club with random attributes
  def self.create_random
    players = Player.create_random_team(INIT_PLAYERS)
    club = Club.new({
        :name => "#{Faker::Address.city} F.C",
        :stadium_name => "#{Faker::Address.street_name}",
        :stadium_capacity => INIT_STADIUM,
        :ticket_price => INIT_TICKET_PRICE,
        :cash => INIT_CASH,
        :players => players
      })
    return club
  end

  #Returns the offers pendings as a seller
  def pending_offers_as_seller
    self.offers_as_seller.pending
  end

  #Returns the offers pendings as a buyer
  def pending_offers_as_buyer
    self.offers_as_buyer.pending
  end

  #return line up of match
  def line_up_starters(match)
    players = LineUp.where(:club_id => self.id, :match_general_id => match, :position => (1..11)).map do |lu|
      lu.player
    end
    return players
  end

  private

  #find matchs on the round and season passed
  def find_matchs(round, season)
    if round.nil?
      return []
    end

    season = self.current_season if season.nil?
    rounds = []
    rounds = season.rounds.collect {|r| r if
      r.number <= round.number}
    matchs = []
    rounds.each do |r|
      if !r.nil?
        r.match_generals.each {|m| matchs << m if m.guest == self or
            m.local == self}
      end
    end
    matchs
  end

  #Reordenate the position of all players on the team
  def reordenate_team
    position = 1
    self.players.each do |player|
      player.update_attribute(:position, position)
      position += 1
    end
  end
end

