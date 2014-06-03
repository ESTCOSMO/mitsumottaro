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
    args = {}
    params.keys.include?("name") and args[:name] = params[:name]
    params.keys.include?("remarks") and args[:remarks] = params[:remarks]

    cat.update! args
    render json: cat.as_json(includes_in_json), status: :ok
  end

  def destroy
    cat = Project.find(params[:project_id]).categories.find(params[:id]).destroy
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
    category = Project.find(params[:project_id]).categories.find(params[:id])
    category.send(method_name)

    render json: category.as_json(includes_in_json), status: :ok
  end

  def includes_in_json
    { include: { sub_categories: { include: { stories: { include: :task_points } } } } }
  end
end
