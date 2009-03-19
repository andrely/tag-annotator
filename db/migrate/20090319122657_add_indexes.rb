class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :sentences, [ :id ]
    add_index :sentences, [ :text_index ]
    add_index :sentences, [ :text_id ]
    add_index :sentences, [ :tagged_text_id ]
    add_index :sentences, [ :text_index, :tagged_text_id ]

    add_index :words, [ :id ]
    add_index :words, [ :sentence_index ]
    add_index :words, [ :sentence_index, :sentence_id ]
    add_index :words, [ :sentence_id ]

    add_index :tags, [ :id ]
    add_index :tags, [ :index ]
    add_index :tags, [ :index, :word_id ]
    add_index :tags, [ :word_id ]
  end

  def self.down
    remove_index :sentences, [ :id ]
    remove_index :sentences, [ :text_index ]
    remove_index :sentences, [ :text_id ]
    remove_index :sentences, [ :tagged_text_id ]
    remove_index :sentences, [ :text_index, :tagged_text_id ]

    remove_index :words, [ :id ]
    remove_index :words, [ :sentence_index ]
    remove_index :words, [ :sentence_index, :sentence_id ]
    remove_index :words, [ :sentence_id ]

    remove_index :tags, [ :id ]
    remove_index :tags, [ :index ]
    remove_index :tags, [ :index, :word_id ]
    remove_index :tags, [ :word_id ]
  end
end
