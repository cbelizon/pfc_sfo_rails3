# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale
  require 'authlogic'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :passwordhttp://localhost:3000/user_sessions
  #filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :current_season
  WillPaginate.per_page = 10
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_season
    Season.current_seasons.first
  end
  #return the current user session
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  #return the current user
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  #return false if you're not logged in
  def require_user
      unless current_user
        store_location
        flash[:notice] = t('defaults.require_user')
        redirect_to new_user_session_url
        return false
      end
  end

   #return false if you're not an admin logged in
  def require_admin
    unless current_user && current_user.admin?
      store_location
      flash[:notice] = t("defaults.require_admin")
      redirect_to new_user_session_url
      return false
    end
  end

  #save the action who we are
  def store_location
      session[:return_to] = request.fullpath
  end

  #Keep the previous location
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end