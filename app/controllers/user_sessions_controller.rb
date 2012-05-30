class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def index
    redirect_to new_user_session_path
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('defaults.login_success')
      redirect_to :root #home_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t('defaults.logout_success')
    redirect_to :root #
  end
end
