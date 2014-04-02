class TaskPointsController < ApplicationController
  before_filter :set_story_to_variable
  before_filter :set_task_point_to_variable

  def create
    ProjectTask.transaction do
      @task_point && @task_point.destroy
      created_task_point = @story.task_points.create!(permitted_params_for_task_point)
      render nothing: true, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end

  def destroy
    @task_point && @task_point.destroy
    render nothing: true, status: :ok
  end

  private
  def set_story_to_variable
    @story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:story_id])
  end

  def set_task_point_to_variable
    @task_point = @story.task_points.find_by_project_task_id(params[:task_point][:project_task_id])
  end

  private
  def permitted_params_for_task_point
    params.require(:task_point).permit(:point_50, :point_90, :project_task_id)
  end
end
