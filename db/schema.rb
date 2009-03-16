# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090309141721) do

  create_table "sentences", :force => true do |t|
    t.integer  "text_index"
    t.integer  "text_id"
    t.integer  "length"
    t.integer  "tagged_text_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagged_texts", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.binary   "filedata",       :limit => 2147483647
    t.integer  "sentence_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "lemma"
    t.string   "string"
    t.boolean  "correct"
    t.integer  "index"
    t.integer  "word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.string   "string"
    t.integer  "sentence_index"
    t.integer  "sentence_id"
    t.integer  "tag_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
