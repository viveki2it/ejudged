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

ActiveRecord::Schema.define(:version => 20130430183506) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clubs", :force => true do |t|
    t.string   "ClubName",   :limit => 128, :default => "", :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "contact_infos", :force => true do |t|
    t.string   "FirstName",     :limit => 64
    t.string   "LastName",      :limit => 64
    t.string   "MiddleInitial", :limit => 64
    t.string   "Address1",      :limit => 128
    t.string   "Address2",      :limit => 128
    t.string   "Address3",      :limit => 128
    t.string   "State",         :limit => 32
    t.string   "ZipCode",       :limit => 32
    t.string   "Phone",         :limit => 32
    t.string   "AltPhone",      :limit => 32
    t.string   "Email",         :limit => 128
    t.string   "City",          :limit => 32
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "contests", :force => true do |t|
    t.string   "ContestName"
    t.integer  "judge_sheet_id"
    t.integer  "event_id"
    t.integer  "category_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "contests", ["category_id"], :name => "index_contests_on_category_id"
  add_index "contests", ["event_id"], :name => "index_contests_on_event_id"
  add_index "contests", ["judge_sheet_id"], :name => "index_contests_on_judge_sheet_id"

  create_table "customers", :force => true do |t|
    t.integer  "club_id"
    t.integer  "contact_info_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "customers", ["club_id"], :name => "index_customers_on_club_id"
  add_index "customers", ["contact_info_id"], :name => "index_customers_on_contact_info_id"

  create_table "entries", :force => true do |t|
    t.string   "RegistrationType"
    t.string   "Make"
    t.string   "Model"
    t.text     "Notes"
    t.integer  "RegistrationNumber"
    t.integer  "Score"
    t.string   "Year"
    t.integer  "contest_id"
    t.integer  "club_id"
    t.integer  "customer_id"
    t.integer  "user_id"
    t.datetime "Created"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "entries", ["club_id"], :name => "index_entries_on_club_id"
  add_index "entries", ["contest_id"], :name => "index_entries_on_contest_id"
  add_index "entries", ["customer_id"], :name => "index_entries_on_customer_id"
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "entry_specialities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.integer  "speciality_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "entry_specialities", ["entry_id"], :name => "index_entry_specialities_on_entry_id"
  add_index "entry_specialities", ["speciality_id"], :name => "index_entry_specialities_on_speciality_id"
  add_index "entry_specialities", ["user_id"], :name => "index_entry_specialities_on_user_id"

  create_table "event_specialities", :force => true do |t|
    t.integer  "event_id"
    t.integer  "speciality_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "event_specialities", ["event_id"], :name => "index_event_specialities_on_event_id"
  add_index "event_specialities", ["speciality_id"], :name => "index_event_specialities_on_speciality_id"

  create_table "events", :force => true do |t|
    t.string   "EventName",     :default => "", :null => false
    t.string   "Location",      :default => "", :null => false
    t.integer  "MainContactID"
    t.boolean  "Completed"
    t.datetime "EventDate"
    t.integer  "serie_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "events", ["serie_id"], :name => "index_events_on_serie_id"

  create_table "judge_sheets", :force => true do |t|
    t.string   "Name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "entry_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "photos", ["entry_id"], :name => "index_photos_on_entry_id"

  create_table "question_categories", :force => true do |t|
    t.string   "Name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "question_types", :force => true do |t|
    t.string   "Type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.text     "QuestionText"
    t.integer  "MinVal"
    t.integer  "MaxVal"
    t.string   "QuestionDescrip"
    t.integer  "question_category_id"
    t.integer  "question_type_id"
    t.integer  "judge_sheet_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "questions", ["judge_sheet_id"], :name => "index_questions_on_judge_sheet_id"
  add_index "questions", ["question_category_id"], :name => "index_questions_on_question_category_id"
  add_index "questions", ["question_type_id"], :name => "index_questions_on_question_type_id"

  create_table "results", :force => true do |t|
    t.integer  "Value"
    t.string   "Notes"
    t.integer  "entry_id"
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "results", ["entry_id"], :name => "index_results_on_entry_id"
  add_index "results", ["question_id"], :name => "index_results_on_question_id"
  add_index "results", ["user_id"], :name => "index_results_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "RoleName"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "series", :force => true do |t|
    t.string   "SeriesName"
    t.boolean  "Completed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specialities", :force => true do |t|
    t.string   "Type"
    t.integer  "FreezedEntry"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tokens", :force => true do |t|
    t.string   "Value"
    t.datetime "ExpirationDate"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tokens", ["user_id"], :name => "index_tokens_on_user_id"

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "Name"
    t.string   "Password"
    t.datetime "Created"
    t.integer  "contact_info_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["contact_info_id"], :name => "index_users_on_contact_info_id"

end
