class UsersController < ApplicationController

 before_filter :signed_in_user, :only => [:edit,:update,:index]
 before_filter :correct_user, :only => [:edit,:update]
  
  def index
      @users = User.all
  end

  def new
      @user = User.new
  end

 def create
     @user = User.new(params[:user])
     @user.avatar = params[:file]
     if @user.save
	sign_in(@user)
        redirect_to "/users/#{@user.username}"
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
