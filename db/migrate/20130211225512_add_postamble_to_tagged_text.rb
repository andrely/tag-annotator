class AddPostambleToTaggedText < ActiveRecord::Migration
  def self.up
    add_column :tagged_texts, :postamble, :string
  end

  def self.down
    remove_column :tagged_texts, :postamble
  end
end
