class BlackjacksController < ApplicationController
  def main
  end

  

  def topten
      render json: User.find(:all, limit: 10, order: 'score desc')
  end

  def index
      @opengame=params[:opengame] 
      if @opengame == 'true' then
      	@game=Blackjack.where("blackjacks.attender is null").first()
      	if @game != nil then
      		render json: @game
      	else
      		render json: Blackjack.new
      	end
      end

  end
 
  def update
    bj=Blackjack.find(params[:id])
    bj.attenderpile=params[:attenderpile]
    bj.attenderscore=params[:attenderscore]
    attender=User.find(params[:attender][:id])
    winner=User.find(params[:winner][:id])
    bj.attender=attender
    bj.winner=winner
    bj.save()
    render json: bj
  end

  def create
      bj=Blackjack.new()
      bj.holder=User.find(params[:holder][:id])
      bj.holderscore=params[:holderscore]
      bj.holderpile=params[:holderpile]
      bj.save()
      render json: bj
  end
  
  def blackjack_params
	params.permit(:holder, :attender, :name, :holderpile, :attenderpile, :holderscore, :attenderscore, :winner)
  end

=begin
  def create
      @pile=params[:pile]
      @score=params[:point]
      @game=Blackjack.where("blackjacks.attender is null").first()
      if @game != nil
      	@game.attenderscore=@score
      	@game.attender=current_user
      	@game.attenderpile=@pile

      	@ascore=@game.holderscore
      	if @score>21 && @ascore<=21 then
   		@game.winner=@game.holder
      	end

      	if @ascore>21 && @score<=21 then
   		@game.winner=@game.attender
      	end

      	if @score>@ascore then
      		@game.winner=@game.attender
      	elsif @ascore>@score then
      		@game.winner=@game.holder
      	end

	@game.save()

      	if @game.winner != nil then
      		@user=@game.winner()
      		@user.credit+=200
      		@user.score+=200
      		@user.save()
      	end
      else
      	@game=Blackjack.new()
      	@game.holderscore=@score
      	@game.holder=current_user
      	@game.holderpile=@pile
      	@game.save()
      end

      render json: @game
  end

=end


end
