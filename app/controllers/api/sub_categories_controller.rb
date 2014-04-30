class Api::SubCategoriesController < ApplicationController
  def show
    cat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:id])
    render json: cat
  end

  def create
    subcat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.build(name: params[:name])
    subcat.save!
    render json: subcat.as_json(include: { stories: { include: :task_points } }), status: :ok
  end

  def update
    subcat = Project.find(params[:project_id]).categories.find(params[:category_id]).sub_categories.find(params[:id])
    subcat.update! name: params[:name]
    render json: subcat.as_json(include: { stories: { include: :task_points } }), status: :ok
  end
end
