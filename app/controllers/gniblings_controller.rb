class GniblingsController < ApplicationController
  before_filter :signed_in_user
  def create
    gid = params[:gnibling][:gnib_id]
    current_url = params[:gnibling][:current_url]
    puts "Current url: #{current_url}"
    @current_user.like(gid)
    redirect_to current_url
  end
end
