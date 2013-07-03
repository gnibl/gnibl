class UsersController < ApplicationController
  require 'gnibl_util'
  include GniblUtil

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

  def test
    #DEBUG remove this
    @gnib = Gnib.find(12)
    #m = UserMailer::invite_to_gnibl("here")
    #m.deliver
    inform_tagged_gniblers(@gnib)
  end

  def new
    if signed_in?
      redirect_to "/users/#{current_user.username}/feed"
      return
    end
    @user = User.new
    @cities = City.all
  end

  def next_search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").offset(page).limit(9);
    @counts = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").count
    respond_top do |format|
      format.js {render "shared/user"}
    end
  end
  def search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").limit(9);
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
    @gnibs = @user.gnibs.offset(page).limit(9)
    @counts = @user.gnibs.count
    @gnib_pages = (@counts / 9).ceil;
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
    @gnibs = @user.feed.offset(page).limit(9)
    @counts = @user.feed.count
    @gnib_pages = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def feed
    @user = User.find_by_username(params[:id])
    @gnibs = @user.feed.limit(9)
    puts "feed count: #{@gnibs.count} gnuibs: #{@gnibs}"
    @counts = @user.feed.count
    @gnib_pages = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
  end

  def following
    @user = User.find_by_username(params[:id])
    #@users = @user.followed_users.limit(9)
    #    @counts = @user.followed_users.count
    #TEMPORARY
    @users = User.all
    @counts = @users.count
    render "show_follow"
  end
  def next_following
    @user = User.find_by_username(params[:id])
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @users = @user.followed_users.offset(page).limit(9)
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
    @users = @user.followers.offset(page).limit(9)
    @counts = @user.followers.count
    render "show_follow"
  end


  def create
    #    params[:user]['city'] = params[:user]['city'].to_i
    city_id = params[:user]['city'].to_i
    @city = City.find(city_id)
    params[:user]['city'] = @city
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      redirect_to "/users/#{@user.username}/feed"
    else
      render 'new'
    end
  end

  def notifications
    @user = User.find_by_username(params[:id])
    page = params[:page]
    # @gnibs = @user.gnibs.offset(page).limit(9)
    @gnibs = @user.redefgnibs.offset(page).limit(9)
    @counts = @user.redefgnibs.count
    @gnib_pages = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    @notifications = @user.notifications
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
    @success = "You have successfully updated your profile"
    respond_to do |format|
      format.js {render "shared/messages"}
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    page = params[:page]
    # @gnibs = @user.gnibs.offset(page).limit(9)
    @gnibs = @user.redefgnibs.offset(page).limit(9)
    @counts = @user.redefgnibs.count
    @gnib_pages = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
  end

  private


  def correct_user
    @user = User.find_by_username(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
