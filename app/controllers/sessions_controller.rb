class SessionsController < ApplicationController
def create
    auth = request.env['omniauth.auth']
    if auth
        #sign in normally via facebook
	data = request.env['omniauth.auth'].extra.raw_info
	unless @auth = Authorization.find_from_hash(auth)
          @auth = Authorization.create_from_hash(auth,current_user,data)
        end
        sign_in(@auth.user)
        redirect_to "/users/#{user.username}"
    else
        #sign in normally via email/password
        user = User.find_by_email(params[:session][:email])

        puts "enteredpassword #{params[:session][:password]}"
        if user && user.authenticate(params[:session][:password])
          sign_in(user)
          puts "signing in user: #{user.username}"
          puts "Username: #{user.username}"
          redirect_to "/users/#{user.username}/feed"
        else
          puts "failed to authenticate:................"
          flash.now[:error] = "Invalid email/password combination"
          redirect_to "/"
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
