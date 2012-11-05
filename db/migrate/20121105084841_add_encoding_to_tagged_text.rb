class AddEncodingToTaggedText < ActiveRecord::Migration
  def self.up
    add_column :tagged_texts, :encoding, :string
  end

  def self.down
    remove_column :tagged_texts, :encoding
  end
end
