class RelationshipsController < ApplicationController
  before_filter :signed_in_user


  def create
    @user = User.find(params[:relationship][:followed_id])
    current_url = params[:relationship][:current_url]
    user_view = params[:relationship][:user_view]
    puts "user_view #{user_view}"
    current_user.follow!(@user)
    respond_to do |format|
      if(!user_view.nil?)
        format.js {render "shared/follow"}
      else
        format.js {render "shared/inn_follow"}
      end
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_url = params[:relationship][:current_url]
    user_view = params[:relationship][:user_view]
    puts "user_view #{user_view}"
    current_user.unfollow(@user)
    respond_to do |format|
      if(!user_view.nil?)
        format.js {render "shared/follow"}
      else
        format.js {render "shared/inn_follow"}
      end
    end
  end

end
