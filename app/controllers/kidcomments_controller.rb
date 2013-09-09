class KidcommentsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
  end

  def create
    @kid=Kid.find(params[:kid_comment][:kid_id])
    @kidcomment = @kid.kid_comments.build(kidcomment_params)
    @kidcomment.user=current_user
    if @kidcomment.save
      flash[:success] = "Added comment to kid: #{@kid.name}!"
      redirect_to @kid
    else
      	@feed_items = []
	render 'static_pages/home'
    end
  end

  def kidcomment_params
	params.require(:kid_comment).permit(:comment, :kid_id)
  end

  def destroy
	@kidcomment.destroy
	redirect_to root_url
  end

  def correct_user
	@kidcomment=current_user.kid_comments.find(params[:id])
	redirect_to root_url if @kidcomment.nil?
  end
end
