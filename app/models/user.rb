class User < ApplicationRecord
  before_create :set_confirmation_token

  validates :name,
  presence: true,
    length: { in: 8..72}

  validates :email,
  presence: true,
  uniqueness: {case_sensitive: false}

  validates :password,
  length: { in: 8..72},
  on: :create

  has_secure_password

  def self.authenticate(params)
    User.find_by_email(params[:email]).try(:authenticate, params[:password])
  end

  def email_activate
    self.email_confirmed = 1
    self.confirm_token = nil
    save!(:validate => false)
  end

  private

  def set_confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
