
# lib/tasks/populate.rake
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [League, Season, Round, Club, Player, MatchGeneral].each(&:delete_all)
    count_league = 1
    count_season = 2009
    League.populate 2 do |league|
      league.category = count_league
      count_league += 1
      Season.populate 1 do |season|
        season.date = count_season
        season.league_id = league.id
        season.season_state = 0
        season.alineations_state = 1
        Club.populate 10 do |club|
          club.name = Faker::Address.city + " F. C."
          club.stadium_name = Faker::Address.street_name
          club.stadium_capacity = 20000 + rand(60000)
          count_position = 1
          Player.populate 25 do |player|
            player.club_id = club.id
            player.name = Faker::Name.first_name
            player.surname = Faker::Name.last_name
            player.max_speed = 1 + rand(99)
            player.max_resistance = 1 + rand(99)
            player.max_dribbling = 1 + rand(99)
            player.max_kick = 1 + rand(99)
            player.max_pass = 1 + rand(99)
            player.max_recovery = 1 + rand(99)
            player.max_goalkeeper = 1 + rand(99)
            player.max_age = 32 + rand(8)
            player.speed = 1 + rand(player.max_speed - 1)
            player.resistance = 1 + rand(player.max_resistance - 1)
            player.dribbling = 1 + rand(player.max_dribbling - 1)
            player.kick = 1 + rand(player.max_kick - 1)
            player.pass = 1 + rand(player.max_pass - 1)
            player.recovery = 1 + rand(player.max_recovery - 1)
            player.goalkeeper = 1 + rand(player.max_goalkeeper - 1)
            player.age = 16 + rand(player.max_age - 1)
            player.quality = (player.speed + player.resistance +
                player.dribbling + player.kick + player.pass + player.recovery +
                player.goalkeeper) / 7
            player.clause = (player.quality * 100).to_i
            player.pay = (player.quality * 10).to_i
            player.position = count_position
            count_position += 1
          end
        end
      end
    end
    Club.populate 20 do |club|
      club.name = Faker::Address.city + " F. C."
      club.stadium_name = Faker::Address.street_name
      club.stadium_capacity = 20000 + rand(60000)
      count_position = 1
      Player.populate 25 do |player|
        player.club_id = club.id
        player.name = Faker::Name.first_name
        player.surname = Faker::Name.last_name
        player.max_speed = 1 + rand(99)
        player.max_resistance = 1 + rand(99)
        player.max_dribbling = 1 + rand(99)
        player.max_kick = 1 + rand(99)
        player.max_pass = 1 + rand(99)
        player.max_recovery = 1 + rand(99)
        player.max_goalkeeper = 1 + rand(99)
        player.max_age = 32 + rand(8)
        player.speed = 1 + rand(player.max_speed - 1)
        player.resistance = 1 + rand(player.max_resistance - 1)
        player.dribbling = 1 + rand(player.max_dribbling - 1)
        player.kick = 1 + rand(player.max_kick - 1)
        player.pass = 1 + rand(player.max_pass - 1)
        player.recovery = 1 + rand(player.max_recovery - 1)
        player.goalkeeper = 1 + rand(player.max_goalkeeper - 1)
        player.age = 1 + rand(player.max_age - 1)
        player.quality = (player.speed + player.resistance +
            player.dribbling + player.kick + player.pass + player.recovery +
            player.goalkeeper) / 7
        player.clause = (player.quality * 100).to_i
        player.pay = (player.quality * 10).to_i
        player.position = count_position
        count_position += 1
      end
    end
  end
end
