require "spec_helper"

describe ItemsController, :type => :routing do
  describe "routing" do

    describe "routes to #create," do
      subject{ { post:"/projects/1/categories/2/sub_categories/3/stories" } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: "items", action: "create",
                          project_id: "1", category_id: "2", sub_category_id: "3") }
    end

    describe "routes to #update," do
      subject{ { put:"/projects/1/categories/2/sub_categories/3/stories/4" } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: "items", action: "update",
                          project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
    end

    describe "routes to #destroy," do
      subject{ { delete:"/projects/1/categories/2/sub_categories/3/stories/4" } }
      it{ is_expected.to be_routable }
      it{ is_expected.to route_to(controller: "items", action: "destroy",
                          project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
    end

    describe "routes to #move_higher," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4/move_higher" } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "move_higher",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: move_higher_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "move_higher",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    describe "routes to #move_lower," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4/move_lower" } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "move_lower",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: move_lower_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "move_lower",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    describe "routes to #copy," do
      context "when using url," do
        subject{ { post:"/projects/1/categories/2/sub_categories/3/stories/4/copy" } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "copy",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { post: copy_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ is_expected.to be_routable }
        it{ is_expected.to route_to(controller: "items", action: "copy",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end
  end
end
