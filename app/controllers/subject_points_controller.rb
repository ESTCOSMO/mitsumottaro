class SubjectPointsController < ApplicationController
  def create
    ProjectSubject.transaction do
      small_item = Project.find(params[:project_id]).large_items.find(params[:large_item_id]).medium_items.find(params[:medium_item_id]).small_items.find(params[:small_item_id])
      subject_point = small_item.subject_points.find_by_project_subject_id(params[:subject_point][:project_subject_id])

      subject_point && subject_point.destroy
      created_subject_point = small_item.subject_points.create!(params[:subject_point])
      render nothing: true, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors.full_messages, status: :bad_request
  end
end
