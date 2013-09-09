class KidsController < ApplicationController

	before_action :signed_in_user
  	before_action :correct_user, only: [:edit, :update, :destroy]
  def new
  	@kid=Kid.new
  end

  def edit
	@kid=Kid.find(params[:id])
  end

  def destroy
    Kid.find(params[:id]).destroy
    flash[:success]="Deleted Kid"
    redirect_to kids_url
  end

  def show
    @kid = Kid.find(params[:id])
    @kidcomment=@kid.kid_comments.build
    @kidcomments = @kid.kid_comments.paginate(page: params[:page])
  end

  def index
  if params[:tag]
    @kids = Kid.tagged_with(params[:tag]).paginate(page: params[:page])
  else
    @kids = Kid.paginate(page: params[:page])
  end
  end

  def create
      @kid =current_user.kids.new(kid_param)
      #@kid.picture = @kid.picture.new(picture_params)
\
      if @kid.save
        flash[:success]="Successful reported kid!" 
	redirect_to kid_path(@kid)
      else
         render 'new'
      end
  end

  private

    def kid_param
      params.require(:kid).permit(:name,:gender,:age,:time, :appearance_list, :place_list, :tags, :picture,:credits,:lost, :picture_file_name)
    end

        def picture_param
      params.require(:kid).permit(:picture, :picture_file_name)
    end

      def correct_user
      @kid = Kid.find(params[:id])
      redirect_to(root_path) unless current_user.kids.find(@kid)    
      end
end
