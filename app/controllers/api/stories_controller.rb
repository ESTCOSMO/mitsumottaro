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

    args = { }
    params.keys.include?("name") and args[:name] = params[:name]
    params.keys.include?("remarks") and args[:remarks] = params[:remarks]
    story.update! args
    render json: story.as_json(includes_in_json), status: :ok
  end

  def destroy
    story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:id])
    story.destroy
    render json: {}, status: :ok
  end

  def move_higher
    move(:move_higher)
  end

  def move_lower
    move(:move_lower)
  end

  private

  def move(method_name)
    story = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:sub_category_id]).stories.find(params[:id])
    story.send(method_name)

    render json: story.as_json(includes_in_json), status: :ok
  end

  def includes_in_json
    { include: :task_points }
  end
end
