# User model
class User < ActiveRecord::Base
  has_secure_password
  has_one :email_verification
  has_many :relays

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: { on: :save }, length: { minimum: 6 }, if: :password_digest_changed?

  def name
    "#{first_name} #{last_name}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
