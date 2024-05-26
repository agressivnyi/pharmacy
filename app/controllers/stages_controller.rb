class StagesController < ApplicationController
  before_action :set_stage, only: [:show, :update, :destroy, :change_status]

  def index
    @stages = Stage.all
    render json: @stages
  end

  def show
    render json: @stage
  end

  def create
    @stage = Stage.new(stage_params)
    if @stage.save
      attach_files
      handle_successors_and_predecessors(@stage)
      render json: @stage, status: :created, location: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  def update
    if @stage.update(stage_params)
      attach_files
      handle_successors_and_predecessors(@stage)
      render json: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @stage.destroy
    head :no_content
  end

  def change_status
    @stage.status = params[:status]
    if @stage.status == "Completed"
      create_successor_stage
    end
    if @stage.save
      render json: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  private

  def set_stage
    @stage = Stage.find(params[:id])
  end

  def stage_params
    params.require(:stage).permit(:name, :project_id, :predecessor_id, :status, :start_date, :end_date, :description, attached_files: [], performer_ids: [])
  end

  def attach_files
    if params[:attached_files].present?
      params[:attached_files].each do |file|
        @stage.attached_files.attach(file)
      end
    end
  end

  def handle_successors_and_predecessors(stage)
    if stage.predecessor_id.present?
      predecessor = Stage.find(stage.predecessor_id)
      predecessor.update(successor_id: stage.id)
    end
    if stage.successor_id.present?
      successor = Stage.find(stage.successor_id)
      successor.update(predecessor_id: stage.id)
    end
  end

  def create_successor_stage
    if @stage.successor.present?
      @stage.successor.update(status: "Started")
    end
  end
end
