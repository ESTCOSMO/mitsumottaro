# -*- coding: utf-8 -*-
require "spec_helper"

describe Api::ProjectsController do
  describe "routing" do
    describe "routes to #show" do
      context "when using url," do
        subject{ { get: "/api/projects/1" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "show", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: api_project_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "show", id: "1") }
      end
    end
    describe "routes to #create" do
      subject{ { post: "/api/projects" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/projects", action: "create") }
    end
    describe "routes to #update" do
      subject{ { put: "/api/projects/1" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/projects", action: "update", id: "1") }
    end

    # 以下、Routing定義はされているがControllerでの定義がない
    describe "routes to #index" do
      context "when using url," do
        subject{ { get:"/api/projects" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "index") }
      end
      context "when using prefix_path," do
        subject{ { get: api_projects_path } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "index") }
      end
    end
    describe "routes to #new" do
      context "when using url," do
        subject{ { get:"/api/projects/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "new") }
      end
      context "when using prefix_path," do
        subject{ { get: new_api_project_path } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "new") }
      end
    end
    describe "routes to #edit" do
      context "when using url," do
        subject{ { get:"/api/projects/1/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "edit", id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_api_project_path(id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "api/projects", action: "edit", id: "1") }
      end
    end
    describe "routes to #destroy" do
      subject{ { delete: "/api/projects/1" } }
      it{ should be_routable }
      it{ should route_to(controller: "api/projects", action: "destroy", id: "1") }
    end
  end
end
