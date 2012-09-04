class Classification
  attr_accessor :classification

  def initialize(clubs)
    @classification = {}

    clubs.each do |club|
      position = Position.new
      position.user = club.user
      @classification[club] = position
    end
  end

  #Add a new match to create the classification
  def add_match(match)
    local = match.local
    guest = match.guest
    @classification[local].played += 1
    @classification[local].goals_favor += match.goals_favor(local)
    @classification[local].goals_against += match.goals_against(local)
    @classification[guest].played += 1
    @classification[guest].goals_favor += match.goals_favor(guest)
    @classification[guest].goals_against += match.goals_against(guest)

    if match.is_winner?(local)
      @classification[local].win += 1
      @classification[local].points += MatchGeneral::PT_WIN
      @classification[guest].lost  += 1
    end

    if match.is_winner?(guest)
      @classification[guest].win += 1
      @classification[guest].points += MatchGeneral::PT_WIN
      @classification[local].lost  += 1
    end

    if match.deal?
      @classification[local].deals += 1
      @classification[guest].deals += 1
      @classification[local].points += MatchGeneral::PT_DEAL
      @classification[guest].points += MatchGeneral::PT_DEAL
    end
  end

  #Call block once for each club on the classification.
  def each
    sorted = @classification.sort do |a,b|
      if b[1].points == a[1].points
        if (b[1].goals_favor - b[1].goals_against) == (a[1].goals_favor - a[1].goals_against)
          b[1].goals_favor <=> a[1].goals_favor
        else
          b[1].goals_favor - b[1].goals_against <=> a[1].goals_favor - a[1].goals_against
        end
      else
        b[1].points <=> a[1].points
      end
    end
    sorted.each { |e| yield e[1] }
  end

  #Returns the n first clubs specified in count
  def first_clubs(count = 1)
    sorted = @classification.sort {|a,b| b[1].points <=> a[1].points }
    clubs = sorted.collect {|e| e[0]}
    clubs.slice!(0, count)
  end

  #Returns the n last clubs specified in count
  def last_clubs(count = 1)
    sorted = @classification.sort {|a,b| a[1].points <=> b[1].points }
    clubs = sorted.collect {|e| e[0]}
    clubs.slice!(0, count)
  end

  #Returns the clubs that stay in the league.
  def permanency_clubs(promotion = 0, relegated = 0)
    sorted = @classification.sort {|a,b| b[1].points <=> a[1].points }
    clubs = sorted.collect{|e| e[0]}
    clubs.slice!(0,promotion)
    clubs.reverse!
    clubs.slice!(0,relegated)
    clubs.reverse!
  end
end
