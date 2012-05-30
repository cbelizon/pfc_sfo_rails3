class MatchGeneralsController < ApplicationController  
  # GET /match_generals/1
  # GET /match_generals/1.xml
  def show
    @match_general = MatchGeneral.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
