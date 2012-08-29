# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  login             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  login_count       :integer
#  last_request_at   :datetime
#  last_login_at     :datetime
#  current_login_at  :datetime
#  last_login_ip     :string(255)
#  current_login_ip  :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  admin             :boolean
#  email             :string(255)      default(""), not null
#  prefer_lang       :string(255)      default("en")
#

class User < ActiveRecord::Base
  acts_as_authentic
  attr_protected :admin
  has_one :club

  #returns true if user is an admin
  def admin?
    self.admin
  end

  #Returns if player has an actual_round
  def round_actual?
    !self.club.round_actual.nil?
  end

  #returns if the player has a club
  def club?
    !self.club.nil?
  end

  #returns all players without club
  def self.no_club
    users = []
    User.all.each {|u| users << u if (!u.club? and !u.admin?)}
    return users
  end

  def self.search(search)
    if search
      where('login LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end


