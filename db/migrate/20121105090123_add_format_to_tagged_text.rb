class AddFormatToTaggedText < ActiveRecord::Migration
  def self.up
    add_column :tagged_texts, :format, :string
  end

  def self.down
    remove_column :tagged_texts, :format
  end
end
