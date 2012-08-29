# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120829100702) do

  create_table "admin_messages", :force => true do |t|
    t.string   "text_msg_es", :null => false
    t.string   "text_msg_en", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "club_finances_rounds", :force => true do |t|
    t.integer  "club_id",                                                            :null => false
    t.integer  "round_id",                                                           :null => false
    t.decimal  "cash",               :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "pays_players",       :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "pays_maintenance",   :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "pays_transfers",     :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "benefits_ticket",    :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "benefits_trademark", :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "benefits_transfers", :precision => 18, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  create_table "clubs", :force => true do |t|
    t.string   "name",             :limit => 30,                                                     :null => false
    t.string   "stadium_name",     :limit => 40,                                                     :null => false
    t.integer  "stadium_capacity",                                                                   :null => false
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.integer  "user_id"
    t.decimal  "cash",                           :precision => 16, :scale => 2, :default => 0.0
    t.decimal  "ticket_price",                   :precision => 4,  :scale => 2, :default => 0.0
    t.string   "tactic",                                                        :default => "4-4-2", :null => false
  end

  create_table "clubs_seasons", :id => false, :force => true do |t|
    t.integer "club_id"
    t.integer "season_id"
  end

  create_table "leagues", :force => true do |t|
    t.integer  "category",    :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "state_teams", :default => 0
  end

  create_table "line_ups", :force => true do |t|
    t.integer  "club_id",          :null => false
    t.integer  "match_general_id", :null => false
    t.integer  "player_id",        :null => false
    t.integer  "position",         :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "match_details", :force => true do |t|
    t.integer  "player_id",        :null => false
    t.integer  "club_id",          :null => false
    t.integer  "match_general_id", :null => false
    t.string   "action",           :null => false
    t.integer  "minute",           :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "club_string"
    t.string   "player_string"
  end

  create_table "match_generals", :force => true do |t|
    t.integer  "local_id",                                                    :null => false
    t.integer  "guest_id",                                                    :null => false
    t.integer  "local_goals"
    t.integer  "guest_goals"
    t.integer  "round_id",                                                    :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "spectators",                                 :default => 0
    t.decimal  "ticket_price", :precision => 4, :scale => 2, :default => 0.0
  end

  create_table "offers", :force => true do |t|
    t.integer  "club_id",                                                    :null => false
    t.integer  "player_id",                                                  :null => false
    t.integer  "buyer_id",                                                   :null => false
    t.integer  "state",                                     :default => 0,   :null => false
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.decimal  "pay",        :precision => 16, :scale => 2, :default => 0.0
  end

  create_table "players", :force => true do |t|
    t.string   "name",       :limit => 20,                                              :null => false
    t.string   "surname",    :limit => 30,                                              :null => false
    t.integer  "quality",                                                               :null => false
    t.integer  "club_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.decimal  "pay",                      :precision => 8, :scale => 2
    t.decimal  "clause",                   :precision => 8, :scale => 2
    t.integer  "speed",                                                  :default => 0, :null => false
    t.integer  "resistance",                                             :default => 0, :null => false
    t.integer  "dribbling",                                              :default => 0, :null => false
    t.integer  "kick",                                                   :default => 0, :null => false
    t.integer  "pass",                                                   :default => 0, :null => false
    t.integer  "recovery",                                               :default => 0, :null => false
    t.integer  "goalkeeper",                                             :default => 0, :null => false
    t.integer  "position"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "season_id",                           :null => false
    t.integer  "number",                              :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "state_simulation", :default => false
    t.datetime "start_time"
  end

  create_table "seasons", :force => true do |t|
    t.integer  "league_id",                   :null => false
    t.integer  "date",                        :null => false
    t.integer  "actual_round"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "season_state", :default => 0, :null => false
  end

  create_table "trainings", :force => true do |t|
    t.integer  "player_id",   :null => false
    t.string   "ability",     :null => false
    t.integer  "improvement"
    t.integer  "round_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "admin"
    t.string   "email",             :default => "",   :null => false
    t.string   "prefer_lang",       :default => "en"
  end

end
