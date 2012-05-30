# To change this template, choose Tools | Templates
# and open the template in the editor.

class Position
  attr_accessor :win, :lost, :deals, :played, :goals_favor, :goals_against,
    :points, :user
  def initialize(win = 0, lost = 0, deals = 0, played = 0, goals_favor = 0, goals_against = 0, points = 0,
      user = nil)
    @win = win
    @lost = lost
    @deals = deals
    @played = played
    @goals_favor = goals_favor
    @goals_against = goals_against
    @points = points
    @user = user
  end

  #Returns the club of the user
  def club
    @user.club
  end
end
