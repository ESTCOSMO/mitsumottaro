class SubjectPointsController < ApplicationController
  before_filter :set_small_item_to_variable
  before_filter :set_subject_point_to_variable

  def create
    ProjectSubject.transaction do
      @subject_point && @subject_point.destroy
      created_subject_point = @small_item.subject_points.create!(params[:subject_point])
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
  def set_small_item_to_variable
    @small_item = Project.find(params[:project_id]).large_items.find(params[:large_item_id]).medium_items.find(params[:medium_item_id]).small_items.find(params[:small_item_id])
  end

  def set_subject_point_to_variable
    @subject_point = @small_item.subject_points.find_by_project_subject_id(params[:subject_point][:project_subject_id])
  end
end
