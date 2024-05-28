class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, length: { maximum: 50 }, allow_nil: true

  attribute :password, :string, default: nil
  attribute :name, :string, default: nil

  has_many :managed_projects, class_name: 'Project', foreign_key: 'manager_id'
  has_and_belongs_to_many :assigned_projects, class_name: 'Project', join_table: 'projects_users'
  has_and_belongs_to_many :performing_stages, class_name: 'Stage', join_table: 'performers_stages'
  has_many :comments
  has_and_belongs_to_many :tasks, join_table: 'stage_tasks', foreign_key: 'performer_id'

  def self.from_token_request(request)
    email = request.params["auth"] && request.params["auth"]["email"]
    find_by email: email
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end
