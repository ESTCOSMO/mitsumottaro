class Api::TaskPointsController < ApplicationController
  before_filter :set_story_to_variable

  def create
    task_point = @story.task_points.find_or_initialize_by(project_task_id: params[:project_task_id])
    params.keys.include?('point_50') and task_point.point_50 = params[:point_50]
    params.keys.include?('point_90') and task_point.point_90 = params[:point_90]

    if task_point.point_50.blank? && task_point.point_90.blank?
      task_point.destroy if task_point.persisted?
    else
      task_point.save!
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :bad_request
  end

  def destroy
    task_point = @story.task_points.where(project_task_id: params[:project_task_id]).first
    task_point && task_point.destroy
    render nothing: true, status: :ok
  end

  private
  def set_story_to_variable
    @story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:story_id])
  end
end
