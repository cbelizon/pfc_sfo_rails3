class UsersController < ApplicationController
  before_filter :require_admin, :except => [:new, :create]
  after_filter :store_location
  require 'will_paginate/array'

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def no_club
    params[:per_page] ||= WillPaginate.per_page
    @users = User.search(params[:search]).no_club.paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver
        flash[:notice] = "Account #{@user.login} registered!"
        format.html { redirect_to :root}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def all
    params[:per_page] ||= WillPaginate.per_page
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
