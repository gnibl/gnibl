class GnibsController < ApplicationController
  before_filter :signed_in_user

def gnibstream
page = params[:page]
@gnibs = Gnib.find_by_city(current_user.city).offset(page).limit(10)
end

def gnibpicks
page = params[:page]
@gnibs = Gnib.find_by_city(current_user.city).offset(page).limit(10)
end

def titles
term = params[:term]
@gnibs = Gnib.where(
             "to_tsvector(title) @@ plainto_tsquery('"+term+"')")
respond_to do |format|
          format.js { @gnibs.to_json}
      end
end

  def comment
    @gnib_id = params[:gnib][:gnib_id]
    @user_id = current_user.id
    @descr = params[:comment]
    Comment.create(:user_id => @user_id, :gnib_id => @gnib_id, :description => @descr)
    @comments = Comment.find_by_gnib_id(@gnib_id)
    @counts = 0
    if @comments
      @counts = @comments.count
    end
    @gnib = Gnib.find(gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal"}
    end
  end

  def retcomment
    gnib_id = params[:gnib][:gnib_id]
    @comments = Comment.find_by_gnib_id(gnib_id)
    @counts = 0
    if @comments
      @counts = @comments.count
    end
    @gnib = Gnib.find(gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal" }
    end
  end

  def search
    term = params[:term]
    page = params[:page]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").offset(page).limit(10)
    @counts = @gnibs.count
    @gnib_pages = (@counts / 10).ceil;
  end
  def next_search
    term = params[:term]
    page = params[:page]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").offset(page).limit(10)
    @counts = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").count
    @gnib_pages = (@counts / 10).ceil;
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def create
    city_id = current_user.city
    title = ''
	comment = params[:gnib][:description]
        unless(comment.nil?)
	pos = -1
	title = ""
	len = comment.length
	while pos = comment.index('#',pos+1)	
	title = title+" "+ comment[pos+1..len].split(" ")[0]	
	end	     
	params[:gnib][:title] = title
	end
    @gnib = current_user.gnibs.build(params[:gnib], :city => city_id)
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
