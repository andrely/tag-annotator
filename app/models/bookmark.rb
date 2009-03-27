class Bookmark < ActiveRecord::Base
  belongs_to :tagged_text
end
