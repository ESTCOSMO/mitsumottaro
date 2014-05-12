require "spec_helper"

describe ItemsController do
  describe "routing" do

    describe "routes to #create," do
      subject{ { post:"/projects/1/categories" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "create",
                          project_id: "1") }
    end

    describe "routes to #update," do
      subject{ { put:"/projects/1/categories/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "update",
                          project_id: "1", id: "2") }
    end

    describe "routes to #destroy," do
      subject{ { delete:"/projects/1/categories/2" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "destroy",
                          project_id: "1", id: "2") }
    end

    describe "routes to #move_higher," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/move_higher" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_higher",
                            project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: move_higher_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_higher",
                            project_id: "1", id: "2") }
      end
    end

    describe "routes to #move_lower," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/move_lower" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_lower",
                            project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { get: move_lower_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_lower",
                            project_id: "1", id: "2") }
      end
    end

    describe "routes to #copy," do
      context "when using url," do
        subject{ { post:"/projects/1/categories/2/copy" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "copy",
                            project_id: "1", id: "2") }
      end
      context "when using prefix_path," do
        subject{ { post: copy_project_category_path(project_id: 1, id: 2) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "copy",
                            project_id: "1", id: "2") }
      end
    end
  end
end
