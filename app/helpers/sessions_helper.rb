module SessionsHelper

  # Logs in the given user.
  def log_in(uid)
    session[:user_id] = uid
    @uid = uid
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    session.permanent.signed[:user_id] = user.id
    session.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user = session[:user_id]
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def testLoggedIn
    if !logged_in? or !cookies[:_yap_session] 
      return false
    else
      return true
    end
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
