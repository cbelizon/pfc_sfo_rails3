module Simulator
  require 'random/online'
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
      details << simulate_play(local, available_minutes, local_players);
    end

    1.upto(num_plays_guest) do
      details << simulate_play(guest, available_minutes, guest_players);
    end

    return details
  end

  def self.simulate_spectators(local, guest)
    generator = RealRand::RandomOrg.new
    local_quality = local.starters_average
    guest_quality = guest.starters_average
    qualities = guest_quality + local_quality + generator.randnum(1, 0, RANDOM).join().to_i
    ponderation = qualities * 10 / Float(local.ticket_price)
    ponderation = 100 if ponderation >= 100
    ponderation = ponderation / 100.0
    people = local.stadium_capacity * ponderation + generator.randnum(1, 0, 99).join().to_i
    people = local.stadium_capacity if people >  local.stadium_capacity
    return people
  end

  private
  def self.simulate_play(club, available_minutes, starters)
    action = @actions[rand(@actions.length)]
    players = starters.to_a
    player = players[rand(players.length - 1) + 1] #Evitamos que el portero pueda meter gol
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
