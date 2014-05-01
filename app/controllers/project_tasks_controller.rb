class ProjectTasksController < ApplicationController
  before_filter :set_project_to_variable

  def index
    @template_tasks = TemplateTask.all
  end

  def create
    @project.project_tasks.create!(permitted_params_for_project_task)
    redirect_to project_project_tasks_path(@project)
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def destroy
    @project.project_tasks.find(params[:id]).destroy
    redirect_to project_project_tasks_path(@project)
  end

  def update
    @project.project_tasks.find(params[:id]).update_attributes!(permitted_params_for_project_task)
    redirect_to project_project_tasks_path(@project)
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def move_higher
    project_task = @project.project_tasks.find(params[:id])
    project_task.move_higher

    redirect_to project_dashboard_path(@project, anchor: "/projects/#{@project.id}")
  end

  def move_lower
    project_task = @project.project_tasks.find(params[:id])
    project_task.move_lower

    redirect_to project_dashboard_path(@project, anchor: "/projects/#{@project.id}")
  end

  private
  def set_project_to_variable
    @project = Project.find(params[:project_id])
  end

  def permitted_params_for_project_task
    params.require(:project_task).permit(:name, :price_per_day)
  end
end
