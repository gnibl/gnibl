class SessionsController < ApplicationController
def create  
begin  
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_hash(auth)
    @auth = Authorization.create_from_hash(auth,current_user)
    end
    self.current_user = @auth.user
    render :text => "Welcome #{current_user.name}"
rescue
end
  end
end
