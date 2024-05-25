class ProjectsController < ApplicationController
  before_action :authenticate_request

  def index
    @projects = Project.all
    render json: @projects.as_json(include_file_urls: true)
  end

  def show
    @project = Project.find(params[:id])
    render json: @project.as_json(include_file_urls: true)
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      attach_files(@project, params[:project][:extra_files])
      render json: @project.as_json(include_file_urls: true), status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      attach_files(@project, params[:project][:extra_files])
      render json: @project.as_json(include_file_urls: true)
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    head :no_content
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :description, :manager_id, :employee_id, :start_date, :end_date, 
      substances: [], analog: [], extras: [], extra_files: []
    )
  end

  def attach_files(project, files)
    return unless files

    files.each do |file|
      project.extra_files.attach(file)
    end
  end
end
