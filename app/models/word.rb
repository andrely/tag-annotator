class Word < ActiveRecord::Base
  belongs_to :sentence
  has_many :tags, :dependent => :destroy

  accepts_nested_attributes_for :tags, :allow_destroy => true
end
