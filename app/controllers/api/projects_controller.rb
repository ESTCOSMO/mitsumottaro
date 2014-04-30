class Api::ProjectsController < ApplicationController
  def show
    render json: Project.find(params[:id]).as_json(include: [{ categories: { include: {sub_categories: { include: { stories: { include: :task_points } } } } } }, :project_tasks, :additional_costs ] )
  end

  def create
    render json: {}, status: :ok
  end

  def update
    render json: {}, status: :ok
  end
end
