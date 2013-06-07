class StaticPagesController < ApplicationController
  def home
#	if signed_in?
#	  @user = current_user()
#	  redirect_to "/users/#{@user.username}"
#	  return
#	end
	@user = User.new 
  end

  def help
  end

  def about
  end

  def contact
  end
end
