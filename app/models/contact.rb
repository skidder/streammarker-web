# Contact form
class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :phone_number
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message
  attribute :nickname, captcha: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: '[Prod] Contact Us',
      to: 'support@streammarker.com',
      from: %("#{name}" <#{email}>)
    }
  end
end
