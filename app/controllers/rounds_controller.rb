class RoundsController < ApplicationController
  # GET /rounds/1
  # GET /rounds/1.xml
  def show
    @round = Round.find(params[:id])
    @season = @round.season

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def previous
    @actual_round = Round.find(params[:id])
    @previous_round = @actual_round.previous
    @actual_round = @actual_round.id

    respond_to do |format|
      format.html {redirect_to :controller => :rounds, :action => :show, :params => {:id => @previous_round}}
      format.js
    end
  end

  def next
    @actual_round = Round.find(params[:id])
    @next_round = @actual_round.next
    @actual_round = @actual_round.id

    respond_to do |format|
      format.html {redirect_to :controller => :rounds, :action => :show, :params => {:id => @next_round}}
      format.js
    end
  end
end
