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
      p "current user: #{@user.username}"
      @user.profile_summary = params[:user][:profile_summary]
      if (@user.save)
	 puts "saved current user profile"
         flash[:success] = "Profile Updated"
      end
      @user.save
      puts "user summary: #{@user.profile_summary}"
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
