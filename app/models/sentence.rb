class Sentence < ActiveRecord::Base
  has_many :words
  belongs_to :taggedtext
end
