class GniblingsController < ApplicationController
  before_filter :signed_in_user
  def create
    @gid = params[:gnibling][:gnib_id]
    current_url = params[:gnibling][:current_url]
    @current_user.like(@gid)
    @success  = "Successfully gnibed."
    @gnib = Gnib.find(@gid)
    respond_to do |format|
      format.html {redirect_to current_url}
      format.js {render "shared/gniblings"}
    end
  end
end
