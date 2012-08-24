class HomeController < ApplicationController
  def index
    @seasons = League.current_seasons
    @in_play = false
    if !@seasons.first.nil?
    	@in_play = @seasons.first.in_play_round?
    end
    respond_to do |format|
      format.html
    end
  end
end
