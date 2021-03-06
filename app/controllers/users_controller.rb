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

  def create
    city = City.find 1
    ip = request.remote_ip
    city_id = 1
    if ip == '127.0.0.1'
      ip = '41.235.178.14' #a nairobi ip
    end
    place =  GeoIP.new("#{Rails.root}/GeoLiteCity.dat").city(ip)
    city_name = place.city_name
    city = City.where("city_name = ?",city_name).limit(1)
    unless city
      city = City.find(city_id) #default city id 1
    end
    #    params[:user]['city'] = city
    params[:user]['validated'] = 'false'
    validation_code = getRandomString #random regex
    params[:user]['validation_code'] = validation_code
    is_saved = false
    @user = User.new(params[:user])
    puts @user.validation_code
    puts @user.birthday
    begin
      is_saved = @user.save
    rescue => error
      puts error
    end
    message = " "
    if is_saved
      url = request.host_with_port
      send_verification_email(url, @user)
      message = "success"
    else
      message = "failed: "
      message = message + @user.errors.full_messages[0]
    end
    respond_to do |format|
      format.js {render :json => message.to_json}
    end

  end


  def notifications
    if current_user
      @notifications = current_user.notifications.limit(5)#.where("read = :state", :state => false)
      @notifications_count = current_user.notifications.where("read = :state", :state => false).count
    end
  end

  def new
    if signed_in?
      redirect_to "/users/#{current_user.username}/feed"
      return
    end
    @user = User.new
    @cities = City.all
    @message = params[:msg]

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
    @page_count = (@counts / 9.0).ceil;
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
    @page_count = (@counts / 9.0).ceil;
    set_gnib_count(@user)
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
    @page_count = (@counts / 9.0).ceil;
    @gnib = @user.gnibs.build
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end
  #@Kenn, this method is misplaced! Can we see if we can move it the gnib/gniblling controller without breaking anything?
  def feed
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    sent_page = params[:page]
    @current_page = 0
    if sent_page
      @current_page = sent_page.to_i
    end
    @page = @current_page * 9
    type = params[:type]
    if type
      if type == 'video'
        @gnibs = @user.feed.offset(@page).limit(9).where("video = true")
      else
        @gnibs = @user.feed.offset(@page).limit(9).where("video is null")
      end
    else
      @gnibs = @user.feed.offset(@page).limit(9)
    end
    @counts = @user.feed.count
    #Represents all feeds. This is used in the gnib modal carousel.
    #if carousel fails anywherem please ensure that this value is set.
    @all_gnibs = @user.feed
    #this value should be used for display only
    set_gnib_count(@user)
    @page_count = (@counts / 9).ceil;
    @gnib = @user.gnibs.build
    notifications();
    if sent_page
      respond_to do |format|
        format.js {render "shared/side_scroll_gnibs"}
      end
      return
    end
  end

  def set_gnib_count(user)
    regnibbed_gnibs = user.gniblings.order("updated_at DESC")
    @mygnibs_count =  Gnib.where("user_id = ? or id in (?) and video != true",user.id.to_s,regnibbed_gnibs).count
    @feed_count = user.feed.count
  end

  def gnibblings
    #show all people the user is gnibbling/following
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    sent_current_page = params[:page]
    @current_page = 0
    @page = 0;
    if sent_current_page
      @current_page = sent_current_page.to_i
      @page =  @current_page  * 10
    end
    @users = @user.followed_users.offset(@page).limit(10)
    @counts = @user.followed_users.count
    @page_count = (@counts / 10.0).ceil;
    set_gnib_count(@user)
    notifications();
    if sent_current_page
      respond_to do |format|
        format.js {render "shared/side_scroll_users"}
      end
    end
  end

  def followers
    username = User.correct_username_from_safe_html_username(params[:id])
    @user =  User.find_by_username(username)
    sent_page = params[:page]
    @page = 0
    if sent_page
      @page = sent_page.to_i
    end
    @current_page = @page;
    @page *= 10;
    @users = User.all(:offset => @page, :limit =>10)
    @counts = User.all.count
    set_gnib_count(@user)
    @page_count = (@counts / 10.0).ceil;
    notifications();
    if sent_page
      respond_to do |format|
        format.js {render "shared/side_scroll_users"}
      end
      return
    end
    render "show_follow"
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
    current_path = params[:current_path]
    if current_path.nil?
      respond_to do |format|
        format.js {render "shared/messages"}
      end
    end
    redirect_to current_path
  end
  def sendsecretcode
    puts "sending secret code"
    secretcode = getRandomString
    user_email = params[:email]
    url = request.host_with_port
    @user = User.find_by_email(user_email)
    message = ""
    if @user
      @user.update_attribute(:secretcode,secretcode)
      send_secretcode_email(url,@user)
      message = "Kindly check your email address "+user_email+" for instructions on how to log in to gnibl"
    else
      message = "That email address is not registered, kindly signup or use the email address you used to sign up"
    end
    respond_to do | format |
      format.js {render :json => message.to_json}
    end
  end

  def loginsecretcode
    validation_code = params[:code]
    puts "validation code #{validation_code}"
    @user = User.find_by_secretcode(validation_code)
    if @user
      sign_in(@user)
      redirect_to "/users/#{@user.username}"
    else
      redirect_to "/"
    end
  end

  def validateemail
    validation_code = params[:code]
    @user = User.find_by_validation_code(validation_code)
    if @user
      @user.update_attribute("validation_code","")
      @user.update_attribute("validated",true)
      sign_in(@user)
      page = 0
      @gnibs = @user.redefgnibs.offset(page).limit(9)
      @counts = @user.redefgnibs.count
      @page_count = (@counts / 9.0).ceil;
      @gnib = @user.gnibs.build
      notifications();

      #redirect_to "/users/#{current_user.html_safe_username}/feed"
    end
    redirect_to "/signin"
  end

  def show
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    @current_page = 0;
    sent_page = params[:page]
    page = 0
    if sent_page
      page_num = sent_page.to_i
      page = 9 * page_num
    end
    regnibbed_gnibs = @user.gniblings.order("updated_at DESC").offset(page).limit(9)
    type = params[:type]
    if type
      if type == 'video'
        puts 'video priv'
        @gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id)).offset(page).limit(9).where("video = true")
        @all_gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id));
        @counts =  Gnib.where("user_id = ? or id in (?) and video = true",@user.id.to_s,regnibbed_gnibs).count
      else
        puts 'articles priv'
        @gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id)).offset(page).limit(9).where("video is null")
        @all_gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id))
        @counts =  Gnib.where("user_id = ? or id in (?) and video != true",@user.id.to_s,regnibbed_gnibs).count
      end
    else
      puts 'unspecified priv'
      @gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id)).offset(page).limit(9)
      @all_gnibs = Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs.map(&:gnib_id))
      @counts =  Gnib.where("user_id = ? or id in (?)",@user.id.to_s,regnibbed_gnibs).count
    end
    # @gnibs = @user.gnibs.offset(page).limit(9)
    puts sent_page
    puts page
    puts @gnibs.count
    puts @counts
    @page_count = (@counts / 9.0).ceil;
    @gnib = @user.gnibs.build
    set_gnib_count(@user)
    notifications();
    if sent_page
      respond_to do |format|
        format.js {render "shared/side_scroll_gnibs"}
      end
      return
    end
  end

  private
  def correct_user
    username = User.correct_username_from_safe_html_username(params[:id])
    @user = User.find_by_username(username)
    redirect_to(root_path) unless current_user?(@user)
  end
end
