module SessionsHelper

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, :notice => "please  sign in" unless signed_in?
    end
  end

  def sign_in(user)
    self.current_user = user
  end

  def sign_out
    session[:user_id] = nil
    self.current_user = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    @current_user ||=User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    if user
      session[:user_id] = user.id
    end
  end
  #We do not want to load this data after login

  def screen_dimensions(width, height)
    @screen_width = width
    @screen_height = height
    session[:screen_width] = width
    session[:screen_height] = height
  end
  def screen_width
    unless @screen_width
      @screen_width = session[:screen_width]
    end
    @screen_width
  end
  def screen_height
    unless @screen_height
      @screen_height = session[:screen_height]
    end
    @screen_height
  end
  def gnib_width
    @screen_width / 0.195 unless @screen_width.nil?
  end
  def gnib_height
    @screen_width / 0.195 unless @screen_width.nil?
  end
end
