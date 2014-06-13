require "spec_helper"

describe Api::TaskPointsController, :type => :routing do
  describe "routing" do
    describe "routes to #create" do
      subject{ { post: "/api/projects/1/categories/2/sub_categories/3/stories/4/task_points" } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: "api/task_points", action: "create", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
    end
    describe "routes to #destroy" do
      subject{ { delete: "/api/projects/1/categories/2/sub_categories/3/stories/4/task_points/5" } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: "api/task_points", action: "destroy", project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
    end
  end
end
