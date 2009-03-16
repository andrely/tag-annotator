class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :lemma
      t.string :string
      t.boolean :correct
      t.integer :index

      t.integer :word_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
