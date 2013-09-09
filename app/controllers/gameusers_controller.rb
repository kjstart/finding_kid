class GameusersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@attrs={id: @user.id, name: @user.name, credit: @user.credit, score: @user.score}
		render json: @attrs
	end

	def topten
		@users=User.find(:all, limit: 10, order: 'credit desc')
		@userlist = @users.map do |u|
  			{ :id => u.id, :name => u.name, :credit => u.credit, :score => u.score }
  		end
  		render json: @userlist
  	end

	def index
		@uid=params[:id]
		if @uid then
			@users=User.select("id,name,credit,score").where("id="+@uid)
		else
			@users=User.select("id,name,credit,score").order("credit desc")
		end

		@userlist = @users.map do |u|
			if current_user?(u)
  				{ :id => u.id, :name => u.name, :credit => u.credit, :score => u.score, :curuser => true }
  			else
  				{ :id => u.id, :name => u.name, :credit => u.credit, :score => u.score, :curuser => false }
  			end
  		end

  		render json: @userlist
  	end

  	def update
  		@user=User.find(params[:id])
  		@user.credit=params[:credit]
  		@user.score=params[:score]
  		@user.save()
  	end

  	def getuser
		@user = current_user
		@attrs={id: @user.id, name: @user.name, credit: @user.credit, score: @user.score}
		render json: @attrs
  	end
end
