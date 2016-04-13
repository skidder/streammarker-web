# Helper methods for managing user sessions
module SessionsHelper
  attr_writer :current_user

  def signed_in_user
    redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
  end

  def signed_in_admin
    redirect_to signin_path, notice: 'Please sign in.' unless signed_in? && admin?
  end

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  delegate :admin?, to: :current_user

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
