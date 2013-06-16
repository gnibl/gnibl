class RelationshipsController < ApplicationController
  before_filter :signed_in_user


  def create
    @user = User.find(params[:relationship][:followed_id])
    current_url = params[:relationship][:current_url]
    current_user.follow!(@user)
    redirect_to current_url
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_url = params[:relationship][:current_url]
    current_user.unfollow(@user)
    redirect_to current_url
  end

end
