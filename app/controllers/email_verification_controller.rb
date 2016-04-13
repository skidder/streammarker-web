require 'date'
require 'json'

# Email Verification controller
class EmailVerificationController < ApplicationController
  before_action :signed_in_user
  before_action :set_user
  before_action :confirm_code

  # GET /email_verification
  def verify
    @user.email_verification.update_attributes(code: nil, verified: true, last_verified_at: Time.now)
    redirect_to dashboard_path, notice: 'Your email address has been verified, thank you!'
  end

  private

  def confirm_code
    if @user.email_verification.nil? || email_verification_params['code'] != @user.email_verification.code
      flash[:error] = 'Email verification code did not match, sorry'
      redirect_to root_url # halts request cycle
    end
  end

  def email_verification_params
    params.permit(:code)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
