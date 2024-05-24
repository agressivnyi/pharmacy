class ApplicationController < ActionController::API
  before_action :authenticate_request, except: [:signup, :login]

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
      puts decoded_token 
      @current_user = User.find(decoded_token[0]['id'])
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
