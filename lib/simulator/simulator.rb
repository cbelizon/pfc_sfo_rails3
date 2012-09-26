module Simulator
  NUM_PLAYS = 88
  RANDOM = 15

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
      details << simulate_play(local, guest, available_minutes, local_players, guest_players);
    end

    1.upto(num_plays_guest) do
      details << simulate_play(guest, local, available_minutes, guest_players, local_players);
    end

    return details
  end

  def self.simulate_spectators(local, guest)
    local_quality = local.starters_average
    guest_quality = guest.starters_average
    qualities = guest_quality + local_quality + rand(RANDOM)
    ponderation = qualities * 10 / Float(local.ticket_price)
    ponderation = 100 if ponderation >= 100
    ponderation = ponderation / 100.0
    people = local.stadium_capacity * ponderation + rand(99)
    people = local.stadium_capacity if people >  local.stadium_capacity
    return people
  end

  private
  def self.simulate_play(attacker, defender, available_minutes, starters_attacker, starters_defender)
    action = @actions[rand(@actions.length)]
    players = starters_attacker.to_a
    player = players[rand(players.length - 1) + 1] #Evitamos que el portero pueda meter gol
    minute = available_minutes.delete_at(rand(available_minutes.length))

    #Robar jugada de ataque
    sum_midfielders_attacker = 0
    sum_midfielders_defenders = 0

    attacker.midfielders.each do |a|
      sum_midfielders_attacker += a.average_qualities_tactic
    end

    defender.midfielders.each do |d|
      sum_midfielders_defenders += d.average_qualities_tactic
    end

    dif_midfielders = sum_midfielders_attacker + rand(sum_midfielders_attacker * 0.20) -
      sum_midfielders_defenders - rand(sum_midfielders_defenders * 0.20)

    if dif_midfielders < 0 && rand(10) > 7
      temp = defender
      defender = attacker
      attacker = temp
      players = starters_defender.to_a
      player = players[rand(players.length - 1) + 1]
    end

    #Parar jugada de gol
    if action == MatchDetail::ACTION_GOAL
      sum_attackers = 0
      attacker.attackers.each do |a|
        sum_attackers += a.average_qualities_tactic
      end
      sum_defenders = 0
      defender.defenders.each do |d|
        sum_defenders += d.average_qualities_tactic
      end
      dif_attack = sum_defenders - sum_attackers - rand(Integer(sum_attackers * 1.5))
      if dif_attack < 0
        MatchDetail.new({
          :player => player,
          :club => attacker,
          :action => action,
          :minute => minute
        })
      else
        MatchDetail.new({
          :player => player,
          :club => attacker,
          :action => @actions[rand(@actions.length - 1)],
          :minute => minute
          })
      end
    else
      MatchDetail.new({
        :player => player,
        :club => attacker,
        :action => action,
        :minute => minute
      } )
    end
  end

  def self.num_plays(local, guest, num_plays)
    total = local + guest + 2;
    multiplier_local = (local + 1)/ Float(total);
    return Integer(num_plays * multiplier_local);
  end
end
