require 'spec_helper'

describe DashboardsController do
  before do
    @project = Project.new(name: "Sample", days_per_point: 0.5)
    @project.save!
  end
  describe "GET 'show'" do
    before{ get :show, { project_id: @project.id } }
    subject{ response }
    it { should be_success }
    it{ should render_template(:show) }
  end
  describe "GET 'convert'" do
    before do
      @expected_header = "attachment; filename=\"project_#{@project.id.to_s}_\\d{8}"
      get :convert, { project_id: @project.id, format: :xml }
    end
    subject{ response.headers['Content-Disposition'] }
    it{ should match @expected_header }
  end
end
