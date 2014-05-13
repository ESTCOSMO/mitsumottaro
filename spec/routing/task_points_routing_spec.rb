require "spec_helper"

describe TaskPointsController do
  describe "routing" do
    describe "routes to #create," do
      subject{ { post:"/projects/1/categories/2/sub_categories/3/stories/4/task_points" } }
      it{ should be_routable }
      it{ should route_to(controller: "task_points", action: "create",
                          project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4") }
    end

    describe "routes to #destroy," do
      subject{ { delete:"/projects/1/categories/2/sub_categories/3/stories/4/task_points/5" } }
      it{ should be_routable }
      it{ should route_to(controller: "task_points", action: "destroy",
                          project_id: "1", category_id: "2", sub_category_id: "3", story_id: "4", id: "5") }
    end
  end
end
