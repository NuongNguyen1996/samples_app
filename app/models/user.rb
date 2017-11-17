class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save{email.downcase!}
  validates :name,  presence: true, length: {maximum: Settings.name.maxlength}
  validates :email, presence: true, length: {maximum: Settings.email.maxlength},
                    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: Settings.password.minlength}
end
