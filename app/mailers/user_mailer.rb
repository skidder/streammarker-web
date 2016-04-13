# New user account mailer
class UserMailer < ActionMailer::Base
  default from: 'support@streammarker.com'

  def welcome_email(user, email_confirmation_code)
    @user = user
    @url = "https://www.streammarker.com/email_verification?code=#{email_confirmation_code}"
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'Validate your StreamMarker account')
  end

  def password_reset(user, new_password)
    @user = user
    @new_password = new_password
    @url = 'https://www.streammarker.com/signin'
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'StreamMarker Password Reset Request')
  end

  def password_changed(user)
    @user = user
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'StreamMarker Password Changed')
  end

  def subscription_created_email(subscription)
    @user = subscription.user
    @subscription = subscription
    @url = 'https://www.streammarker.com/signin'
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'StreamMarker Subscription Created')
  end

  def subscription_cancelled_email(user)
    @user = user
    @url  = 'https://www.streammarker.com/signin'
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'StreamMarker Subscription Cancelled')
  end

  def subscription_updated_email(subscription)
    @user = subscription.user
    @subscription = subscription
    @url = 'https://www.streammarker.com/signin'
    mail(to: @user.email_with_name,
         bcc: 'support@streammarker.com',
         subject: 'StreamMarker Subscription Updated')
  end
end
