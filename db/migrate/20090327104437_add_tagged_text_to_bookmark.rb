class AddTaggedTextToBookmark < ActiveRecord::Migration
  def self.up
    add_column :bookmarks, :tagged_text_id, :integer
  end

  def self.down
    remove_column :bookmarks, :tagged_text_id
  end
end
