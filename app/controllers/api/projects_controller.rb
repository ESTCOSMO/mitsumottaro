class Api::ProjectsController < ApplicationController
  def show
    render json: Project.find(params[:id]).as_json(include: [{ categories: { include: {sub_categories: { include: { stories: { include: :task_points } } } } } }, :project_tasks, :additional_costs ] )
  end
end
