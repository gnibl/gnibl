class GniblingsController < ApplicationController
before_filter :signed_in_user
def create
gid = params[:gnibling][:gnib_id]
@current_user.like(gid)
respond_to do |format|
   format.html{ redirect_to "/users/#{@current_user.username}" }
   format.js
   end
 end
end
