# -*- coding: utf-8 -*-
require "spec_helper"

describe ItemsController do
  describe "routing" do

    describe "routes to #create," do
      subject{ { post:"/projects/1/categories/2/sub_categories/3/stories" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "create",
                          project_id: "1", category_id: "2", sub_category_id: "3") }
    end

    describe "routes to #update," do
      subject{ { put:"/projects/1/categories/2/sub_categories/3/stories/4" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "update",
                          project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
    end

    describe "routes to #destroy," do
      subject{ { delete:"/projects/1/categories/2/sub_categories/3/stories/4" } }
      it{ should be_routable }
      it{ should route_to(controller: "items", action: "destroy",
                          project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
    end

    describe "routes to #move_higher," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4/move_higher" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_higher",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: move_higher_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_higher",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    describe "routes to #move_lower," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4/move_lower" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_lower",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: move_lower_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "move_lower",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    describe "routes to #copy," do
      context "when using url," do
        subject{ { post:"/projects/1/categories/2/sub_categories/3/stories/4/copy" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "copy",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { post: copy_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "copy",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    # 以下、Routing定義はされているがControllerでの定義がない
    describe "routes to #index," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "index",
                            project_id: "1", category_id: "2", sub_category_id: "3") }
      end
      context "when using prefix_path," do
        subject{ { get: project_category_sub_category_stories_path(project_id: 1, category_id: 2, sub_category_id: 3) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "index",
                            project_id: "1", category_id: "2", sub_category_id: "3") }
      end
    end

    describe "routes to #new," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/new" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "new",
                            project_id: "1", category_id: "2", sub_category_id: "3") }
      end
      context "when using prefix_path," do
        subject{ { get: new_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "new",
                            project_id: "1", category_id: "2", sub_category_id: "3") }
      end
    end

    describe "routes to #show," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "show",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "show",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end

    describe "routes to #edit," do
      context "when using url," do
        subject{ { get:"/projects/1/categories/2/sub_categories/3/stories/4/edit" } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "edit",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
      context "when using prefix_path," do
        subject{ { get: edit_project_category_sub_category_story_path(project_id: 1, category_id: 2, sub_category_id: 3, id: 4) } }
        it{ should be_routable }
        it{ should route_to(controller: "items", action: "edit",
                            project_id: "1", category_id: "2", sub_category_id: "3", id: "4") }
      end
    end
  end
end
