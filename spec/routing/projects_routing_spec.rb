require "spec_helper"

describe ProjectsController do
  describe "routing" do

    describe "routes to #index," do
      context "when using url," do
        subject{ { get:"/projects" } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "index") }
      end
      context "when using prefix_path," do
        subject{ { get: projects_path } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "index") }
      end
    end

    describe "routes to #new" do
      context "when using url," do
        subject{ { get:"/projects/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "new") }
      end
      context "when using prefix_path," do
        subject{ { get: new_project_path } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "new") }
      end
    end

    describe "routes to #show" do
      context "when using url," do
        subject{ { get: "/projects/1" } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "show", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: project_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "show", id: "1") }
      end
    end

    describe "routes to #edit" do
      context "when using url," do
        subject{ { get: "/projects/1/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "edit", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_project_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "projects", action: "edit", id: "1") }
      end
    end

    describe "routes to #create" do
      subject{ { post: "/projects" } }
      it{ should be_routable }
      it{ should route_to(controller: "projects", action: "create") }
    end

    describe "routes to #update" do
      subject{ { put: "/projects/1" } }
      it{ should be_routable }
      it{ should route_to(controller: "projects", action: "update", :id => "1") }
    end

    describe "routes to #destroy" do
      subject{ { delete: "/projects/1" } }
      it{ should be_routable }
      it{ should route_to(controller: "projects", action: "destroy", :id => "1") }
    end
  end
end
