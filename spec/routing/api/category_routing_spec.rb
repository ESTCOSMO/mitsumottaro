require "spec_helper"

describe Api::CategoriesController do
  describe "routing" do
    describe "routes to #show" do
      context "when using url," do
        subject{ { get:"/api/projects/1/categories/2" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "show", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: api_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "show", project_id: "1", id: "2") }
      end
    end
    describe "routes to #move_higher" do
      context "when using url," do
        subject{ { patch: "/api/projects/1/categories/2/move_higher" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "move_higher", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { patch: move_higher_api_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "move_higher", project_id: "1", id: "2") }
      end
    end
    describe "routes to #move_lower" do
      context "when using url," do
        subject{ { patch: "/api/projects/1/categories/2/move_lower" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "move_lower", project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { patch: move_lower_api_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/categories", action: "move_lower", project_id: "1", id: "2") }
      end
    end
    describe "routes to #create" do
      subject{ { post:"/api/projects/1/categories" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/categories", action: "create", project_id: "1") }
    end
    describe "routes to #update" do
      subject{ { put:"/api/projects/1/categories/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/categories", action: "update", project_id: "1", id: "2") }
    end
    describe "routes to #destroy" do
      subject{ { delete: "/api/projects/1/categories/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/categories", action: "destroy", project_id: "1", id: "2") }
    end
  end
end
