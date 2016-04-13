require 'date'
require 'json'
require 'securerandom'

# Users controller
class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :set_user, only: [:edit,
                                  :update,
                                  :change_password,
                                  :request_change_password]

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.create(user_params)
    email_confirmation_code = SecureRandom.hex(13)
    @user.email_verification = EmailVerification.new(code: email_confirmation_code)

    respond_to do |format|
      if @user.save
        sign_in @user
        UserMailer.welcome_email(@user, email_confirmation_code).deliver

        format.html do
          redirect_to dashboard_path,
                      notice: 'Your account has been created!'
        end
        format.json do
          render action: 'show', status: :created, location: @user
        end
      else
        format.html { render action: 'new' }
        format.json do
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /users/1/change_password
  # PATCH/PUT /users/1/change_password.json
  def change_password
    respond_to do |format|
      if @user.update(password:              params[:post][:password],
                      password_confirmation: params[:post][:password_confirmation],
                      force_password_change: false)
        UserMailer.password_changed(@user).deliver

        # the remeber_token value changes each time
        # the user record fields are updated
        cookies.permanent[:remember_token] = @user.remember_token
        format.html do
          redirect_to dashboard_path,
                      notice: 'Password was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(user_update_params)
        # the remeber_token value changes each time
        # the user record fields are updated
        cookies.permanent[:remember_token] = @user.remember_token
        format.html do
          redirect_to dashboard_path,
                      notice: 'User was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def user_update_params
    params
      .require(:user)
      .permit(:first_name,
              :last_name,
              :company,
              :phone_number,
              :email)
  end

  def user_params
    params
      .require(:user)
      .permit(:first_name,
              :last_name,
              :company,
              :phone_number,
              :email,
              :password,
              :password_confirmation)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
