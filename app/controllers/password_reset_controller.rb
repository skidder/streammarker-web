# Password Reset controller
require 'securerandom'
class PasswordResetController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # find the user account
    respond_to do |format|
      user = User.where(email: user_params[:email]).first
      if user
        new_password = SecureRandom.hex(13)
        user.update_attributes(password:              new_password,
                               password_confirmation: new_password,
                               force_password_change: true)
        UserMailer.password_reset(user, new_password).deliver
        format.html do
          redirect_to static_pages_home_path,
                      notice: 'An email has been sent with password reset instructions.'
        end
        format.json { head :no_content }
      else
        flash[:error] = 'No account exists with the email address specified, please try again.'
        format.html { render action: 'reset_password' }
        format.json do
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:email)
  end
end
