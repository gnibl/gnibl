class UsersController < ApplicationController

  before_filter :signed_in_user, :only => [:edit,:update,:index, :following, :followers]
  before_filter :correct_user, :only => [:edit,:update]

  def index
    #    @users = User.all #This is no longer supported
    if params[:term]
      @cities = City.find(:all, :conditions => ['city_name LIKE ?', "%#{params[:term]}%"])
    else
      @cities = City.all #"Nairobi, Mombasa, Kisumu, Malindi, Alego, Meru, Busia"
    end
    respond_to do |format|
      format.html { render :action => "new" }
      format.json { render :json => @cities.to_json}
    end
  end

  def new
    @user = User.new
  end

  def next_search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").offset(page).limit(10);
    @counts = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").count
    respond_top do |format|
      format.js {render "shared/user"}
    end
  end
  def search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").limit(10);
    @counts = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").count
    render 'index'
  end

  def next_gnibs
    @user = User.find_by_username(params[:id])
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    puts "Current page: #{page}"
    #get the gnibs for the page
    @gnibs = @user.gnibs.offset(page).limit(10)
    @counts = @user.gnibs.count
    @gnib_pages = (@counts / 10).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def next_feed
    @user = User.find_by_username(params[:id])
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    puts "Current page: #{page}"
    #get the gnibs for the page
    @gnibs = @user.feed.offset(page).limit(10)
    @counts = @user.feed.count
    @gnib_pages = (@counts / 10).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def feed
    @user = User.find_by_username(params[:id])
    @gnibs = @user.feed.limit(10)
    @counts = @user.feed.count
    @gnib_pages = (@counts / 10).ceil;
    @gnib = @user.gnibs.build
  end

  def following
    @user = User.find_by_username(params[:id])
    @users = @user.followed_users.limit(10)
    @counts = @user.followed_users.count
    render "show_follow"
  end
  def next_following
    @user = User.find_by_username(params[:id])
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @users = @user.followed_users.offset(page).limit(10)
    @counts = @user.followed_users.count
    respond_top do |format|
      format.js {render "shared/user"}
    end
  end

  def followers
    @user =  User.find_by_username(params[:id])
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @users = @user.followers.offset(page).limit(10)
    @counts = @user.followers.count
    render "show_follow"
  end


  def create
    @user = User.new(params[:user])
    @user.avatar = params[:file]
    if @user.save
      sign_in(@user)
      redirect_to "/users/#{@user.username}/feed"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find_by_username(params[:id])
    if params[:user] && params[:user][:description]
      @user.update_attribute(:description, params[:user][:description]);
    elsif params[:user] && params[:user][:avatar_url]
      @user.update_attribute(:avatar, params[:user][:avatar_url])
    end
    puts "updated user: #{@user.description}"
    puts "updated user: #{@user.avatar_url}"
    respond_to do |format|

    end
    redirect_to "/users/#{@user.username}"
  end

  def show
    @user = User.find_by_username(params[:id])
    page = params[:page]
    @gnibs = @user.gnibs.offset(page).limit(10)
    @counts = @user.gnibs.count
    @gnib_pages = (@counts / 10).ceil;
    @gnib = @user.gnibs.build
  end

  private


  def correct_user
    @user = User.find_by_username(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
