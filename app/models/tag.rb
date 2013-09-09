class Tag < ActiveRecord::Base
	# belongs_to :tag_type
	has_many :kid_tags
	has_many :kids, through: :kid_tags
end
