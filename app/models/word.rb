class Word < ActiveRecord::Base
  belongs_to :sentence
  has_many :tags
end
