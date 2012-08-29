class MatchGeneralsController < ApplicationController
  # GET /match_generals/1
  # GET /match_generals/1.xml
  def show
    @match_general = MatchGeneral.find(params[:id])
    @local = @match_general.local
    @guest = @match_general.guest
    @first_time = @match_general.details.first_time.reverse
    @second_time = @match_general.details.second_time.reverse
    @in_play = @match_general.in_play?
    @finished = @match_general.finished?
    @minute = @match_general.minute

    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
