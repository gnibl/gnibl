class GnibsController < ApplicationController
  before_filter :signed_in_user

  def gnibstream
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    @gnib = @user.gnibs.build
    render "users/gnibstream"
  end

  def gnibpicks
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    @gnib = @user.gnibs.build
    render "users/gnibpicks"
  end
  def next_gnibstream
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @gnib = @user.gnibs.build
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).offest(page).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id)
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def next_gnibpicks
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).offset(page).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def titles
    term = params[:term]
    @gnibs = Gnib.where("to_tsvector(title) @@ plainto_tsquery('"+term+"')")
    respond_to do |format|
      format.js { @gnibs.to_json}
    end
  end

  def comment
    @gnib_id = params[:gnib][:gnib_id]
    @user_id = current_user.id
    @descr = params[:comment]
    Comment.create(:user_id => @user_id, :gnib_id => @gnib_id, :description => @descr)
    @comments = Comment.where("gnib_id = #{@gnib_id}").order("created_at DESC")
    @counts = 0
    if @comments
      @counts = @comments.length
    end
    @gnib = Gnib.find(@gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal"}
    end
  end

  def retcomment
    gnib_id = params[:gnib][:gnib_id]
    @comments = Comment.where("gnib_id = #{gnib_id}").order("created_at DESC")
    @counts = 0
    if @comments
      @counts = @comments.length
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
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").offset(page).limit(9)
    @counts = @gnibs.count
    @gnib_pages = (@counts / 9).ceil;
  end
  def next_search
    term = params[:term]
    page = params[:page]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").offset(page).limit(9)
    @counts = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").count
    @gnib_pages = (@counts / 9).ceil;
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
    params[:gnib][:city] = city_id
    @gnib = current_user.gnibs.build(params[:gnib])
    @gnib.image = params[:image]
    current_url = params[:current_url]
    @success = "You have successfully posted your gnib"
    if @gnib.save
      redirect_to current_url
    else
      redirect_to "/users/#{current_user.username}"
    end
  end

  def destroy
  end
end
