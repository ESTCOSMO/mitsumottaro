class Api::StoriesController < ApplicationController
  def show
    story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:id])
    render json: story.as_json(includes_in_json), status: :ok
  end

  def create
    story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.build(name: params[:name])
    story.save!
    render json: story.as_json(includes_in_json), status: :ok
  end

  def update
    story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:id])
    story.update! name: params[:name]
    render json: story.as_json(includes_in_json), status: :ok
  end


  private
  def includes_in_json
    { include: :task_points }
  end
end
