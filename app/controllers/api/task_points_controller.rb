class Api::TaskPointsController < ApplicationController
  before_filter :set_story_to_variable

  def create
    task_point = @story.task_points.find_or_initialize_by(project_task_id: params[:project_task_id])
    if task_point.new_record?
      task_point.point_50 = params[:point_50].blank? ? 0 : params[:point_50]
      task_point.point_90 = params[:point_90].blank? ? 0 : params[:point_90]
    else
      params[:point_50].present? and task_point.point_50 = params[:point_50]
      params[:point_90].present? and task_point.point_90 = params[:point_90]
    end
    task_point.save!
    render json: task_point, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
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
