class HomeController < ApplicationController
  def index
    @seasons = League.current_seasons
    respond_to do |format|
      format.html
    end
  end
end
