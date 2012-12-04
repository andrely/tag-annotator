class AddCapitalizedFieldToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :capitalized, :boolean
  end

  def self.down
    remove_column :tags, :capitalized
  end
end
