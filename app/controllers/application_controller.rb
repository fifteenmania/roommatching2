class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  
  def current_user
    if session[:user_id]
      user = User.find { |u| u.id == session[:user_id] }
      return user
    else
      return nil
    end
  end
end
