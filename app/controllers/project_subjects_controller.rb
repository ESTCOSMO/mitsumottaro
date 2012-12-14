class ProjectSubjectsController < ApplicationController
  before_filter :set_project_to_variable

  def index
    @template_subjects = Subject.all
  end

  def create
    template_subject = Subject.find(params[:subject_id])
    @project.project_subjects.create!(subject_id: template_subject.id,
                                      name: template_subject.name,
                                      price_per_day: template_subject.price_per_day)
    redirect_to project_project_subjects_path(@project)
  end

  def destroy
    @project.project_subjects.find(params[:id]).destroy
    redirect_to project_project_subjects_path(@project)
  end

  def update
    @project.project_subjects.find(params[:id]).update_attributes!(params[:project_subject])
    redirect_to project_project_subjects_path(@project)
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

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
