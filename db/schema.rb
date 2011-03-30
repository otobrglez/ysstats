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

ActiveRecord::Schema.define(:version => 20110322221824) do

  create_table "dim_images", :force => true do |t|
    t.string "store", :limit => 100
    t.string "image"
  end

  create_table "dim_locations", :force => true do |t|
    t.string "country",   :limit => 100
    t.string "region",    :limit => 100
    t.string "city",      :limit => 100
    t.string "zip",       :limit => 100
    t.string "ip",        :limit => 100
    t.float  "latitude"
    t.float  "longitude"
  end

  add_index "dim_locations", ["ip"], :name => "uniq_ip", :unique => true

  create_table "dim_periods", :force => true do |t|
    t.integer "year"
    t.integer "month"
    t.integer "day"
  end

  add_index "dim_periods", ["year", "month", "day"], :name => "dim_periods_unq", :unique => true

  create_table "fact_votes", :force => true do |t|
    t.integer "dim_location_id"
    t.integer "dim_period_id"
    t.integer "dim_image_id"
    t.integer "votes"
  end

  add_index "fact_votes", ["dim_image_id"], :name => "dim_image_id_idxfk"
  add_index "fact_votes", ["dim_location_id"], :name => "dim_location_id_idxfk"
  add_index "fact_votes", ["dim_period_id"], :name => "dim_period_id_idxfk"

end
