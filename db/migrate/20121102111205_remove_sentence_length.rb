class RemoveSentenceLength < ActiveRecord::Migration
  def self.up
    remove_column :sentences, :length
  end

  def self.down
    add_column :sentences, :length, :integer
  end
end
