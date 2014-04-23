# -*- coding: utf-8 -*-
require "spec_helper"

describe DashboardsController do
  describe "routing" do
    describe "routes to #show" do
      subject{ { get: "/projects/1/dashboard" } }
      it{ should be_routable }
      it{ should route_to(controller: "dashboards", action: "show", project_id: "1") }
    end

    describe "routes to #convert" do
      context "when using url," do
        subject{ { get: "/projects/1/dashboard/convert" } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "convert", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: convert_project_dashboard_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "convert", project_id: "1") }
      end
    end

    # 以下、Routing定義はされているがControllerでの定義がない
    describe "routes to #new" do
      context "when using url," do
        subject{ { get: "/projects/1/dashboard/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "new", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: new_project_dashboard_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "new", project_id: "1") }
      end
    end

    describe "routes to #edit" do
      context "when using url," do
        subject{ { get: "/projects/1/dashboard/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "edit", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_project_dashboard_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "edit", project_id: "1") }
      end
    end

    describe "routes to #create" do
      context "when using url," do
        subject{ { post: "/projects/1/dashboard" } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "create", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { post: project_dashboard_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "create", project_id: "1") }
      end
    end

    describe "routes to #update" do
      subject{ { put: "/projects/1/dashboard" } }
      it{ should be_routable }
      it{ should route_to(controller: "dashboards", action: "update", project_id: "1") }
    end

    describe "routes to #destroy" do
      subject{ { delete: "/projects/1/dashboard" } }
      it{ should be_routable }
      it{ should route_to(controller: "dashboards", action: "destroy", project_id: "1") }
    end
  end
end
