class DashboardsController < ApplicationController
  def show
  end

  def archived
    render action: "show"
  end

  def convert
    @project = Project.find(params[:project_id])
    response.headers['Content-Disposition'] = 'attachment; filename="project_' + @project.id.to_s + "_" + Time.now.strftime("%Y%m%d%H%M%S") + '.xml"'
  end
end
