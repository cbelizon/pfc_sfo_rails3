module LeaguesHelper
  #only prints something if the season is in progress
  def for_in_progress(season)
    season.in_progress? ? yield : nil
  end
end
