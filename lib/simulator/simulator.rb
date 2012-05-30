module Simulator
  NUM_PLAYS = 45

  def self.simulate_match(local, guest, actions, available_minutes)
    @actions = actions
    avg_local = local.starters_average
    avg_guest = guest.starters_average
    num_plays_local = num_plays(avg_local, avg_guest, NUM_PLAYS)  #Adjusting the num of plays in terms of global quality
    num_plays_guest = num_plays(avg_guest, avg_local, NUM_PLAYS)

    details = []
    1.upto(num_plays_local) do
      details << simulate_play(local, available_minutes);
    end

    1.upto(num_plays_guest) do
      details << simulate_play(guest, available_minutes);
    end
    
    return details
  end

  def self.simulate_spectators(local, guest)
    local_quality = local.players.inject(0) {|acum, player| acum += player.quality}
    guest_quality = guest.players.inject(0){|acum, player| acum += player.quality}
    qualities = guest_quality + local_quality
    ponderation = qualities / local.ticket_price
    ponderation = 100 if ponderation > 100
    ponderation = ponderation / 100
    return local.stadium_capacity * ponderation
  end

  private
  def self.simulate_play(club, available_minutes)
    action = @actions[rand(@actions.length)]
    players = club.starters.to_a
    player = players[rand(players.length)]
    minute = available_minutes.delete_at(rand(available_minutes.length))
    MatchDetail.new({
        :player => player,
        :club => club,
        :action => action,
        :minute => minute
      } )
  end

  def self.num_plays(local, guest, num_plays)
    total = local + guest;
    multiplier_local = local / Float(total);
    return Integer(num_plays * multiplier_local);
  end
end
