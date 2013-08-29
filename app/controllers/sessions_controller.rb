class SessionsController < ApplicationController
  def create
    puts "Current user#{current_user}"
    if signed_in?
      redirect_to "/users/#{current_user.html_safe_username}/feed"
      return
    end
    auth = request.env['omniauth.auth']
    if auth
      #sign in normally via facebook
      data = request.env['omniauth.auth'].extra.raw_info
      unless @auth = Authorization.find_from_hash(auth)
        @auth = Authorization.create_from_hash(auth,current_user,data)
      end
      sign_in(@auth.user)
      redirect_to "/users/#{user.html_safe_username}"
    else
      #sign in normally via email/password
      user = User.find_by_email(params[:session][:email])
      puts "enteredpassword #{params[:session][:password]}"
      if user && user.validated && user.authenticate(params[:session][:password])
        sign_in(user)
        puts "signing in user: #{user.html_safe_username}"
        puts "Username: #{user.html_safe_username}"
        redirect_to "/users/#{user.username}/feed"
      else
   #     user = User.find_by_username('guest')
   #     sign_in(user)
        puts "failed to authenticate:................"
        flash.now[:error] = "Invalid email/password combination"
        redirect_to "/"
        redirect_to "/users/#{user.username}/feed"
      end
    end
  end
  def new
  end
  def destroy
    sign_out
    redirect_to '/'
  end
end
