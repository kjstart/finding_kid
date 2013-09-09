class KidComment < ActiveRecord::Base
	belongs_to :kid
	belongs_to :user

  def self.user_kid_comments(user)
      where("id in (select id from kid_comments where kid_id in (select id from kids where user_id=:user_id) )",user_id: user.id)
  end
end
