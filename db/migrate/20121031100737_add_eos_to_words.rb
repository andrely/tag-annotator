class AddEosToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :end_of_sentence_p, :boolean
  end

  def self.down
    remove_column :words, :end_of_sentence_p
  end
end
