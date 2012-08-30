class ClubsController < ApplicationController
  before_filter :set_club_user
  after_filter :store_location
  before_filter :require_club, :only => [:make_offer, :cancel_offer, :replace, :finances, :ticket_price,
  :received_offers, :sent_offers, :accept_offer, :reject_offer, :train_ability, :tactic]
  before_filter :require_not_propietary, :only =>[:make_offer, :cancel_offer]
  before_filter :require_propietary, :only =>
  [:replace, :finances, :ticket_price, :received_offers, :accept_offer, :reject_offer,
  :train_ability, :sent_offers, :tactic, :trainings]
  before_filter :require_open_teams, :only =>
  [:replace, :ticket_price, :make_offer,:accept_offer, :reject_offer,
  :train_ability, :cancel_offer, :tactic]

  # GET /clubs/1/team
  # GET /clubs/1/team.xml
  # Show the starters, suppliers and no convocatteds players.
  def team
    @club = Club.find(params[:id])

    respond_to do |format|
      format.html #team.html.erb
    end
  end

  def tactic
    club = Club.find(params[:id])
    club.tactic = params[:tactic]

    if club.save
      respond_to do |format|
        flash[:notice] = t('defaults.tactic_changed')
        format.html {redirect_to team_club_path}
      end
    else
      respond_to do |format|
        flash[:error] = club.errors.full_messages.join('. ')
        format.html {redirect_to team_club_path}
      end
    end

  end

  #POST/clubs/1/team
  #POST /clubs/1/.team.xml
  #Make the substitution between players
  def replace
    @club = Club.find(params[:id])

    begin
      player1 = @club.players.find(params[:replacement][:player1])
      player2 = @club.players.find(params[:replacement][:player2])
      @club.replace(player1, player2)
      respond_to do |format|
        format.html do
          flash[:notice] = t('defaults.replace_success')
          redirect_to team_club_path
        end
        format.js
      end
    rescue
      flash[:notice] = t('defaults.replace_fail')
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def finances
    @club = Club.find(params[:id])
    @last_finances = @club.last_finances

    respond_to do |format|
      format.html
    end
  end

  def ticket_price
    club = Club.find(params[:id])

    club.ticket_price = params[:club][:ticket_price]

    if club.save
      respond_to do |format|
        flash[:notice] = t('defaults.ticket_price_success') + " #{club.ticket_price}"
        format.html {redirect_to(finances_club_path)}
      end
    else
      respond_to do |format|
        flash[:error] = club.errors.full_messages.join('. ')
        format.html {redirect_to(finances_club_path)}
      end
    end
  end

  def received_offers
    @club = Club.find(params[:id])
    @offers = @club.offers_as_seller

    respond_to do |format|
      format.html
    end
  end

  def sent_offers
    @club = Club.find(params[:id])
    @offers = @club.offers_as_buyer

    respond_to do |format|
      format.html
    end
  end

  def make_offer
    club = Club.find(params[:id])
    buyer = @club_user
    player = Player.find(params[:player_id])
    offer = Offer.new({
      :seller => club,
      :buyer => buyer,
      :player => player
    })

    if offer.save
      respond_to do |format|
        flash[:notice] = t('defaults.make_offer_success')
        format.html {redirect_to(team_club_path(params[:id]))}
      end
    else
      respond_to do |format|
        flash[:error] = offer.errors.full_messages.join(". ")
        format.html {redirect_to(team_club_path(params[:id]))}
      end
    end
  end

  def accept_offer
    offer = Offer.find(params[:offer])
    offer.accept

    if offer.save
      respond_to do |format|
        flash[:notice] = t('defaults.accept_offer_success')
        format.html {redirect_to(received_offers_club_path(offer.seller))}
      end
    else
      respond_to do |format|
        flash[:error] = ''
        offer.errors.full_messages.each do |error|
          flash[:error] += error
        end
        format.html {redirect_to(received_offers_club_path(offer.seller))}
      end
    end
  end

  def reject_offer
    offer = Offer.find(params[:offer])
    offer.reject

    if offer.save
      respond_to do |format|
        flash[:notice] = ('defaults.reject_offer_success')
        format.html {redirect_to(received_offers_club_path(offer.seller))}
      end
    else
      respond_to do |format|
        flash[:error] = t('defaults.reject_offer_fail')
        format.html {redirect_to(received_offers_club_path(offer.seller))}
      end
    end
  end

  def cancel_offer
    offer = Offer.find(params[:offer])
    offer.cancel

    if offer.save
      respond_to do |format|
        flash[:notice] = t('defaults.cancel_offer_success')
        format.html {redirect_to(sent_offers_club_path(offer.buyer))}
      end
    else
      respond_to do |format|
        flash[:error] = t('defaults.cancel_offer_fail')
        format.html {redirect_to(sent_offers_club_path(offer.buyer))}
      end
    end
  end

  def train_ability
    @club = Club.find(params[:id])
    @player = Player.find(params[:player_id])
    training = @player.create_training(params[:ability])

    if training.save
      respond_to do |format|
        flash[:notice] =  t('defaults.train_ability_success')
        format.html {redirect_to trainings_club_path(@club)}
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = training.errors.full_messages.join(". ")
        format.html {redirect_to trainings_club_path(@club)}
        format.js
      end
    end
  end

  def trainings
    @club = Club.find(params[:id], :include => :players)

    respond_to do |format|
      format.html
    end
  end

  private

  def set_club_user
    @club_user = current_user.club if current_user
  end

  def require_club
    if @club_user == nil
      flash[:error] ||= t('defaults.not_assigned_club')
      redirect_back_or_default home_path
      return false
    end
  end

  def require_propietary
    unless defined?(params[:id]) and defined?(@club_user) and
      Club.find(params[:id]) == @club_user
      flash[:error] ||= t('defaults.not_propietary')
      redirect_back_or_default home_path
      return false
    end
  end

  def require_not_propietary
    unless defined?(params[:id]) and defined?(@club_user) and
      Club.find(params[:id]) != @club_user
      flash[:error] ||= t('defaults.propietary')
      redirect_back_or_default home_path
      return false
    end
  end

  def require_open_teams
    unless League.open_teams?
      flash[:error] ||= t('defaults.closed_teams')
      redirect_back_or_default home_path
      return false
    end
  end
end
