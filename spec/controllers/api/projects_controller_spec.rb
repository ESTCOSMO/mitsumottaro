require 'spec_helper'

describe Api::ProjectsController do
  before do
    @project = Project.create(name: "Project", days_per_point: 1.0 )
  end
  describe "xhr GET 'show':" do
    before do
      xhr :get, :show, { id: @project.id }
    end
    describe "response status" do
      subject{ response.status }
      it{ should eq  Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] }
    end
    describe "response body" do
      subject{ JSON.parse(response.body) }
      its(["id"]){ should eq @project.id }
      its(["name"]){ should eq @project.name }
      its(["days_per_point"]){ should eq @project.days_per_point.to_s }
      #TODO check inclides json
    end
  end
end
