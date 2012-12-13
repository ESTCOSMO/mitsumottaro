class ProjectSubjectsController < ApplicationController
  before_filter :set_project_to_variable

  def move_higher
    project_subject = @project.project_subjects.find(params[:id])
    project_subject.move_higher

    redirect_to project_dashboard_path(@project)
  end

  def move_lower
    project_subject = @project.project_subjects.find(params[:id])
    project_subject.move_lower

    redirect_to project_dashboard_path(@project)
  end

  private
  def set_project_to_variable
    @project = Project.find(params[:project_id])
  end
end
