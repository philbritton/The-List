class GiftsController < ApplicationController

  skip_before_filter :require_login, :except => [:gift, :redeem]  
		
	def index
	end
		
	def new
		@gift = Gift.new
	end
		
	def create
		user = User.first
		user.send_gift(params[:email], params[:karma], current_user.username)
	  redirect_to root_url, :notice => "Your gift has been sent."
	end
	
	def edit
	  @user = User.find_by_gift_token!(params[:id])
	end
	
	def redeem
	  @user = User.find_by_gift_token!(params[:id])
	  if @user.update_attributes(params[:user])
	    redirect_to root_url, :notice => "You account has been created"
	  else
	    render :edit
	  end
	end
end