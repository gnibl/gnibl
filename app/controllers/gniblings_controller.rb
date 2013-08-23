#include GniblUtil

class GniblingsController < ApplicationController
  before_filter :signed_in_user
  def create
    @gid = params[:gnib_id]
    @current_user.like(@gid)

    uid = @current_user.id
     upvotes = Upvotegnib.where("user_id = :uid and gnib_id = :gid", :uid => uid, :gid => @gid)
    @success  = "Successfully gnibed."
    @gnib = Gnib.find(@gid)
   #  send_notifications_on_regnib(@gnib,@current_user)
    @upvote_count = upvotes.size() unless upvotes.empty?;
    respond_to do |format|
      format.js {render "shared/gniblings"}
    end
  end
end
