class GnibsController < ApplicationController
  before_filter :signed_in_user

  def create
      @gnib = current_user.gnibs.build(params[:gnib])
      @gnib.image = params[:image]
      if @gnib.save
	flash[:success] = "gnib posted"
        redirect_to "/users/#{current_user.username}"
       else
       redirect_to "/users/#{current_user.username}"
      end
  end

  def destroy
  end
end
