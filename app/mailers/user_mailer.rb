class UserMailer < ActionMailer::Base
  default from: "SFO <paliyoes@gmail.com>"

  def welcome_email(user)
  	I18n.locale = user.prefer_lang
  	@user = user
  	@url = "http://pfc-sfo-rails3.herokuapp.com"
  	mail(:to => user.email, :subject  => t('welcome_email'))
  end
end
