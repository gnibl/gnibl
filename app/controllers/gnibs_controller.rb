class GnibsController < ApplicationController
  before_filter :signed_in_user

  def comment
     @gnib_id = params[:gnib_id]
     @user_id = current_user.id
     @descr = params[:comment]
     Comment.create(:user_id => @user_id, :gnib_id => @gnib_id, :description => @descr)
     respond_to do |format|
       format.html {redirect_to current_url}
      format.js {render "shared/messages"}
     end
  end

  def retcomment
      gnib_id = params[:gnib_id]
      @comments = Comment.find_by_gnib_id(gnib_id)
      respond_to do |format|
          format.html {redirect_to current_url}
          format.js { @comments.to_json}
      end
  end

  def search
    term = params[:term]
    page = params[:page]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where(
             "to_tsvector(description) @@ plainto_tsquery('"+term+"')")
             .offset(page)
             .limit(10)
  end

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
