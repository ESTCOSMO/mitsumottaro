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
    describe "routes to #archived" do
      context "when using url," do
        subject{ { get: "/projects/1/dashboard/archived" } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "archived", project_id: "1") }
      end
      context "when using prefix_path," do
        subject{ { get: archived_project_dashboard_path(project_id: 1) } }
        it{ should be_routable }
        it{ should route_to(controller: "dashboards", action: "archived", project_id: "1") }
      end
    end
  end
end
