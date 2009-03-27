class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.integer :sentence_id
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :bookmarks
  end
end
