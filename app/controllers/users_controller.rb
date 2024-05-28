class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]
  before_action :admin_only, only: [:create, :register_and_send_email]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { token: @user.generate_jwt }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      render json: { token: @user.generate_jwt }, status: :ok
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  def register_and_send_email
    @user = User.find_by(email: params[:email])
    if @user.nil?
      @user = User.new(email: params[:email], password: SecureRandom.hex(10), name: 'Temporary Name')
      if @user.save
        token = @user.generate_jwt
        UserMailer.registration_email(@user, token).deliver_now
        render json: { message: 'Registration email sent' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      token = @user.generate_jwt
      UserMailer.registration_email(@user, token).deliver_now
      render json: { message: 'User already exists. Registration email sent again.' }, status: :ok
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def admin_only
    unless current_user.is_admin?
      render json: { errors: ['Unauthorized access'] }, status: :unauthorized
    end
  end
end
