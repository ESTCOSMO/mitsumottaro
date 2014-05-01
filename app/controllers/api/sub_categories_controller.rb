class Api::SubCategoriesController < ApplicationController
  def show
    subcat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:id])
    render json: subcat.as_json(includes_in_json), status: :ok
  end

  def create
    subcat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.build(name: params[:name])
    subcat.save!
    render json: subcat.as_json(includes_in_json), status: :ok
  end

  def update
    subcat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:id])
    subcat.update! name: params[:name]
    render json: subcat.as_json(includes_in_json), status: :ok
  end

  def move_higher
    move(:move_higher)
  end

  def move_lower
    move(:move_lower)
  end

  def move(method_name)
    sub_category = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:id])
    sub_category.send(method_name)

    render json: sub_category.as_json(includes_in_json), status: :ok
  end

  private
  def includes_in_json
    { include: { stories: { include: :task_points } } }
  end
end
