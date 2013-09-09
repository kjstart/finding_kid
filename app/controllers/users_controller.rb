class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
	@user = User.new
   end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def show
    @user = User.find(params[:id])
    @kidcomments=@user.kid_comments.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]="Deleted User"
    redirect_to users_url
  end

  def create
    @user = User.new(user_param)
      if @user.save
        flash[:success]="Welcome to My App!" 
	sign_in @user
	redirect_to user_path(@user)
      else
         render 'new'
      end
  end

  def index
	@users=User.paginate(page: params[:page])
  end

  def edit
	@user=User.find(params[:id])
  end

  def update
	@user=User.find(params[:id])
	if @user.update_attributes(user_param)
		flash[:success]="Updated Profile"
		sign_in @user
		redirect_to @user
	else
		render 'edit'
	end
  end

  private
   
    def user_param
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)    
    end
  
    def admin_user
	redirect_to(root_path) unless current_user.admin?
    end

end
