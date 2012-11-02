class AddOrigStringToWord < ActiveRecord::Migration
  def self.up
    add_column :words, :orig_string, :string
  end

  def self.down
    remove_column :words, :orig_string
  end
end
