class GnibsController < ApplicationController
  before_filter :signed_in_user

  def search
    term = params[:term]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')")
    @gnib_counts = @gnibs.count
    @gnib_pages = (@gnib_counts / 10).ceil;
  end

  def create
    @gnib = current_user.gnibs.build(params[:gnib])
    @gnib.image = params[:image]
    current_url = params[:current_url]
    @success = "You have successfully posted your gnib"
    if @gnib.save
      respond_to do |format|
        format.html{redirect_to current_url}
        format.js {render "shared/gnib"}
      end
    else
      redirect_to "/users/#{current_user.username}"
    end
  end

  def destroy
  end
end
