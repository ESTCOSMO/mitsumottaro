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

ActiveRecord::Schema.define(:version => 20121215074058) do

  create_table "categories", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_subjects", :force => true do |t|
    t.integer  "project_id"
    t.integer  "subject_id"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.integer  "price_per_day"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.decimal  "days_per_point"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "stories", :force => true do |t|
    t.integer  "sub_category_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sub_categories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subject_points", :force => true do |t|
    t.integer  "story_id"
    t.integer  "project_subject_id"
    t.integer  "point_50"
    t.integer  "point_90"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "price_per_day"
  end

end
