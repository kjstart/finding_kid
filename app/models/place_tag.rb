class PlaceTag < ActiveRecord::Base
	has_many :kid_places
	has_many :kids, through: :kid_places
end
