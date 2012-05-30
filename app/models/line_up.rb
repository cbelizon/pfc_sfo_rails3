class LineUp < ActiveRecord::Base
  belongs_to :match_general
  belongs_to :club
  belongs_to :player
  attr_accessible :position, :match_general_id, :position, :match_general_id, :club_id, :player_id
end


# == Schema Information
#
# Table name: line_ups
#
#  id               :integer         not null, primary key
#  club_id          :integer         not null
#  match_general_id :integer         not null
#  player_id        :integer         not null
#  position         :integer         not null
#  created_at       :datetime
#  updated_at       :datetime
#

