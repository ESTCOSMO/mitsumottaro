class Api::CategoriesController < ApplicationController
  def show
    cat = Project.find(params[:project_id]).categories.find(params[:id])
    render json: cat.as_json(includes_in_json)
  end

  def create
    category = Project.find(params[:project_id]).categories.build(name: params[:name])
    category.save!
    render json: category.as_json(includes_in_json), status: :ok
  end
  def update
    cat = Project.find(params[:project_id]).categories.find(params[:id])
    cat.update! name: params[:name]
    render json: cat.as_json(includes_in_json), status: :ok
  end

  def move_higher
    move(:move_higher)
  end

  def move_lower
    move(:move_lower)
  end

  def move(method_name)
    category = Project.find(params[:project_id]).categories.find(params[:id])
    category.send(method_name)

    render json: category.as_json(includes_in_json), status: :ok
  end

  private
  def includes_in_json
    { include: { sub_categories: { include: { stories: { include: :task_points } } } } }
  end
end
