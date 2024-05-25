class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  has_many :managed_projects, class_name: 'Project', foreign_key: 'manager_id'
  has_many :assigned_projects, class_name: 'Project', foreign_key: 'employee_id'

  def self.from_token_request(request)
    email = request.params["auth"] && request.params["auth"]["email"]
    find_by email: email
  end
  
  def generate_jwt
    JWT.encode({ id: id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end
