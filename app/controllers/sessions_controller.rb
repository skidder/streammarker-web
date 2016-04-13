# Sessions controller
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.state == 'pending'
        if user.activation_code.nil?
          redirect_to static_pages_pending_activation_path
        else
          redirect_to request_activation_user_path(user)
        end
      elsif user.force_password_change
        redirect_to request_change_password_user_path(user)
      else
        sign_in user
        redirect_to dashboard_path
      end
    else
      flash[:error] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
