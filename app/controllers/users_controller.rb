class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]

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

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
