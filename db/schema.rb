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

ActiveRecord::Schema.define(:version => 20090327104728) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "sentence_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tagged_text_id"
  end

  add_index "bookmarks", ["id", "tagged_text_id"], :name => "index_bookmarks_on_id_and_tagged_text_id"
  add_index "bookmarks", ["id"], :name => "index_bookmarks_on_id"
  add_index "bookmarks", ["tagged_text_id"], :name => "index_bookmarks_on_tagged_text_id"

  create_table "sentences", :force => true do |t|
    t.integer  "text_index"
    t.integer  "text_id"
    t.integer  "length"
    t.integer  "tagged_text_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sentences", ["id"], :name => "index_sentences_on_id"
  add_index "sentences", ["tagged_text_id"], :name => "index_sentences_on_tagged_text_id"
  add_index "sentences", ["text_id"], :name => "index_sentences_on_text_id"
  add_index "sentences", ["text_index", "tagged_text_id"], :name => "index_sentences_on_text_index_and_tagged_text_id"
  add_index "sentences", ["text_index"], :name => "index_sentences_on_text_index"

  create_table "tagged_texts", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.binary   "filedata",       :limit => 20971520
    t.integer  "sentence_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "comment"
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

  add_index "tags", ["id"], :name => "index_tags_on_id"
  add_index "tags", ["index", "word_id"], :name => "index_tags_on_index_and_word_id"
  add_index "tags", ["index"], :name => "index_tags_on_index"
  add_index "tags", ["word_id"], :name => "index_tags_on_word_id"

  create_table "words", :force => true do |t|
    t.string   "string"
    t.integer  "sentence_index"
    t.integer  "sentence_id"
    t.integer  "tag_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "words", ["id"], :name => "index_words_on_id"
  add_index "words", ["sentence_id"], :name => "index_words_on_sentence_id"
  add_index "words", ["sentence_index", "sentence_id"], :name => "index_words_on_sentence_index_and_sentence_id"
  add_index "words", ["sentence_index"], :name => "index_words_on_sentence_index"

end
