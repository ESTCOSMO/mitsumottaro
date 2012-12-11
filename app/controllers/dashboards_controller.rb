class DashboardsController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
  end
end
