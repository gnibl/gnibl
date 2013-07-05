class RelationshipsController < ApplicationController
  before_filter :signed_in_user


  def follow
    @user = User.find(params[:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.js {render "shared/inn_follow"}
    end
  end

  def unfollow
    @user = Relationship.find(params[:rel_id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.js {render "shared/inn_follow"}
    end
  end

end
