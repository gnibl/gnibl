class SessionsController < ApplicationController
def create  
  
    auth = request.env['omniauth.auth']
   data = request.env['omniauth.auth'].extra.raw_info
    unless @auth = Authorization.find_from_hash(auth)
    @auth = Authorization.create_from_hash(auth,current_user,data)
    end
    self.current_user = @auth.user
  #  render :text => "Welcome #{current_user.name}" 
return "mypage"
  end
end
