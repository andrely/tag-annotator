class AddSentenceDelimiterToTaggedTexts < ActiveRecord::Migration
  def self.up
    add_column :tagged_texts, :sentence_delimiter, :string
  end

  def self.down
    remove_column :tagged_texts, :sentence_delimiter
  end
end
