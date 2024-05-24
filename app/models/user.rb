class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def self.from_token_request(request)
    email = request.params["auth"] && request.params["auth"]["email"]
    find_by email: email
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
end
