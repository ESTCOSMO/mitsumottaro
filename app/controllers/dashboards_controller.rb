class DashboardsController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
  end

  def buffer_distributed
    @project = Project.find(params[:project_id])
  end
end
