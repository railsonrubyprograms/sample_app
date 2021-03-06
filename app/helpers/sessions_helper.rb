module SessionsHelper

  # Logs in the given user
  def login(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  # Finds the logged in user
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  # Checks if any user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Forgets user in a permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out current user
  def logout
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects user back to stored location or to default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the location trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
