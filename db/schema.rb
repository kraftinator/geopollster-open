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

ActiveRecord::Schema.define(:version => 20120917181819) do

  create_table "cached_checkins", :force => true do |t|
    t.string   "foursquare_guid", :null => false
    t.integer  "user_id",         :null => false
    t.integer  "venue_id"
    t.string   "venue_name"
    t.datetime "checked_in_at"
    t.datetime "created_at"
  end

  create_table "cached_friends", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.string   "foursquare_guid",                 :null => false
    t.string   "last_checkin_guid"
    t.string   "twitter_handle",    :limit => 15
    t.string   "first_name",                      :null => false
    t.string   "last_name",                       :null => false
    t.string   "photo_url"
    t.integer  "gender_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string  "foursquare_guid"
    t.string  "name",            :limit => 50,                    :null => false
    t.string  "display_name",    :limit => 50,                    :null => false
    t.string  "icon_url",        :limit => 100,                   :null => false
    t.integer "parent_id"
    t.boolean "eligible",                       :default => true, :null => false
    t.boolean "notify",                         :default => true, :null => false
    t.integer "party_id"
    t.string  "url_slug",        :limit => 50,                    :null => false
  end

  create_table "checkins", :force => true do |t|
    t.string   "foursquare_guid", :null => false
    t.integer  "user_id",         :null => false
    t.integer  "venue_id",        :null => false
    t.datetime "checked_in_at"
    t.datetime "created_at"
  end

  create_table "cities", :force => true do |t|
    t.string  "name",     :limit => 50, :null => false
    t.integer "state_id",               :null => false
    t.integer "party_id"
  end

  create_table "companies", :force => true do |t|
    t.string  "name",           :limit => 50, :null => false
    t.string  "short_name",     :limit => 50
    t.string  "twitter_handle", :limit => 15
    t.string  "url",            :limit => 50
    t.string  "sunlight_guid"
    t.string  "url_slug",       :limit => 50
    t.integer "parent_id"
  end

  create_table "company_names", :force => true do |t|
    t.integer "company_id",                :null => false
    t.string  "name",       :limit => 100, :null => false
  end

  create_table "countries", :force => true do |t|
    t.string  "code",     :limit => 2,   :null => false
    t.string  "name",     :limit => 100, :null => false
    t.integer "party_id"
  end

  create_table "friend_checkins", :force => true do |t|
    t.string   "foursquare_checkin_guid",               :null => false
    t.string   "foursquare_user_guid",                  :null => false
    t.string   "first_name",                            :null => false
    t.string   "last_name",                             :null => false
    t.string   "photo_url"
    t.string   "twitter_handle",          :limit => 15
    t.string   "facebook_guid"
    t.integer  "venue_id"
    t.string   "venue_name"
    t.integer  "company_id"
    t.integer  "user_id",                               :null => false
    t.datetime "checked_in_at"
    t.datetime "created_at"
  end

  create_table "genders", :force => true do |t|
    t.string "name",   :limit => 10, :null => false
    t.string "abbrev", :limit => 1,  :null => false
  end

  create_table "ideologies", :force => true do |t|
    t.string "name", :limit => 50,                  :null => false
    t.string "url",  :limit => 100, :default => "", :null => false
  end

  create_table "mobile_devices", :force => true do |t|
    t.string   "foursquare_name", :limit => 50,                    :null => false
    t.string   "display_name",    :limit => 50,                    :null => false
    t.datetime "created_at"
    t.boolean  "eligible",                      :default => false
  end

  create_table "parties", :force => true do |t|
    t.string "name",               :limit => 50,                  :null => false
    t.string "official_name",      :limit => 50,                  :null => false
    t.string "member_name",        :limit => 50,                  :null => false
    t.string "member_name_plural", :limit => 50,                  :null => false
    t.string "icon_url",           :limit => 100, :default => "", :null => false
    t.string "description",        :limit => 500, :default => ""
    t.string "official_url",       :limit => 100, :default => ""
    t.string "facebook_url",       :limit => 100, :default => ""
    t.string "twitter_url",        :limit => 100, :default => ""
    t.string "youtube_url",        :limit => 100, :default => ""
    t.string "wikipedia_url",      :limit => 100, :default => ""
    t.string "url_slug",           :limit => 40,                  :null => false
  end

  create_table "party_contributions", :force => true do |t|
    t.integer "company_id",                    :null => false
    t.float   "dem_amount",   :default => 0.0, :null => false
    t.float   "rep_amount",   :default => 0.0, :null => false
    t.float   "other_amount", :default => 0.0, :null => false
  end

  create_table "party_ideologies", :force => true do |t|
    t.integer "party_id",    :null => false
    t.integer "ideology_id", :null => false
  end

  create_table "points", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "dem_total",      :default => 0, :null => false
    t.integer  "rep_total",      :default => 0, :null => false
    t.datetime "updated_at"
    t.integer  "dem_company_id"
    t.integer  "rep_company_id"
  end

  create_table "power_changes", :force => true do |t|
    t.integer  "object_id",                      :null => false
    t.string   "object_type",      :limit => 50, :null => false
    t.integer  "winning_party_id",               :null => false
    t.integer  "losing_party_id"
    t.datetime "created_at"
  end

  create_table "states", :force => true do |t|
    t.string  "name",              :limit => 30,                :null => false
    t.string  "abbrev",            :limit => 2,                 :null => false
    t.integer "electoral_college",               :default => 0
    t.integer "country_id",                                     :null => false
    t.integer "party_id"
    t.string  "url_slug",          :limit => 30,                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "foursquare_guid",                            :null => false
    t.string   "foursquare_access_token",                    :null => false
    t.string   "first_name",                                 :null => false
    t.datetime "last_login"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gender_id",                                  :null => false
    t.string   "photo_url"
    t.string   "last_name",               :default => "",    :null => false
    t.string   "email",                                      :null => false
    t.boolean  "public_profile",          :default => true,  :null => false
    t.boolean  "connected_app_notify",    :default => true,  :null => false
    t.boolean  "post_to_checkin",         :default => true,  :null => false
    t.boolean  "email_notify",            :default => true,  :null => false
    t.boolean  "active",                  :default => false, :null => false
    t.integer  "country_id"
    t.integer  "zip_code_id"
    t.integer  "party_id"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_secret"
  end

  create_table "venues", :force => true do |t|
    t.string  "foursquare_guid", :null => false
    t.string  "name",            :null => false
    t.integer "company_id"
    t.integer "country_id",      :null => false
    t.integer "category_id"
    t.integer "zip_code_id"
    t.integer "party_id"
  end

  create_table "vote_counts", :force => true do |t|
    t.integer "object_id",                 :null => false
    t.string  "object_type", :limit => 50, :null => false
    t.integer "party_id",                  :null => false
    t.integer "total",                     :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "checkin_id",       :null => false
    t.integer  "party_id",         :null => false
    t.integer  "gender_id",        :null => false
    t.integer  "mobile_device_id"
    t.datetime "created_at"
  end

  create_table "zip_codes", :force => true do |t|
    t.string  "name",    :limit => 5, :null => false
    t.integer "city_id",              :null => false
  end

end
