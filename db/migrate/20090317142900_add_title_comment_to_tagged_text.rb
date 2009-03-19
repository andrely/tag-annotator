class AddTitleCommentToTaggedText < ActiveRecord::Migration
  def self.up
    add_column :tagged_texts, :title, :string
    add_column :tagged_texts, :comment, :text
  end

  def self.down
    remove_column :tagged_texts, :comment
    remove_column :tagged_texts, :title
  end
end
