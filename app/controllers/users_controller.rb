class UsersController < ApplicationController

  before_filter :signed_in_user, :only => [:edit,:update,:index, :following, :followers]
  before_filter :correct_user, :only => [:edit,:update]

  def index
#    @users = User.all #This is no longer supported
    if params[:term]
       @users = User.find(:all, :conditions => ['name LIKE ?', "%#{params[:term]}%"])
    else
        @users = User.all #"Nairobi, Mombasa, Kisumu, Malindi, Alego, Meru, Busia"
    end
    respond_to do |format|
       format.html { render action: "new" }
       format.json { render :json => @users.to_json}
    end
end

  def new
    @user = User.new
  end

  def search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'");
    render 'index'
  end

  def next_gnibs
    @user = User.find_by_username(params[:id])
    page = params[:page]
    #get the gnibs for the page
    @gnibs = @user.feed
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def feed
    @user = User.find_by_username(params[:id])
    @gnibs = @user.feed
    @gnib_counts = @gnibs.count
    @gnib_pages = (@gnib_counts / 10).ceil;
    @gnib = @user.gnibs.build
  end

  def following
    @user = User.find_by_username(params[:id])
    @users = @user.followed_users
    render "show_follow"
  end

  def followers
    @user =  User.find_by_username(params[:id])
    @users = @user.followers
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
    @gnibs = @user.gnibs
    @gnib = @user.gnibs.build
  end

  private


  def correct_user
    @user = User.find_by_username(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
end
