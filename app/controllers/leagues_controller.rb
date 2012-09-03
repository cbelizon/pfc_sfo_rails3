class LeaguesController < ApplicationController
  before_filter :require_admin
  after_filter :store_location
  around_filter :transactions_filter, :only => [:new_leagues, :create_calendar,
    :simulate_rounds, :next_rounds, :start_rounds, :promotion]

  #GET leagues
  #Show all seasons of all leagues of the game
  def index
    @leagues = League.all
    if !League.first.nil?
      @last_season = League.first.seasons.last
    end
    respond_to do |format|
      format.html #index.html.erb
    end
  end

  #PUT leagues/close_teams
  #Close the teams to make modifications
  def close_teams
    League.close_teams
    flash[:notice] = t("defaults.closed_teams")
    respond_to do |format|
      format.html { redirect_to leagues_path }
    end
  end

  #PUT leagees/open_teams
  #Open the teams to make modifications
  def open_teams
    League.open_teams
    respond_to do |format|
      flash[:notice] = t("defaults.opened_teams")
      format.html { redirect_to leagues_path }
    end
  end

  #POST leagues/simulate_rounds
  #Play all matchs in the actual round season
  def simulate_rounds
    League.current_seasons.each(&:simulate_round_actual!)

    respond_to do |format|
      flash[:notice] = t('defaults.simulate_rounds_success')
      format.html{ redirect_to leagues_path}
    end
  end

  #POST leagues/start_rounds
  #Start the matchs of every round in play
  def start_rounds
    League.current_seasons.each(&:start_round_actual!)

    respond_to do |format|
      flash[:notice] =  t('defaults.start_rounds_success')
      format.html{ redirect_to leagues_path}
    end
  end

  #PUT leagues/next_rounds
  #Update all management system and set a new round
  def next_rounds
    League.current_seasons.each(&:next_round!)

    respond_to do |format|
      flash[:notice] =  t('defaults.next_rounds_success')
      format.html{ redirect_to leagues_path}
    end
  end

  #POST leagues/start_seasons
  #Make the rounds for the each season in the game.
  def create_calendar
    League.current_seasons.each(&:start!)

    respond_to do |format|
      flash[:notice] = t('defaults.start_seasons_success')
      format.html{ redirect_to leagues_path}
    end
  end

  #POST leagues/new_leagues
  #Make new leagues with new user registereds
  def new_leagues
    if User.no_club.length >= League::NUM_CLUBS
      leagues = League.create_with_users_with_no_club
      respond_to do |format|
        flash[:notice] = "#{leagues.length}" + t('defaults.new_leagues_success')
        format.html {redirect_to leagues_path}
      end
    end
  end

  #POST leagues/promotion
  #Promotion and relegate the clubs on the leagues.
  def promotion
    seasons = Season.current_seasons
    if Season.finished?(seasons)
      begin
        seasons = Season.promotion_and_relegate(seasons,
        League::NUM_PROMOTIONS)
        seasons.each {|s| s.save!}
        respond_to do |format|
          flash[:notice] = t('defaults.promotion_success')
          format.html {redirect_to leagues_path}
        end
      rescue
        respond_to do |format|
          flash[:error] = t('defaults.promotion_fail')
          format.html {redirect_to leagues_path}
        end
      end
    else
      respond_to do |format|
        flash[:error] =  t('defaults.promotion_fail2')
        format.html {redirect_to leagues_path}
      end
    end
  end

  def messages
    @msgs = AdminMessages.all.reverse
    respond_to do |format|
      format.html
    end
  end

  def message_new
  end

  def message_create
    message_new = AdminMessages.new({:text_msg_en => params[:new_message][:message_en],
    :text_msg_es => params[:new_message][:message_es]})
    if message_new.save
      flash[:notice] = t('defaults.message_created')
      respond_to do |format|
        format.html {redirect_to messages_leagues_path}
      end
    else
      flash[:error] = t('defaults.message_not_created')
      respond_to do |format|
        format.html {redirect_to messages_leagues_path}
      end
    end
  end

  def message_edit
    @message = AdminMessages.find(params[:msg])
  end

  def message_modify
    @message = AdminMessages.find(params[:msg])
    @message.text_msg_en = params[:admin_messages][:text_msg_en]
    @message.text_msg_es = params[:admin_messages][:text_msg_es]

    if @message.save!
      flash[:notice] = t('defaults.message_modified')
      respond_to do |format|
        format.html {redirect_to messages_leagues_path}
      end
    else
      flash[:error] = t('defaults.message_not_modified')
      respond_to do |format|
        format.html {redirect_to messages_leagues_path}
      end
    end
  end

  def message_destroy
    msg = AdminMessages.find(params[:msg])
    if msg.destroy
      flash[:notice] = t('defaults.message_destroyed')
      respond_to do |format|
        format.html {redirect_to messages_leagues_path}
      end
    else
      flash[:error] = t('defaults.message_not_destroyed')
      format.html {redirect_to messages_leagues_path}
    end
  end
end
