module Simulator
  NUM_PLAYS = 88

  def self.simulate_match(local, guest, actions, available_minutes)
    @actions = actions
    avg_local = local.starters_average_tactic
    avg_guest = guest.starters_average_tactic
    num_plays_local = num_plays(avg_local, avg_guest, NUM_PLAYS)  #Adjusting the num of plays in terms of global quality
    num_plays_guest = num_plays(avg_guest, avg_local, NUM_PLAYS)

    details = []
    local_players = local.starters
    guest_players = guest.starters
    1.upto(num_plays_local) do
      details << simulate_play(local, available_minutes, local_players);
    end

    1.upto(num_plays_guest) do
      details << simulate_play(guest, available_minutes, guest_players);
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
  def self.simulate_play(club, available_minutes, starters)
    action = @actions[rand(@actions.length)]
    players = starters.to_a
    player = players[rand(players.length - 1) + 1]
    minute = available_minutes.delete_at(rand(available_minutes.length))
    MatchDetail.new({
        :player => player,
        :club => club,
        :action => action,
        :minute => minute
      } )
  end

  def self.num_plays(local, guest, num_plays)
    total = local + guest + 2;
    multiplier_local = (local + 1)/ Float(total);
    return Integer(num_plays * multiplier_local);
  end
end
