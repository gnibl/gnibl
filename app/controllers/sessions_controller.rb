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
redirect_to "/users/#{user.name}"
else
#sign in normally via email/password
 user = User.find_by_email(params[:session][:email])
 if user && user.authenticate(params[:session][:password])
sign_in(user)
redirect_to "/users/#{user.name}"
 else
 flash.now[:error] = "Invalid email/password combination"
 render("new")
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
