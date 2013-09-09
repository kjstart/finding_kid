class KidTag < ActiveRecord::Base
	belongs_to :kid
	belongs_to :tag
end
