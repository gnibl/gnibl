class GniblingsController < ApplicationController
  before_filter :signed_in_user
  def create
    gid = params[:gnibling][:gnib_id]
    current_url = params[:gnibling][:current_url]
    @current_user.like(gid)
    respond_to do |format|
      format.js
    end
  end
end
