class Player < ActiveRecord::Base
  PLAYER_QUALITIES = 7
  MAX_QUALITY = 100
  MIN_QUALITY = 0
  MAX_QUALITY_ITERATION = 20  #To create a player with average attributes
  MIN_AGE_MAX = 32
  MAX_AGE_MAX = 40
  NUM_STARTERS = 11
  PLAYER_ATTRIBUTES = ["speed", "resistance", "kick", "pass", "recovery", "dribbling", "goalkeeper"]

  before_validation :average_qualities
  attr_reader :complete_name
  belongs_to :club
  has_many :offers
  has_many :trainings
  has_many :details, :class_name => 'MatchDetail'
  has_many :line_ups
  validates_presence_of :name, :surname, :quality,
    :pay, :clause, :speed, :resistance, :kick, :pass, :recovery, :dribbling,
    :goalkeeper
  validates_length_of :name, :in => 2..20
  validates_length_of :surname, :in => 2..30
  validates_numericality_of :quality,
    :pay, :clause, :speed, :resistance, :kick, :pass, :recovery, :dribbling,
    :goalkeeper
  scope :starter, :conditions => {:position => (1..NUM_STARTERS)},
    :order => 'position asc'
  scope :supplier, :conditions => ["position > #{NUM_STARTERS}"],
    :order => 'position asc'

  attr_accessible :position

  def <=>(other)
    self.position <=> other.position
  end

  def tactic_position
    tactic = self.club.tactic
    if self.starter?
      I18n.t("symbol.#{TACTICS[tactic]["players"]["pos#{self.position}"]["sym"]}")
    else
      I18n.t("symbol.RE")
    end
  end

  #Returns goals of the season
  def goals(season = Season.current_date)
    count = 0
    self.details.goals.each do |detail|
      if detail.season == season
        count += 1
      end
    end

    return count
  end

  #Create a new instance of training with the ability passed with randoms values
  def create_training(ability)
    percentil = self[ability] / 10
    improvement = 1 + rand(9)
    time = 1 + rand(percentil)
    Training.new({
        :ability => ability,
        :improvement => improvement,
        :round_count => time,
        :player => self
      }
    )
  end

  #Returns true if the player already training
  def training?
    self.trainings.not_finished.count > 0
  end

  #Update the tranings for the player
  def train
    decrease = false
    trainings = self.trainings.not_finished.map(&:discount_round)
    trainings.each do |training|
      decrease = true
      if training.round_count == 0
        value = self.attributes[training.ability]
        self.update_attribute(training.ability, value + training.improvement ) if value <= MAX_QUALITY
      end
    end

    PLAYER_ATTRIBUTES.each do |attribute|
      percentil = self[attribute] / 10
      acum = 0
      if !decrease
        acum = rand(percentil)
      end
      if self[attribute] - acum >= 0
       self[attribute] -= acum
      else
        self[attribute] = 0
      end
      self.save
    end
    self.update_attribute('quality', self.average_qualities)
    self.save
  end

  #Return the actual training for the player
  def actual_training
    self.trainings.not_finished.first
  end

  #set null club_id
  def free
    self.update_attribute(:club, nil)
  end

  #return true if player is a free agent (Without Club)
  def free_agent?
    club_id.nil?
  end

  #return the concatenation of name and surname
  def complete_name
    self.name + ' ' + self.surname
  end

  #return the pay in a week for current player
  def pay_week
    self.pay / self.club.current_season.num_rounds
  end

  #Returns a players array with length num_players
  def self.create_random_team(num_players)
    players = []
    for i in (1..num_players)
      players << self.create_random_player(i, 350)
    end

    return players
  end

  #Return true if the player is a starter
  def starter?
    self.position >=  1 and self.position <= NUM_STARTERS
  end

  #Returns a random player with the position passed
  def self.create_random_player(position, max_qualities)
    Faker::Config.locale = "en-US"
    player = Player.new()
    player.name = Faker::Name.first_name
    player.surname = Faker::Name.last_name
    player.position = position

    while max_qualities > 0
      PLAYER_ATTRIBUTES.each do |attribute|
        if max_qualities > 0
          acum = 1 + rand(MAX_QUALITY_ITERATION - 1)
          if acum >= max_qualities
            acum = max_qualities
          end
          if player[attribute] + acum > MAX_QUALITY
            acum = MAX_QUALITY - player[attribute]
          end
          player[attribute] += acum
          max_qualities -= acum
        end
      end
    end

    player.quality = 0
    PLAYER_ATTRIBUTES.each do |attribute|
      player.quality += player[attribute]
    end
    player.quality  = player.quality / PLAYER_QUALITIES
    player.clause = (player.quality * 1000).to_i
    player.pay = (player.quality * 10).to_i
    return player
  end

  #calculate the average of all qualities
  def average_qualities
    if !(speed.nil? || resistance.nil? || dribbling.nil? || kick.nil? ||
          pass.nil? || recovery.nil?)
      self.quality = (speed + resistance + dribbling + kick + pass + recovery + goalkeeper) /
        PLAYER_QUALITIES
    end
  end

  def new_clause!
    self.update_attribute(:clause, (self.quality * 1000))
  end

  def new_pay!
    self.update_attribute(:pay, (self.quality * 10 ))
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

