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
      details << simulate_play(local, guest, available_minutes, local_players);
    end

    1.upto(num_plays_guest) do
      details << simulate_play(guest, local, available_minutes, guest_players);
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
  def self.simulate_play(attacker, defender, available_minutes, starters)
    action = @actions[rand(@actions.length)]
    players = starters.to_a
    player = players[rand(players.length - 1) + 1] #Evitamos que el portero pueda meter gol
    minute = available_minutes.delete_at(rand(available_minutes.length))
    if action == MatchDetail::ACTION_GOAL
      sum_attackers = 0
      attacker.attackers.each do |a|
        sum_attackers += a.average_qualities_tactic
      end
      sum_defenders = 0
      defender.defenders.each do |d|
        sum_defenders += d.average_qualities_tactic
      end
      dif = sum_defenders - sum_attackers
      if dif > 0 #Si la defensa tiene más calidad que el ataque
        random_sum = rand(Integer((dif + 1) * 1.5))
        if (random_sum + sum_attackers) > sum_defenders
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
          :action => MatchDetail::ACTION_ROB,
          :minute => minute
          })
        end
      else #Si el ataque tiene más calidad que la defensa
        dif = -dif
        random_sum = rand(Integer((dif + 1) * 1.25))
        if (random_sum + sum_defenders) > sum_attackers
          MatchDetail.new({
          :player => player,
          :club => attacker,
          :action => MatchDetail::ACTION_ROB,
          :minute => minute
          })
        else
          MatchDetail.new({
          :player => player,
          :club => attacker,
          :action => action,
          :minute => minute
          })
        end
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
