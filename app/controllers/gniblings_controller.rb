class GniblingsController < ApplicationController
  before_filter :signed_in_user
  def create
    @gid = params[:gnib_id]
    @current_user.like(@gid)
    @success  = "Successfully gnibed."
    @gnib = Gnib.find(@gid)
    respond_to do |format|
      format.js {render "shared/gniblings"}
    end
  end
end
