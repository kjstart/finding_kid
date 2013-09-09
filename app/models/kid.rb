class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :kid_comments, dependent: :destroy
	#has_many :kid_places, dependent: :destroy
	#has_many :place_tags, through: :kid_places

	#validates :age, presence: true
	#,  numericality: true, inclusion: { in: 0..17 }
	#validates :gender, inclusion: %w(Male Female), allow_nil: true

	acts_as_taggable
	acts_as_taggable_on :places, :appearances

end
