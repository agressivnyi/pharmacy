class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy, :change_status]

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      attach_files
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      attach_files
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  def change_status
    @task.status = params[:status]
    if @task.status == "Completed" && @task.subtasks.any? { |subtask| subtask.status != "Completed" }
      render json: { error: "Cannot complete task with incomplete subtasks" }, status: :unprocessable_entity
    elsif @task.save
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :start_date, :end_date, :stage_id, :performer_id, :parent_task_id, attached_files: [])
  end

  def attach_files
    if params[:attached_files].present?
      params[:attached_files].each do |file|
        @task.attached_files.attach(file)
      end
    end
  end
end
