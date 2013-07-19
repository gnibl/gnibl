require 'gnibl_util'
  include GniblUtil

class UsersController < ApplicationController

  before_filter :signed_in_user, :only => [:edit,:update,:index, :following, :followers]
  before_filter :correct_user, :only => [:edit,:update]

  def index    
  end

  def test
    #DEBUG remove this   
  end

  def new
    if signed_in?
      redirect_to "/users/#{current_user.html_safe_username}/feed"
      return
    end
    @user = User.new
    @cities = City.all
  end

  def next_search
    #search for users by user name - obviously
    uname = params[:uid]
    @user = current_user
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    @users = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").offset(@page).limit(9);
    @counts = User.where("\"username\" ILIKE '%"+ uname+"%' OR \"name\" ILIKE '%"+uname+"%'").count
    @page_count = (@counts / 9).ceil;
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
    @page_count = (@counts / 9).ceil;
    notifications();
    render 'index'
  end

  def taggable
    term = '%'+params[:term]+'%'
    @friends = User.where("name ILIKE :term OR username ILIKE :term OR surname ILIKE :term", :term => term)
    respond_to do |format|
      format.js { render :json => @friends.to_json}
    end
  end

  def next_gnibs
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    #get the gnibs for the page
    @gnibs = @user.gnibs.offset(@page).limit(9)
    @counts = @user.gnibs.count
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def next_feed
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    #get the gnibs for the page
    @gnibs = @user.feed.offset(@page).limit(9)
    @counts = @user.feed.count
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  def feed
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @gnibs = @user.feed.limit(9)
    @counts = @user.feed.count
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    notifications();
  end

  def following
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    #@users = @user.followed_users.limit(9)
    #    @counts = @user.followed_users.count
    #TEMPORARY
    @users = User.all
    @counts = @users.count
    @page_count = (@counts / 9).ceil;
    notifications();
    render "show_follow"
  end
  def gnibblings
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @users = @user.followed_users.limit(9)
    @counts = @user.followed_users.count
    @page_count = (@counts / 9).ceil;
    notifications();
  end
  def next_gnibblings
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    @users = @user.followed_users.offset(@page).limit(9)
    @counts = @user.followed_users.count
    @page_count = (@counts / 9).ceil;
    notifications();
    render "show_follow"
  end
  def next_following
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    @users = @user.followed_users.offset(@page).limit(9)
    @counts = @user.followed_users.count
    @page_count = (@counts / 9).ceil;
    notifications();
    respond_top do |format|
      format.js {render "shared/user"}
    end
  end

  def followers
    @user =  User.find_by_username(params[:id])
    @page = params[:page].to_i
    @current_page = @page;
    @page *= 9;
    @users = @user.followers.offset(@page).limit(9)
    @counts = @user.followers.count
    @page_count = (@counts / 9).ceil;
    notifications();
    render "show_follow"
  end


  def create
    city_id = params[:user]['city'].to_i
    @city = City.find(city_id)
    params[:user]['city'] = @city
    params[:user]['validated'] = false
    validation_code = getRandomString #random regex
    params[:user]['validation_code'] = validation_code
    @user = User.new(params[:user])
#    if @user.save
@user.save
url = request.host_with_port
      send_verification_email(url, @user)      
      @message = "check your email for instructions"      
#    end
    redirect_to("/signup")
  end

  def notifications
    @user = current_user
    @notifications = @user.notifications.where("read = :state", :state => false)
    @notifications_count = @notifications.count
  end

  def readnotifications
    not_id = params[:notification_id]
    @notification = Notification.find(not_id)
    if @notification
      @notification.update_attribute("read",true)
    end
    @user = current_user
    @notifications = @user.notifications
    @notifications_count = @notifications.where("read = :state", :state => false).count
    respond_to do |format|
      format.js {render "shared/on_notification_read"}
    end
  end
  def edit
    @user = User.find(params[:id])
  end

  def update
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
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

def validatemail
validation_code = params[:code]
@user = User.find_by_validation_code(validation_code)
if @user
@user.update_attribute("validation_code","")
@user.update_attribute("validated",true)
sign_in(@user)
    page = 0
    @gnibs = @user.redefgnibs.offset(page).limit(9)
    @counts = @user.redefgnibs.count
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    notifications();
redirect_to "/users/#{current_user.html_safe_username}/feed"
else
redirect_to "/signup"
end
end

  def show
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    page = params[:page]
    # @gnibs = @user.gnibs.offset(page).limit(9)
    @gnibs = @user.redefgnibs.offset(page).limit(9)
    @counts = @user.redefgnibs.count
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    notifications();
  end

  private
  def correct_user
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    redirect_to(root_path) unless current_user?(@user)
  end
end
