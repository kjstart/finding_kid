class KidPlace < ActiveRecord::Base
	belongs_to :kid
	belongs_to :place_tag
end
