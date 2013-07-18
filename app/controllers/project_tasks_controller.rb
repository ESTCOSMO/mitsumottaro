class ProjectTasksController < ApplicationController
  before_filter :set_project_to_variable

  def index
    @template_tasks = TemplateTask.all
  end

  def create
    @project.project_tasks.create!(params[:project_task])
    redirect_to project_project_tasks_path(@project)
  end

  def destroy
    @project.project_tasks.find(params[:id]).destroy
    redirect_to project_project_tasks_path(@project)
  end

  def update
    @project.project_tasks.find(params[:id]).update_attributes!(params[:project_task])
    redirect_to project_project_tasks_path(@project)
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def move_higher
    project_task = @project.project_tasks.find(params[:id])
    project_task.move_higher

    redirect_to project_dashboard_path(@project)
  end

  def move_lower
    project_task = @project.project_tasks.find(params[:id])
    project_task.move_lower

    redirect_to project_dashboard_path(@project)
  end

  private
  def set_project_to_variable
    @project = Project.find(params[:project_id])
  end
end
