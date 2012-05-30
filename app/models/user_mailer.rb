class UserMailer < ActionMailer::Base
  def welcome_email(user)
    I18n.locale = user.prefer_lang
    recipients user.email
    from 'SFO <paliyoes@gmail.com>'
    headers  "return-path" => 'noreply@paliyoes.com'
    subject I18n.t('mail.welcome_subject')
    body :user => user, :url => "http://sfo.heroku.com"
  end
end



