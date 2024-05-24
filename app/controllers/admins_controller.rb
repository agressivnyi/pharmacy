# app/controllers/admins_controller.rb

class AdminsController < ApplicationController
  before_action :authenticate_request
  before_action :authorize_admin

  def update
    user = User.find(params[:id])
    if user.update(is_admin: params[:is_admin])
      render json: { message: "User updated successfully" }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  private

  def authorize_admin
    render json: { error: "Access denied" }, status: :forbidden unless current_user.is_admin
  end
end
