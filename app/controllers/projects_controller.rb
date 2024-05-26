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
    @project = Project.new(project_params.except(:employee_ids))
    @project.employees = User.where(id: project_params[:employee_ids]) if project_params[:employee_ids].present?

    if @project.save
      attach_files(@project, params[:project][:extra_files])
      render json: @project.as_json(include_file_urls: true), status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params.except(:employee_ids))
      attach_files(@project, params[:project][:extra_files])
      update_employees(@project, project_params[:employee_ids])
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
      :name, :description, :manager_id, :start_date, :end_date,
      :new_preperate, :commercial_name, :international_no_patent, :chemical_name, :project_type,
      substances: [], analog: [], extras: [], extra_files: [], employee_ids: []
    )
  end

  def attach_files(project, files)
    return unless files

    files.each do |file|
      project.extra_files.attach(file)
    end
  end

  def update_employees(project, employee_ids)
    return unless employee_ids

    current_employee_ids = project.employees.pluck(:id)
    new_employee_ids = employee_ids.map(&:to_i)

    # Add new employees
    (new_employee_ids - current_employee_ids).each do |id|
      project.employees << User.find(id)
    end

    # Remove employees not in the new list
    (current_employee_ids - new_employee_ids).each do |id|
      project.employees.delete(User.find(id))
    end
  end
end
