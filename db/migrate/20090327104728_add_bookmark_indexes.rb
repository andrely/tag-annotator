class AddBookmarkIndexes < ActiveRecord::Migration
  def self.up
    add_index :bookmarks, [:id]
    add_index :bookmarks, [:id, :tagged_text_id]
    add_index :bookmarks, [:tagged_text_id]
  end

  def self.down
    remove_index :bookmarks, [:id]
    remove_index :bookmarks, [:id, :tagged_text_id]
    remove_index :bookmarks, [:tagged_text_id]
  end
end
