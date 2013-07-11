class StaticPagesController < ApplicationController
  def home
    puts "Current user#{current_user}"
    if signed_in?
      redirect_to "/users/#{current_user.html_safe_username}/feed"
      return
    end
    @user = User.new
  end

  def help
  end

  def about
  end

  def contact
  end
end
