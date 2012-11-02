class AddPreambleToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :preamble, :text
  end

  def self.down
    remove_column :words, :preamble
  end
end
