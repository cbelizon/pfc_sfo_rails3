module Simulator2

  ACTION_ERROR = 'action.error'
  ACTION_TO_CLEAR = 'action.to_clear'
  ACTION_OUT = 'action.out'
  ACTION_PASS = 'action.pass'
  ACTION_KICK = 'action.kick'
  ACTION_DRIBBLING = 'action.dribbling'
  ACTION_SPECTACULAR_PASS = 'action.spectacular_pass'
  ACTION_SPECTACULAR_DRIBBLING = 'action.spectacular_dribbling'
  ACTION_SHOOT = 'action.shoot'

  ACTIONS_PLAY = [
    ACTION_ERROR,
    ACTION_TO_CLEAR,
    ACTION_TO_CLEAR,
    ACTION_OUT,
    ACTION_PASS,
    ACTION_DRIBBLING,
    ACTION_KICK,
    ACTION_SPECTACULAR_PASS,
    ACTION_SPECTACULAR_DRIBBLING,
    ACTION_SHOOT,
  ]
  
  def self.simulate_match(local, guest, local_tactic, guest_tactic)
    local_starters = local.starters.to_a
    guest_starters = guest.starters.to_a
    local_starters = adjust_players(local_starters, local_tactic)
    guest_starters = adjust_players(guest_starters, guest_tactic)
    lines_local = adjust_lines(local_starters, local_tactic)
    lines_guest = adjust_lines(guest_starters, local_tactic)
    details = []
    turn = local
    last_minute = 1
    i = 1
    while i < MatchGeneral::PARTS_TIME
      if turn == local
        details << simulate_play(lines_local, lines_guest, turn, last_minute, local_tactic, guest_tactic,
        local.starters.to_a, guest.starters.to_a)
      else
        details << simulate_play(lines_guest, lines_local, turn, last_minute, local_tactic, guest_tactic,
        guest.starters.to_a, local.starters.to_a)
      end
      last_minute += rand(1) + 1
      (turn == local) ? turn = guest : turn = local
      i += 1
    end
    i = MatchGeneral::PARTS_TIME + MatchGeneral::HALF_TIME
    last_minute = i
    while i < MatchGeneral::MINUTES
      if turn == local
        details << simulate_play(lines_local, lines_guest, turn, last_minute, local_tactic, guest_tactic,
        local.starters.to_a, guest.starters.to_a)
      else
        details << simulate_play(lines_guest, lines_local, turn, last_minute, local_tactic, guest_tactic,
        local.starters.to_a, guest.starters.to_a)
      end
      last_minute += rand(1) + 1
      (turn == local) ? turn = guest : turn = local
      i += 1
    end
    details
  end

  def self.simulate_spectators(local, guest)
    local_quality = local.players.inject(0) {|acum, player| acum += player.quality}
    guest_quality = guest.players.inject(0){|acum, player| acum += player.quality}
    qualities = guest_quality + local_quality
    ponderation = qualities / local.ticket_price
    ponderation = 100 if ponderation > 100
    ponderation = ponderation / 100
    local.stadium_capacity * ponderation
  end

  private
  def self.simulate_play(attack, defense,  turn, last_minute, tactic_local, tactic_guest,
                        attack_starters, defense_starters)
    gameplay = 0
    0.upto(attack.length - 1) do |line|
      attack[line] += rand(attack[line])
      defense[line] += rand(defense[line])
    end
    0.upto(attack.length - 1) do |line|
      if attack[line] >= defense[attack.length - (line + 1)]
        gameplay += 1
      end
    end
    goal = 1
    if gameplay == attack.length
      goal = rand(2)
    end
    action = ACTIONS_PLAY[rand(ACTIONS_PLAY.length)]
    if !goal
      action = MatchDetail::ACTION_GOAL
    end
    player = attack_starters[rand(attack.length - 1)]
    MatchDetail.new({
        :player => player,
        :club => turn,
        :action => action,
        :minute => last_minute,
      } )
  end

  def self.adjust_players(players, tactic)
    players_adjusted = []
    players.each do |player|
      player_temp = Player.new()
      attributes = TACTICS[tactic]["players"]["pos"+ player.position.to_s].keys
      attributes.delete("sym")
      attributes.each do |attribute|
        player_temp[attribute] = player[attribute] * TACTICS[tactic]["players"]["pos"+player.position.to_s][attribute]
      end
      players_adjusted << player_temp
    end
    players_adjusted
  end

  def self.adjust_lines(players, tactic)
    attributes = TACTICS[tactic].keys
    attributes.delete("image")
    attributes.delete("players")
    players.delete_at(0)
    lines = []
    attributes.each do |attribute|
      acum_qualities = 0
      0.upto(TACTICS[tactic][attribute] - 1) do |position|
        acum_qualities += players.first.average_qualities
        players.delete_at(0)
      end
      lines << acum_qualities + TACTICS[tactic][attribute] * 10 
    end
    lines
  end
end
