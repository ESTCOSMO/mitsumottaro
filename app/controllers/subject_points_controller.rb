class SubjectPointsController < ApplicationController
  before_filter :set_story_to_variable
  before_filter :set_subject_point_to_variable

  def create
    ProjectSubject.transaction do
      @subject_point && @subject_point.destroy
      created_subject_point = @story.subject_points.create!(params[:subject_point])
      render nothing: true, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def destroy
    @subject_point && @subject_point.destroy
    render nothing: true, status: :ok
  end

  private
  def set_story_to_variable
    @story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:story_id])
  end

  def set_subject_point_to_variable
    @subject_point = @story.subject_points.find_by_project_subject_id(params[:subject_point][:project_subject_id])
  end
end
