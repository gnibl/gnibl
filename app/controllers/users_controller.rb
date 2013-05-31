class UsersController < ApplicationController

 before_filter :signed_in_user, only: [:edit,:update,:index]
 before_filter :correct_user, only: [:edit,:update]
  
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
        redirect_to "/users/#{@user.name}"
     else
        render 'new'
    end
 end

  def edit
     @user = User.find(params[:id])  
  end

  def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
         flash[:success] = "Profile Updated"
         sign_in @user
         redirect_to @user
      else
          render 'edit'
      end
  end

  def show
      @user = User.find_by_name(params[:id])
      @gnibs = @user.gnibs
      @gnib = @user.gnibs.build
  end

private
  
  
  def correct_user
       @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
  end
end